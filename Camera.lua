local K_AMBIENT = 0.2;
local K_DIFFUSE = 0.4;
local K_SPECULE = 0.4;
local K_SHINING = 50;
local DIVIDEBYDIST = true;
local K_DIVIDEBOOST = 3;

local ImageNumber = 1;

local Color = require("Color");
local Ray = require("Ray");
local Vector3 = require("Vector3");
local Camera = {};

local function writePPM(filename, image)
	local file = io.open(filename, "w");
	local height = #image;
	local width = height > 0 and #image[1] or 0;

	file:write(string.format("P3 %d %d 255\n", width, height));

    for i = 1, height do
        for j = 1, width do
        	local pixel = image[i][j];
            file:write(string.format("%d ", pixel.r));
            file:write(string.format("%d ", pixel.g));
            file:write(string.format("%d\n", pixel.b));
        end
    end
end

function Camera:add(objs)
	for _, object in pairs(objs) do
		table.insert(self.objects, object);
	end
end

function Camera:light(lights)
	for _, light in pairs(lights) do
		table.insert(self.lights, light);
	end
end

local function shoot(self, ray, depth)
	depth = depth or 1;

	local hit, pos, normal = ray:cast(self.objects);
	local color = hit.color;
	local distance = (pos - ray.origin).magnitude;
	
	if hit then
		if depth > 4 then return 0,0,0; end
		--Start with ambient lighting
		local r, g, b = color.r * K_AMBIENT, color.g * K_AMBIENT, color.b * K_AMBIENT; 

		--Phong
		if hit.reflectance < 1 then
			for _, light in pairs(self.lights) do
				local ldir = Ray.new(pos, light - pos);
				local lray = Ray.new(light, pos - light);
				local h, p, n = lray:cast(self.objects);
				if h == hit and (p-pos).magnitude < 1e-6 then -- light reached object
					local inc = (pos - light):unit();
					local reflect = inc - normal * (2 * inc:dot(normal));
					local diffuse = math.max(0, K_DIFFUSE * ldir.dir:dot(normal));
					r = r + diffuse * color.r;
					g = g + diffuse * color.g;
					b = b + diffuse * color.b;

					--Calculate specular lighting
					local view = (self.pos - pos):unit();
					local specular = math.max(0, K_SPECULE * reflect:dot(view) ^ K_SHINING);

					r = r + specular * color.r;
					g = g + specular * color.g;
					b = b + specular * color.b;
				end
			end
		end

		if hit.reflectance > 0 then
			--Calculate reflection lighting
			local inc = (pos - ray.origin):unit();
			local reflect = inc - normal * (2 * inc:dot(normal));
			local r2, g2, b2 = shoot(self, Ray.new(pos, reflect), depth+1);

			if r2 then
				local ref = hit.reflectance;
				r = r + ref * r2;
				g = g + ref * g2;
				b = b + ref * b2;
			end
		end

		if DIVIDEBYDIST then
			return K_DIVIDEBOOST*r/distance^0.25, K_DIVIDEBOOST*g/distance^0.25, K_DIVIDEBOOST*b/distance^0.25;
		else
			return r, g, b;
		end
	end

	return 0, 0, 0;
end

function Camera:render(width, height)
	local image = {};
	-- initialise 2d image
	for i = 1, height do
		image[i] = {};
		for j = 1, width do
			local a = (i % 10 < 5) == (j % 10 < 5) and 31 or 0;
			image[i][j] = Color.new(a, a, a);
		end
	end

	local UP_VECTOR = Vector3.new(0, 1, 0);
	local FORE_VECTOR = self.dir;
	local RIGHT_VECTOR = FORE_VECTOR:cross(UP_VECTOR);
	local TOP_VECTOR = RIGHT_VECTOR:cross(FORE_VECTOR);

	-- HFOV = VFOV / HEIGHT * WIDTH
	local V_FOV = self.fov;
	local H_FOV = self.fov / height * width;

	-- camera place is 1 unit away for simplicity
	-- right_vector_extent 
	--		adj = 1
	--		opposite = ?
	--		angle = h_fov
	-- tan(angle) = o/a
	-- o = tan(angle);
	-- Right Vector from -tan(H_FOV) to tan(H_FOV)
	-- Top Vector from -tan(V_FOV) to tan(V_FOV)

	local RIGHT_EXTENT = math.tan(H_FOV/2);
	local TOP_EXTENT = math.tan(V_FOV/2);
	for i = 1, height do
		local top_offset = TOP_VECTOR * (TOP_EXTENT * (i/height - 0.5) * -2);
		for j = 1, width do
			local offset = FORE_VECTOR
				+ RIGHT_VECTOR * (RIGHT_EXTENT * (j/width - 0.5) * 2)
				+ top_offset;
			local ray = Ray.new(self.pos, offset);
			
			local r, g, b = shoot(self, ray);
			if r then 
				image[i][j] = Color.new(r, g, b);
			end
		end
	end

	writePPM("Output"..string.format("%04d", ImageNumber)..".ppm", image);
	print("Wrote image " .. ImageNumber);
	ImageNumber = ImageNumber + 1;
end

local function new(pos, dir)
	return setmetatable({
		pos = pos,
		dir = dir,
		fov = math.rad(70), -- vertical fov, default: 70 degrees
		objects = {},
		lights = {},
	}, {
		__index = function(t, i)
			return Camera[i];
		end
	});
end

return {new = new};