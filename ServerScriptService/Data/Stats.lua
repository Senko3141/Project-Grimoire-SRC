-- Data Server
--[[
	Written by Senko, 12-29-2020
]]

local DataStore = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RS = game:GetService("RunService")

local Save = DataStore:GetDataStore("PlayerStats_Save")

local StatsTemplate = script:WaitForChild("StatsTemplate")

local CanSave = false

local DataTypes = {
	["string"] = "StringValue",
	number = "IntValue",
	boolean = "BoolValue"
};

local function getSave(plr)
	if not plr then
		warn'no player arg'
		return;
	end
	local plrSave = Save:GetAsync(plr.UserId.."/Stats")
	if plrSave then
		-- has data
		return true, plrSave
	end
	return false, "None"
end

local function saveData(plr, data)
	if not plr or not data then
		warn'no plr or data arg'
		return;
	end
	
	local toSave = {};
	for _,obj in pairs(data:GetChildren()) do
		toSave[obj.Name] = obj.Value
	end
	
	local s,e = pcall(function()
		Save:SetAsync(plr.UserId.."/Stats", toSave)
	end)
	if s then
		warn("[SERVER] Successfully saved STATS data for ".. plr.Name)
	else
		warn("[SERVER] Error when saving STATS data for ".. plr.Name.. " | Error: ".. e)
	end
end

-- add 3 per level up

Players.PlayerAdded:Connect(function(plr)
	local hasSave, statsData = getSave(plr)
	
	local statsFolder = Instance.new("Folder", plr)
	statsFolder.Name = "Stats"
	
	if hasSave then
		-- has data
		for index,value in pairs(statsData) do
			local newInst = Instance.new(DataTypes[typeof(value)], statsFolder)
			newInst.Name = index
			newInst.Value = value
		end
	else
		-- doesn't have save
		for _,obj in pairs(StatsTemplate:GetChildren()) do
			local newInst = obj:Clone()
			newInst.Parent = statsFolder
		end
	end
	
	warn("[SERVER] Successfully loaded STATS data for ".. plr.Name)
end)

Players.PlayerRemoving:Connect(function(plr)
	if not RS:IsStudio() then
		if CanSave == false then return end
		
		saveData(plr, plr.Stats)
	end
end)

game:BindToClose(function()
	if RS:IsStudio() then
		if CanSave == false then return end
		
		for _,plr in next, Players:GetPlayers() do
			saveData(plr, plr.Stats)
		end
	end
end)
