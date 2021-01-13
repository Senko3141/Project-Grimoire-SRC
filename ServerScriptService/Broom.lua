-- Broom Server

local Storage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Remotes = Storage:WaitForChild("Remotes")
local Items = Storage:WaitForChild("Items")

local Event = Remotes.Broom
local Model = Items.Broom

Event.OnServerInvoke = function(plr, data)
	if not data or not data.Action then return end
	
	local action = data.Action
	if action == "Create" then
		local clone = Model:Clone()
		clone.Name = plr.Name.."/Broom"
		clone.Parent = plr.Character
		
		clone.Weld.Part1 = plr.Character:WaitForChild("HumanoidRootPart")
		return clone
	end
	if action == "Remove" then
		local model = data.Model
		model:Destroy()
	end
end
