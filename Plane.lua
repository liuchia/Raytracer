local Plane = {}

function Plane:intersect(ray)
	local normal = ray.dir:dot(self.normal) > 0 and self.normal or self.normal * -1;

	local denom = ray.dir:dot(normal);
	if denom > 1e-6 then
		local t = (self.pos-ray.origin):dot(normal) / denom;
		if t > 0 then
			local pos = ray.origin + ray.dir * t;
			return self, pos, normal * -1;
		end
	end
end

local function new(pos, normal, color, reflectance)
	return setmetatable({
		pos = pos,
		normal = normal,
		color = color,
		reflectance = reflectance
	}, {
		__index = function(t, i)
			return Plane[i];
		end
	});
end

return {new = new};