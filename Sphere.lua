local Sphere = {}

function Sphere:intersect(ray)
	local d = ray.dir;
	local v = self.pos - ray.origin;

	local dot = d:dot(v);

	if dot > 0 then --facing correct direction?
		local perp = v - (d * dot); -- vector from ray to centre of sphere
		if perp.magnitude <= self.radius then -- centre of sphere close enough to ray?
			local xdist = (self.radius ^ 2 - perp.magnitude ^ 2)^0.5;
			local pos = ray.origin + d * (dot - xdist);
			local normal = (pos - self.pos):unit();
			return self, pos, normal;
		end
	end
end

local function new(pos, radius, color, reflectance)
	return setmetatable({
		pos = pos,
		radius = radius,
		color = color,
		reflectance = reflectance
	}, {
		__index = function(t, i)
			return Sphere[i];
		end
	});
end

return {new = new};