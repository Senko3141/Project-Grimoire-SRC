-- Broom System Re-Make

local Storage = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local WSP = game:GetService("Workspace")
local RS = game:GetService("RunService")

local Remotes = Storage:WaitForChild("Remotes")
local Event = Remotes.Broom

local Config = {
	Speed = 40,
	SprintSpeed = 60,	
};

local m = {};
m.__index = m

function m.init(plr)
	-- creating body velocities
	
	for _,v in pairs(plr.Character.Humanoid:GetPlayingAnimationTracks()) do
		v:Stop(0.05)
	end	

	local BV = Instance.new("BodyVelocity", plr.Character.HumanoidRootPart)
	BV.Name = "BroomVelocity"
	BV.MaxForce = Vector3.new(9999,9999,9999)
	BV.Velocity = Vector3.new(0,0,0)
	
	--
	
	local self = setmetatable({}, m)
	self.Owner = plr
	self.Mouse = plr:GetMouse()
	self.Broom = Event:InvokeServer({
		Action = "Create"
	});
	self.Anim = plr.Character.Humanoid:LoadAnimation(script.Fly)
	self.Velocity = BV
	self.Functions = require(self.Owner:WaitForChild("PlayerScripts"):WaitForChild"PlayerModule")
	
	self.Sprinting = false
	self.Moving = false
	
	self.Anim:Play()
	
	self.Functions:ToggleShiftLock(false, true, true)
	
	return self 
end

function m:Fly(bool)
	local mouse = self.Mouse
	local bv = self.Velocity
	
	RS:BindToRenderStep("UpdateSpeed", Enum.RenderPriority.Camera.Value, function()
		if self.Moving == true then			
			-- move
			if self.Sprinting == true then
				-- sprinting
				bv.Velocity = mouse.Hit.LookVector * Config.SprintSpeed
			else
				-- not sprinting
				bv.Velocity = mouse.Hit.LookVector * Config.Speed
			end
		elseif self.Moving == false then
			-- not moving
			bv.Velocity = Vector3.new(0,0,0)
		end
	end)
	
	if bool == true then
		-- fly
		self.Moving = true
	end
	if bool == false then
		-- stop flying
		self.Moving = false
	end
end

function m:Sprint(bool)
	local mouse = self.Mouse
	local bv = self.Velocity
	
	if bool == true then
		-- sprint
		self.Sprinting = true
		TS:Create(WSP.CurrentCamera, TweenInfo.new(0.5), {
			FieldOfView = 80,
		}):Play()
	end
	if bool == false then
		-- stop sprint
		self.Sprinting = false
		TS:Create(WSP.CurrentCamera, TweenInfo.new(0.5), {
			FieldOfView = 70,
		}):Play()
	end
end

function m:Terminate()
	print("Remove")
	Event:InvokeServer({
		Model = self.Broom,
		Action = "Remove"
	});
	
	self.Functions:ToggleShiftLock(true, true, true)
	RS:UnbindFromRenderStep("UpdateSpeed")
	
	TS:Create(WSP.CurrentCamera, TweenInfo.new(0.5), {
		FieldOfView = 70,
	}):Play()
	
	self.Owner = nil
	self.Mouse = nil
	self.Broom = nil
	self.Functions = nil
	
	self.Velocity:Destroy()
	self.Anim:Stop(0.05)
	
	self.Anim = nil
	self.Velocity = nil
	
	self = nil
end

return m 
