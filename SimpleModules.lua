
local RunService = game:GetService('RunService')

local SimpleModule = require(script.SimpleModule)

local function log(message)
	if RunService:IsStudio() then
		print(message)
	end
end

local SimpleModules = {
	_modules = {};
}

function SimpleModules:Get(module)
	if SimpleModules._modules[module] then
		return SimpleModules._modules[module]
	end
end

function SimpleModules.new(module)
	repeat task.wait() until not (_G.Communication == nil)

	local SimpleModuleClass = SimpleModule.new(module)
	
	SimpleModules._modules[module.Name] = SimpleModuleClass

	log('>>> Initialized '..module.Name..'.')
	
	return SimpleModuleClass
end

function SimpleModules:__init(Simple)
	--[[
    log(">> Initializing Simple's modules.")
	
	log(">> Initialized Simple's modules.")
	--]]
end


return SimpleModules