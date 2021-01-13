-- Level/EXP Server

local DataStore = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RS = game:GetService("RunService")

local Save = DataStore:GetDataStore("Level/EXP_Save")
local Template = script:WaitForChild("Spins Template")

local CanSave = false

local function getSave(plr)
	if not plr then
		warn'no player arg'
		return;
	end
	local plrSave = Save:GetAsync(plr.UserId.."/Spins")
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
		Save:SetAsync(plr.UserId.."/Spins", toSave)
	end)
	if s then
		warn("[SERVER] Successfully saved Spins data for ".. plr.Name)
	else
		warn("[SERVER] Error when saving Spins data for ".. plr.Name.. " | Error: ".. e)
	end
end

-- add 3 per level up

Players.PlayerAdded:Connect(function(plr)
	local hasSave, spinsData = getSave(plr)
	
	local spinsFolder = Instance.new("Folder", plr)
	spinsFolder.Name = "Spins"

	if hasSave then
		-- has data
		for index,value in pairs(spinsData) do
			local newInst = Instance.new("IntValue", spinsFolder)
			newInst.Name = index
			newInst.Value = value
		end
	else
		-- doesn't have save
		for _,obj in pairs(Template:GetChildren()) do
			local newInst = obj:Clone()
			newInst.Parent = spinsFolder
		end
	end

	warn("[SERVER] Successfully loaded Spins data for ".. plr.Name)
	
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

		saveData(plr, plr.Spins)
	end
end)

game:BindToClose(function()
	if RS:IsStudio() then
		if CanSave == false then return end

		for _,plr in next, Players:GetPlayers() do
			saveData(plr, plr.Spins)
		end
	end
end)
