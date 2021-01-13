-- Mana System

local Storage = game:GetService("ReplicatedStorage")

local Remotes = Storage:WaitForChild("Remotes")
local Event = Remotes.UpdateStats

local m = {};

function m:Update(amount)
	Event:InvokeServer({
		Stat = "Mana",
		Amount = amount
	})
end


return m 
