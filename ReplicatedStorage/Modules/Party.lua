-- Party Module
--[[
	Methods:

	init, remove, leave, invite, kick
]]

local HTTP = game:GetService("HttpService")

local m = {};
m.__index = m


function m.Init(player)
	local self = setmetatable({}, m)
	
	self.Owner = player
	self.Members = {player}; --> 1 = Owner
	self.Indicators = {};
	self.PendingInvites = {};
	self.ID = HTTP:GenerateGUID(false)
	
	warn("[PARTY] Successfully created party for ".. player.Name.. "| ID: ".. self.ID)
	
	return self
end

function m:Disband(id)
	local Indicators = self.Indicators
	local Invites = self.PendingInvites
	
	local ID = self.ID
	
	-- remove indicators
	
	if not id == ID then
		warn("[PARTY] Could not disband party as the id: ".. id.. " doesnt match the party ID.")
		return;
	end
	
	if not #Indicators then
	else
		-- has indicator
		for _,indicator in pairs(Indicators) do
			indicator:Destroy()
		end
	end
	
	-- removing invites
	
	if not #Invites then
	else
		-- has invite
		for _,invite in pairs(Invites) do
			invite = nil
		end
	end
	
	self = nil
end

function m:Leave(id, target)
	local Members = self.Members
	local Indicators = self.Indicators

	local ID = self.ID

	if not id == ID then
		warn("[PARTY] Could not leave party: ".. self.Owner.Name.." because the id ".. id.." doesn't match the party's ID.")
	end

	if Members[target.Name] then
		Members[target.Name] = nil

		-- checking for indicator
		for _,indicator in pairs(Indicators) do
			if indicator.Owner.Name == target.Name then
				indicator:Destroy()
			end
		end

		warn("[PARTY] Successfully left ".. self.Owner.Name.."s party.")
	else
		warn("[PARTY] Could not find party member ".. target.Name..".")
		return;
	end
end

function m:Invite()
	
end

function m:Kick(id, target)
	local Members = self.Members
	local Indicators = self.Indicators
	
	local ID = self.ID
	
	if not id == ID then
		warn("[PARTY] Could not kick ".. target.Name.." because the id ".. id.." doesn't match the party's ID.")
	end
	
	if Members[target.Name] then
		Members[target.Name] = nil
		
		-- checking for indicator
		for _,indicator in pairs(Indicators) do
			if indicator.Owner.Name == target.Name then
				indicator:Destroy()
			end
		end
		
		warn("[PARTY] Successfully kicked ".. target.Name.." from the party.")
	else
		warn("[PARTY] Could not find party member ".. target.Name..".")
		return;
	end
end


return m 
