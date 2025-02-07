
local RunService = game:GetService('RunService')

local SimpleReplica = {}

SimpleReplica.Data = {}


function SimpleReplica:__init(Simple)
	repeat task.wait() until not (_G.Communication == nil)
	
	if RunService:IsServer() then
		_G.Simple.Packages.packages.Signal.new('Replica', 'Event')
	elseif RunService:IsClient() then
		_G.Simple.Packages.packages.Signal:Listen('Replica', 'SERVER', function(data)
			SimpleReplica.Data = data
		end)
	end
end

return SimpleReplica
