-- Interaction Handler

local Players = game:GetService("Players")
local WSP = game:GetService("Workspace")
local CAS = game:GetService("ContextActionService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Storage = game:GetService("ReplicatedStorage")

local Modules = Storage:WaitForChild("Modules")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Interactions = WSP:WaitForChild("NPCs")

local Dialogue = require(Modules.Dialogue)
local Writer = require(Modules.Typewriter)

local UI = script.Parent
local Holder = UI:WaitForChild("Holder")

local InteractionDistance = 10
local Chosen = "None"

local Open = false

local YesCon;
local NoCon;

local function getDist(a, b)
	return (a - b).magnitude
end

local function toggleSpeed(bool)
	if bool == false then
		
		
		Character.Humanoid.WalkSpeed = 0
		Character.Humanoid.JumpPower = 0
	end
	
	if bool == true then
		Character.Humanoid.WalkSpeed = 16
		Character.Humanoid.JumpPower = 50
	end
end

local function handleInteract(on)
	if on ~= nil then
		
		local Type = on.Type
		
		if Type == "Regular" then
			Writer.typeWrite(Holder.Body.Dialogue, on.Dialogue)
			
			Holder.Body.No.Button.Text = on.Responses.No
			Holder.Body.Yes.Button.Text = on.Responses.Yes
			
			Holder.Body.No.Visible = true
			Holder.Body.Yes.Visible = true
		end
		if Type == "End" then
			Holder.Body.No.Visible = false
			Holder.Body.Yes.Visible = false
			Writer.typeWrite(Holder.Body.Dialogue, on.Dialogue)
			
			if on.Func then
				on.Func(script.Parent.Parent)
			end
			
			wait(0.5)
			Holder:TweenPosition(UDim2.new(0.275,0,1.1,0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
			toggleSpeed(true)	
			
			WSP.CurrentCamera.CameraType = Enum.CameraType.Custom
			
			wait(0.5)
			Holder.Body.Dialogue.Text = ""
			Holder.Body.No.Button.Text = ""
			Holder.Body.Yes.Button.Text = ""
			Open = false
		end
		
		
	end
end

RS:BindToRenderStep("ScanArea", Enum.RenderPriority.Camera.Value, function()
	for _,v in pairs(Interactions:GetChildren()) do
		
		local a = Character.HumanoidRootPart.Position
		local b = v.HumanoidRootPart.Position
		
		local dist = getDist(a, b)
		if dist <= InteractionDistance then
			-- pull up boi
			TS:Create(v.Head.Indicator.Holder, TweenInfo.new(0.2), {
				Position = UDim2.new(0,0,0,0)
			}):Play()
			Chosen = v
		else
			TS:Create(v.Head.Indicator.Holder, TweenInfo.new(0.5), {
				Position = UDim2.new(0,0,1,0)
			}):Play()
			Chosen = "None"
		end
		
	end
end)

CAS:BindAction("Interact", function(name, state, obj)	
	if Open == true then return end
	
	if state == Enum.UserInputState.Begin then
		if Chosen ~= "None" then
			WSP.CurrentCamera.CameraType = Enum.CameraType.Scriptable
			toggleSpeed(false)
			Open = true
			
			Holder:TweenPosition(UDim2.new(0.275,0,0.73,0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
			
			local npcDialogue = Dialogue.Get(Chosen.Name)	
			if npcDialogue then
				-- got thing
				
				local on = 1
				
				local dialogue1 = npcDialogue[on]
				handleInteract(dialogue1)
				
				YesCon = Holder.Body.Yes.Button.MouseButton1Click:Connect(function()
					on = 2
					handleInteract(npcDialogue[on])
					YesCon:Disconnect()
					NoCon:Disconnect()
				end)

				NoCon = Holder.Body.No.Button.MouseButton1Click:Connect(function()
					on = 3
					handleInteract(npcDialogue[on])
					YesCon:Disconnect()
					NoCon:Disconnect()
				end)
				
			end
			
		end
	end
end, false, Enum.KeyCode.E)
