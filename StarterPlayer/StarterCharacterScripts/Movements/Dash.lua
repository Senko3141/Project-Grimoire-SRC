-- Dash System

local UserInputService = game:GetService("UserInputService")
local CP = game:GetService("ContentProvider")
local TS = game:GetService("TweenService")

local Player = game:GetService("Players").LocalPlayer

local Char = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild('Humanoid')

Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)

local MoveDir = Char.HumanoidRootPart

local Deb = false

for _,v in pairs(script:GetChildren()) do
	if v:IsA("Animation") then
		CP:PreloadAsync({v})		
	end
end

local Forward = Humanoid:LoadAnimation(script:WaitForChild("Forward"))
local Back = Humanoid:LoadAnimation(script:WaitForChild("Back"))
local Left = Humanoid:LoadAnimation(script:WaitForChild("Left"))
local Right = Humanoid:LoadAnimation(script:WaitForChild("Right"))

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == Enum.KeyCode.Q then
		if Char:FindFirstChild(Player.Name.."/Broom") then return end
		
		local KeysPressed = UserInputService:GetKeysPressed()


		for i,v in pairs(KeysPressed) do
			if Deb then return end

			if v.KeyCode == Enum.KeyCode.W then
				coroutine.resume(coroutine.create(function()
					Deb = true
					wait(1)
					Deb = false
				end))
				
				local bv = Instance.new("BodyVelocity", Char.HumanoidRootPart)
				bv.MaxForce = Vector3.new(99999,99999,99999)
				bv.Velocity = Char.HumanoidRootPart.CFrame.lookVector * 50

				Forward:Play()


				--	Char.HumanoidRootPart.Velocity = Char.HumanoidRootPart.Velocity * 12

				game.Debris:AddItem(bv, 0.3)	
			elseif v.KeyCode == Enum.KeyCode.A then


				coroutine.resume(coroutine.create(function()
					Deb = true
					wait(1)
					Deb = false
				end))

				Left:Play()

				local bv = Instance.new("BodyVelocity", Char.HumanoidRootPart)
				bv.MaxForce = Vector3.new(99999,99999,99999)
				bv.Velocity = -(Char.HumanoidRootPart.CFrame.RightVector * 50)

				game.Debris:AddItem(bv, 0.3)				
			elseif v.KeyCode == Enum.KeyCode.S then
				coroutine.resume(coroutine.create(function()
					Deb = true
					wait(1)
					Deb = false
				end))

				Back:Play()

				local bv = Instance.new("BodyVelocity", Char.HumanoidRootPart)
				bv.MaxForce = Vector3.new(99999,99999,99999)
				bv.Velocity = -(Char.HumanoidRootPart.CFrame.lookVector * 50)

				game.Debris:AddItem(bv, 0.3)	

			elseif v.KeyCode == Enum.KeyCode.D then


				coroutine.resume(coroutine.create(function()
					Deb = true
					wait(1)
					Deb = false
				end))

				Right:Play()

				local bv = Instance.new("BodyVelocity", Char.HumanoidRootPart)
				bv.MaxForce = Vector3.new(99999,99999,99999)
				bv.Velocity = (Char.HumanoidRootPart.CFrame.RightVector * 50)

				game.Debris:AddItem(bv, 0.3)	
			end
		end		
	end	
end)
