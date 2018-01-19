local Vector3 = {};

local function new(x, y, z)
	local magnitude = (x*x + y*y + z*z)^0.5;
	return setmetatable({
		x = x,
		y = y,
		z = z,
		magnitude = magnitude
	}, {
		__index = function(t, i)
			return Vector3[i];
		end;

		__add = function(v1, v2)
			return new(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
		end;

		__sub = function(v1, v2)
			return new(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
		end;

		__mul = function(v1, v2)
			if type(v2) == "number" then
				return new(v1.x * v2, v1.y * v2, v1.z * v2);
			else
				return new(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z);
			end
		end;
	});
end

function Vector3:cross(v2)
	return new(
		self.y * v2.z - self.z * v2.y,
		self.z * v2.x - self.x * v2.z,
		self.x * v2.y - self.y * v2.x
	);
end

function Vector3:dot(v2)
	return self.x * v2.x + self.y * v2.y + self.z * v2.z;
end

function Vector3:unit()
	return new(self.x/self.magnitude, self.y/self.magnitude, self.z/self.magnitude);
end


return {new = new};