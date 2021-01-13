-- Grimoire

local Players = game:GetService("Players")
local Storage = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")

local Grimoires = Storage:WaitForChild("Grimoires")
local Remotes = Storage:WaitForChild("Remotes")

local Event = Remotes.Grimoire

local function randomGrim()
	local Things = Grimoires:GetChildren()
	local random = math.random(1, #Things)
	
	return Things[random]
end

Event.OnServerInvoke = function(plr, data)
	if not data or not data.Action then return end
	
	local action = data.Action
	local bool = data.Bool
	
	if action == "Toggle" then
		if plr.Character:FindFirstChild("Dead") then return end
		-- getting grimoire
		local Grimoire = plr.Character:FindFirstChild(plr.Name.."/Grimoire")
		if Grimoire then
			if bool == true then
				-- activate
				if Grimoire.Transparency == 0 then
					return;
				end
				TS:Create(Grimoire, TweenInfo.new(0.5), {
					Transparency = 0
				}):Play()
			end
			if bool == false then
				-- de-activate
				if Grimoire.Transparency == 1 then
					return;
				end
				TS:Create(Grimoire, TweenInfo.new(0.5), {
					Transparency = 1
				}):Play()
			end
		end	
	end
end

Players.PlayerAdded:Connect(function(plr)
	local grim = Instance.new("StringValue", plr)
	grim.Name = "Grimoire"
	grim.Value = randomGrim().Name
	
	plr.CharacterAdded:Connect(function(char)
		local found = Grimoires:FindFirstChild(grim.Value)
		if found then
			local clone = found:Clone()
			clone.Parent = char
			clone.Name = plr.Name.."/Grimoire"
			clone.Anchored = false
			clone.CanCollide = false
			clone.Transparency = 1
			
			if clone:FindFirstChild("Torso") then
				clone.Torso.Part1 = char:WaitForChild("Torso")
			else
				warn("[SERVER] Grimoires, fatal error: could not find Torso weld in object.")
			end	
		else
			warn("[SERVER] Grimoires, fatal error. Could not find: ".. grim.Value..'.')
		end
	end)
end)
