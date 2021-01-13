-- Grimoire Client

local CAS = game:GetService("ContextActionService")
local Storage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Remotes = Storage:WaitForChild("Remotes")
local Event = Remotes.Grimoire

local Active = false
local PrevToggle = os.clock()
local ToggleCD = 1

CAS:BindAction("ToggleGrimoire", function(name, state, obj)
	if state == Enum.UserInputState.Begin then
		if Player.Character.Humanoid.Health == 0 then
			Active = false
			print'died'
			return;
		end
		
		print'toggle'
		
		if (os.clock() - PrevToggle) >= ToggleCD then
			Active = not Active
			PrevToggle = os.clock()
			
			Event:InvokeServer({
				Action = "Toggle",
				Bool = Active
			});
		end
	end
end, false, Enum.KeyCode.One)
