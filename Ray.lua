local Ray = {}

function Ray:cast(objects)
	local closest = math.huge;
	local hit, pos, normal;

	for i = 1, #objects do
		local obj = objects[i];
		local h, p, n = obj:intersect(self);
		if h then
			local dist = (p - self.origin).magnitude;
			if dist < closest then
				closest = dist;
				hit, pos, normal = h, p, n;
			end
		end
	end

	return hit, pos, normal;
end

local function new(origin, dir)
	return setmetatable({
		origin = origin + dir:unit() * 0.01;
		dir = dir:unit();
	}, {
		__index = function(t, i)
			return Ray[i];
		end
	});
end

return {new = new};