
local RunService = game:GetService('RunService')

local SimpleModule = require(script.SimpleModule)

local SimpleModules = {
	_modules = {};
}

function SimpleModules:Get(module)
	if SimpleModules._modules[module] == nil or SimpleModules._modules[module]._module == 'none' then
		repeat task.wait(); print(SimpleModules._modules) until not (SimpleModules._modules[module] == nil) and not (SimpleModules._modules[module]._module == 'none')
	end

	if SimpleModules._modules[module] then
		return SimpleModules._modules[module]._module
	end
end

function SimpleModules.new(module)
	repeat task.wait() until not (_G.Communication == nil)

	local SimpleModuleClass = SimpleModule.new(module)
	
	SimpleModules._modules[module.Name] = SimpleModuleClass

	_G.Simple.Throw.Log('>>> Initialized '..module.Name..'.')
	
	return SimpleModuleClass
end

function SimpleModules:__init(Simple)

end


return SimpleModules
