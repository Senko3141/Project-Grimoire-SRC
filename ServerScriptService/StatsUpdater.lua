-- Stats Updater

local Players = game:GetService("Players")
local Storage = game:GetService("ReplicatedStorage")

local Remotes = Storage:WaitForChild("Remotes")

local Updater = Remotes.UpdateStats
local Checker = Remotes.CheckStats

local function getEXPForLevel(level)
	return 8 + 6*(level - 1) + 6*(level - 1)^2
end

local healthMultiplier = 1.5

Players.PlayerAdded:Connect(function(plr)
	local plrStats = plr:WaitForChild("Stats", 10)
	
	local level = plr["Levels/EXP"]:WaitForChild("Level")
	local exp = plr["Levels/EXP"]:WaitForChild("EXP")
	
	exp.Changed:Connect(function()		
		local required = getEXPForLevel(level.Value)
		if exp.Value >= required then
			exp.Value = 0
			level.Value = level.Value + 1
		end
	end)
	
	plrStats.Health.Changed:Connect(function()
		plr.Character.Humanoid.MaxHealth = 100 +  plrStats.Health.Value * healthMultiplier
	end)
end)

Updater.OnServerEvent:Connect(function(plr, data)
	if not data or not data.Stat then return end
	
	local stat = data.Stat
	
	if stat == "Mana" then		
		local amount = data.Amount
		
		plr.Character.Stats.Mana.Value = plr.Character.Stats.Mana.Value + tonumber(amount)
	end
	
end)

Checker.OnServerInvoke = function(plr, data)
	if not data or not data.Stat then return end
	
	local stat = data.Stat
	
	if stat == "Mana" then
		if plr.Character.Stats.Mana.Value >= 0 then
			return true
		end
		return false
	end
end
