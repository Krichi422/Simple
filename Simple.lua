

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')

local SERVER_ONLY_SIMPLE_FEATURES = { 'SimpleData' }
local CLIENT_ONLY_SIMPLE_FEATURES = { }

local ALPHA_VERSIONS = {}
local RELEASED_VERSIONS = {}

local Ver = tostring(script.PackageLink.VersionNumber)

local Simple = {}

function Simple:__init()
	if RunService:IsStudio() then
		print('Simple is initializing in STUDIO. Enabling debug prints.')
	end
	
	local InitiatedTick = tick()
	
	Simple.Throw = require(script.SimplePackages.Throw).new(script)
	
	Simple.Throw.Log('> Initializing Simple V'..Ver..'.')
	
	_G.Simple = Simple
	
	Simple['Packages'] = require(script.SimplePackages)
	Simple['Packages'].__init(Simple)

	for _, package in ipairs(script:GetChildren()) do
		local FormattedName = string.gsub(package.Name, 'Simple', '')
		
		if package:IsA('ModuleScript') and not (Simple[FormattedName]) then
			if (table.find(SERVER_ONLY_SIMPLE_FEATURES, package.Name) and RunService:IsServer()) or (table.find(CLIENT_ONLY_SIMPLE_FEATURES, package.Name) and RunService:IsClient()) or (not (table.find(CLIENT_ONLY_SIMPLE_FEATURES, package.Name)) and not (table.find(SERVER_ONLY_SIMPLE_FEATURES, package.Name))) then	
				Simple[FormattedName] = require(package)
				Simple[FormattedName]:__init(Simple)
			end
		end
	end

	Simple.Throw.Log('> Simple initialized successfully in '..tostring(tick() - InitiatedTick)..' seconds.')
end

return Simple
