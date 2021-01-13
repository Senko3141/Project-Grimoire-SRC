-- Broom Activater

--[[

	fix can dashing in mid-air
]]

repeat wait() until script.Parent

local UIS = game:GetService("UserInputService")
local Storage = game:GetService("ReplicatedStorage")
local CP = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local CAS = game:GetService("ContextActionService")
local RS = game:GetService("RunService")
local WSP = game:GetService("Workspace")

local Player = Players.LocalPlayer
local BroomModule = require(Storage:WaitForChild("Modules").Broom)

local Char = script.Parent
local Humanoid = Char:WaitForChild("Humanoid")

local PrevSpace = "None"

local ToggleCD = 1
local Interval = 0.5

local PrevToggle = os.clock()

local CurrentBroom;

Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)

local function removeBrrom()
	if typeof(CurrentBroom) == "table" then
		-- de-activate
		RS:UnbindFromRenderStep("CheckBelow")

		CAS:UnbindAction("Fly")
		CAS:UnbindAction("Sprint")

		CurrentBroom:Sprint(false)
		CurrentBroom:Fly(false)

		CurrentBroom:Terminate()
		CurrentBroom = nil
	end
end

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == Enum.KeyCode.Space then
		if PrevSpace == "None" then
			PrevSpace = os.clock()
			return;
		end

		PrevSpace = os.clock()
	end

	if input.KeyCode == Enum.KeyCode.G then
		if Humanoid.Health == 0 then
			removeBrrom()
			return;
		end
		
		
		if (os.clock() - PrevSpace) <= Interval and (os.clock() - PrevToggle) >= ToggleCD then
			PrevToggle = os.clock()
						
			if CurrentBroom == nil then
				-- activate
				CurrentBroom = BroomModule.init(Player)
				
				RS:BindToRenderStep("CheckBelow", Enum.RenderPriority.Camera.Value, function()
					local origin = Char.HumanoidRootPart.Position
					local direction = Char.HumanoidRootPart.CFrame.UpVector - Vector3.new(0, 5, 0)

					local raycastParams = RaycastParams.new()
					raycastParams.FilterDescendantsInstances = {WSP.Map}
					raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
					local raycastResult = workspace:Raycast(origin, direction, raycastParams)

					if raycastResult then
						warn("Underneath player: ".. raycastResult.Instance.Name)
						
						removeBrrom()
					end
				end)
				
				CAS:BindAction("Fly", function(name, state, obj)
					if state == Enum.UserInputState.Begin then
						
						CAS:BindAction("Sprint", function(name2, state2, obj2)
							if state2 == Enum.UserInputState.Begin then
								CurrentBroom:Sprint(true)
							end
							if state2 == Enum.UserInputState.End then
								CurrentBroom:Sprint(false)
							end
						end, false, Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift)
						
						CurrentBroom:Fly(true)
					end
					if state == Enum.UserInputState.End then
						CurrentBroom:Fly(false)
						CurrentBroom:Sprint(false)
					end
				end, false, Enum.KeyCode.W)
				return;
			end
			
			if typeof(CurrentBroom) == "table" then
				-- de-activate
				
				removeBrrom()
				return;
			end
		end
	end
end)

Humanoid.Died:Connect(function()
	if typeof(CurrentBroom) == "table" then
		-- de-activate
		removeBrrom()
	end
end)
