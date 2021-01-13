-- Level/EXP Server

local DataStore = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RS = game:GetService("RunService")

local Save = DataStore:GetDataStore("Level/EXP_Save")
local Template = script:WaitForChild("EXP/Level Template")

local CanSave = false

local function getSave(plr)
	if not plr then
		warn'no player arg'
		return;
	end
	local plrSave = Save:GetAsync(plr.UserId.."/EXP_Level")
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
		Save:SetAsync(plr.UserId.."/EXP_Level", toSave)
	end)
	if s then
		warn("[SERVER] Successfully saved EXP/LEVEL data for ".. plr.Name)
	else
		warn("[SERVER] Error when saving EXP/LEVEL data for ".. plr.Name.. " | Error: ".. e)
	end
end

-- add 3 per level up

Players.PlayerAdded:Connect(function(plr)
	local hasSave, expLevelData = getSave(plr)
	
	local levelsFolder = Instance.new("Folder", plr)
	levelsFolder.Name = "Levels/EXP"

	if hasSave then
		-- has data
		for index,value in pairs(expLevelData) do
			local newInst = Instance.new("IntValue", levelsFolder)
			newInst.Name = index
			newInst.Value = value
		end
	else
		-- doesn't have save
		for _,obj in pairs(Template:GetChildren()) do
			local newInst = obj:Clone()
			newInst.Parent = levelsFolder
		end
	end

	warn("[SERVER] Successfully loaded EXP/LEVEL data for ".. plr.Name)
	
	plr.Chatted:Connect(function(msg)
		msg = msg:lower()
		if msg == "!randomexp" then
			plr.EXP.Value = plr.EXP.Value + math.random(1, 20)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(plr)
	if not RS:IsStudio() then
		if CanSave == false then return end

		saveData(plr, plr['Levels/EXP'])
	end
end)

game:BindToClose(function()
	if RS:IsStudio() then
		if CanSave == false then return end

		for _,plr in next, Players:GetPlayers() do
			saveData(plr, plr['Levels/EXP'])
		end
	end
end)
