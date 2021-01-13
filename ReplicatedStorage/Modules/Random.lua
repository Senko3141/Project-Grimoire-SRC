-- Random Module
--[[
	Written by Senko, 12-29-2020
]]

local m = {};

function m:Choose(tbl)
	local totalWeight = 0
	for name,chance in pairs(tbl) do
		totalWeight += chance
	end
	
	local randomNum = math.random(1, totalWeight)
	local Chosen;
	
	for name,chance in pairs(tbl) do
		if  randomNum <= chance then
			Chosen = {
				['Name'] = name,
				['Chance'] = chance
			};
			break
		else
			randomNum = randomNum - chance
		end
	end
	return Chosen
end

return m 
