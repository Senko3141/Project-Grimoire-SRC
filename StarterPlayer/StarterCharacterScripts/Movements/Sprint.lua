-- Sprint Script

repeat wait() until script.Parent.Parent

local CAS = game:GetService("ContextActionService")
local WSP = game:GetService("Workspace")
local TS = game:GetService("TweenService")
local CP = game:GetService("ContentProvider")
local UIS = game:GetService("UserInputService")

local Character = script.Parent.Parent
local Humanoid = Character:WaitForChild("Humanoid")

local PrevW = os.clock()
local PrevStop = os.clock()

local Connection;

for _,v in pairs(script:GetChildren()) do
	if v:IsA("Animation") then
		CP:PreloadAsync({v})
	end
end

local Run = Humanoid:LoadAnimation(script.Run)

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	
	if input.KeyCode == Enum.KeyCode.W then
		if (os.clock() - PrevW) <= 0.5 then
			if (os.clock() - PrevStop) < 0.5 then return end
			
			print'run'
			
			Connection = input.Changed:Connect(function(prop)
				if prop == "UserInputState" then
					PrevStop = os.clock()
					Connection:Disconnect()
					Humanoid.WalkSpeed = 16
					TS:Create(WSP.CurrentCamera, TweenInfo.new(0.5), {
						FieldOfView = 70
					}):Play()
					Run:Stop(0.05)
				end
			end)
			
			Humanoid.WalkSpeed = 24
			TS:Create(WSP.CurrentCamera, TweenInfo.new(0.5), {
				FieldOfView = 90
			}):Play()
			Run:Play()
			-- can run
		else
			print'no run'
			PrevW = os.clock()
		end
	end
end)
