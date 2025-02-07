
local RunService = game:GetService('RunService')

local function log(message)
	if RunService:IsStudio() then
		print(message)
	end
end

local SimplePackages = {}

SimplePackages.packages = {}

function SimplePackages:__init()
	local index = 0
	local packagecount = #script:GetChildren()
	
	log(">> Unpacking Simple's packages. ("..tostring(packagecount)..")")
	
	for _, package in ipairs(script:GetChildren()) do
		if package:IsA('ModuleScript') then
			SimplePackages.packages[package.Name] = require(package)
			
			if SimplePackages.packages[package.Name]['__init'] then
				SimplePackages.packages[package.Name].__init(self)
			end
			
			index += 1
			
			log('>>> Unpacked '..package.Name..'. ('..tostring(index)..'/'..tostring(packagecount)..')')
		end
	end
	
	log(">> Unpacked Simple's packages. ("..tostring(packagecount)..")")
end

return SimplePackages
