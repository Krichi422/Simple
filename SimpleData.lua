
local RunService = game:GetService('RunService')
local Players = game:GetService('Players')
local DataStoreService = game:GetService('DataStoreService')

local Templates = require(script.Templates)
local ProfileStore = require(script.ProfileStore)

local SimpleData = {}

SimpleData.Profiles = {}
SimpleData.Stores = {}


function SimpleData:UpdateProfile(profile, path, value)
	if not self.Profiles[profile] then
		return
	end

	local FormattedPath = string.split(path, "/")

	if #FormattedPath == 0 then
		return
	end

	local current = self.Profiles[profile]

	for i = 1, #FormattedPath - 1 do
		local key = FormattedPath[i]
		
		if typeof(current) == 'table' and current[key] then
			current = current[key]
		end	
	end

	current[FormattedPath[#FormattedPath]] = value
	
	_G.Simple.Packages.packages.Signal:Send('Replica', profile, 'CLIENT', self.Profiles[profile].Data)
end

function SimpleData:GetProfile(ProfileCategory, ProfileKey)
	if not (SimpleData.Profiles[ProfileCategory]) or not (SimpleData.Profiles[ProfileCategory] and SimpleData.Profiles[ProfileCategory][ProfileKey]) then
		local Tries = 0

		repeat
			Tries += 1
			task.wait(1)
		until (SimpleData.Profiles[ProfileCategory] and SimpleData.Profiles[ProfileCategory][ProfileKey]) or Tries >= 10
	end

	
	if SimpleData.Profiles[ProfileCategory] and SimpleData.Profiles[ProfileCategory][ProfileKey] then
		return SimpleData.Profiles[ProfileCategory][ProfileKey].Data
	end
end

function SimpleData:Load(object)
	if object:IsA('Player') then
		local Profile = SimpleData.Stores['Players']:StartSessionAsync(`Player_{object.UserId}`, {
			Cancel = function()
				return object.Parent ~= Players
			end,
		})

		if not (Profile == nil) then
			Profile:AddUserId(object.UserId)
			Profile:Reconcile()

			Profile.OnSessionEnd:Connect(function()
				SimpleData.Profiles.Players[object] = nil
				object:Kick("Player profile's session ended. Please rejoin.")
			end)
			
		
			if object.Parent == Players then
				SimpleData.Profiles.Players[object] = Profile
			else
				Profile:EndSession()
			end
		else
			object:Kick("Player profile failed to load. Please rejoin.")
		end
	end
end


function SimpleData:CreateStore(name, profile)
	local Tag = ''
	name = name or 'Store'

	if RunService:IsStudio() then
		Tag = 'TEST_'
	end
	
	if profile and profile == true then
		local success, result = pcall(function()
			return ProfileStore.New(Tag..name, Templates.Players.template or {})
		end)

		if success then
			return result
		end
	else
		local success, result = pcall(function()
			return DataStoreService:GetDataStore(Tag..name)
		end)
		
		if success then
			return result
		end
	end
end

function SimpleData:__init(Simple)		
	repeat task.wait() until not (_G.Communication == nil)
	
	if RunService:IsServer() and RunService:IsStudio() then
		_G.Simple.Throw.Warn('>> Please customize Template module according to your preferences.')
	end
	
	if RunService:IsServer() then		
		_G.Simple.Throw.Log(">> Initializing Simple's data for players.")
		
		SimpleData.Profiles = {
			Players = {}
		}
		
		local PlayerStore = SimpleData:CreateStore('PlayerStore', true)
		local PlayerProfiles: {[player]: typeof(PlayerStore:StartSessionAsync())} = {}
		
		SimpleData.Profiles['Players'] = PlayerProfiles	
		SimpleData.Stores['Players'] = PlayerStore
		
		for _, Player in ipairs(Players:GetPlayers()) do
			task.spawn(function() SimpleData:Load(Player) end)
		end
		
		Players.PlayerAdded:Connect(function(Player)
			SimpleData:Load(Player)
		end)
		
		Players.PlayerRemoving:Connect(function(Player)
			local Profile = SimpleData.Profiles['Players'][Player]

			if not (Profile == nil) then
				Profile:EndSession()
			end
		end)
		
		_G.Simple.Throw.Log(">> Initialized Simple's data for players, initializing for other datastore instances.")
		
		for name, template in pairs(Templates) do
			if not (name == 'Players') then
				SimpleData.Stores[name] = SimpleData:CreateStore(name..'Store', false)
			end
		end
		
		_G.Simple.Throw.Log(">> Initialized Simple's data for other datastore instances.")
	end
end

return SimpleData
