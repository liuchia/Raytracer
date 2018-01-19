local Color = {}

local function new(r, g, b)
	return setmetatable({
		r = math.min(r, 255),
		g = math.min(g, 255),
		b = math.min(b, 255)
	}, {
		__index = function(t, i)
			return Color[i];
		end
	});
end

return {new = new};