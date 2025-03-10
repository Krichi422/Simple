
local RunService = game:GetService('RunService')

local SimplePackages = {}

SimplePackages.packages = {}

function SimplePackages:__init()
	local index = 0
	local packagecount = #script:GetChildren()
	
	_G.Simple.Throw.Log(">> Unpacking Simple's packages. ("..tostring(packagecount)..")")
	
	for _, package in ipairs(script:GetChildren()) do
		if package:IsA('ModuleScript') then
			SimplePackages.packages[package.Name] = require(package)
			
			if SimplePackages.packages[package.Name]['__init'] then
				SimplePackages.packages[package.Name].__init(self)
			end
			
			index += 1
			
			_G.Simple.Throw.Log('>>> Unpacked '..package.Name..'. ('..tostring(index)..'/'..tostring(packagecount)..')')
		end
	end
	
	_G.Simple.Throw.Log(">> Unpacked Simple's packages. ("..tostring(packagecount)..")")
end

return SimplePackages
