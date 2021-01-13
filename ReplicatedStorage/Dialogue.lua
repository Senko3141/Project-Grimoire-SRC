-- Dialogue

local m = {};

function m.Get(name)
	if script:FindFirstChild(name) then
		return require(script[name])
	end
end

return m 
