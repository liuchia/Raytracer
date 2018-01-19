local Vector3 = require("Vector3");
local Camera = require("Camera");
local Sphere = require("Sphere");
local Color = require("Color");
local Plane = require("Plane");

local camera = Camera.new(Vector3.new(0, 0, 14), Vector3.new(0, 0, -1));
--50514f-f25f5c-ffe066-247ba0-70c1b3
camera:add{
	Sphere.new(Vector3.new(0, 0, 0), 5, Color.new(0xf2, 0x5f, 0x5c), 1);
	Sphere.new(Vector3.new(0, 0, 0), 2, Color.new(0xff, 0xe0, 0x66), 1);
	Sphere.new(Vector3.new(0, 0, 0), 2, Color.new(0x24, 0x7b, 0xa0), 1);
	Sphere.new(Vector3.new(0, 0, 0), 2, Color.new(0x70, 0xc1,0xb3), 1);
	Sphere.new(Vector3.new(0, 0, 0), 2, Color.new(0xff, 0xe0, 0x66), 1);
	Plane.new(Vector3.new(0, 0, -15), Vector3.new(0, 0, 1), Color.new(0x50,0x51,0x4f), 1);
	Plane.new(Vector3.new(0, 0, 15), Vector3.new(0, 0, -1), Color.new(0x50,0x51,0x4f), 1);
	Plane.new(Vector3.new(0, -15, 0), Vector3.new(0, 1, 0), Color.new(0x66, 0x51, 0x4f), 0);
	Plane.new(Vector3.new(0, 15, 0), Vector3.new(0, -1, 0), Color.new(0x66, 0x51, 0x4f), 0);
	Plane.new(Vector3.new(15, 0, 0), Vector3.new(1, 0, 0), Color.new(0x50,0x51,0x4f), 0.25);
	Plane.new(Vector3.new(-15, 0, 0), Vector3.new(-1, 0, 0), Color.new(0x50,0x51,0x4f), 0.25);
};

camera:light{
	Vector3.new(0, 14, 0);
}

local STEPS = 25;
camera.pos = Vector3.new(14, 12, 12);
camera.dir = camera.pos:unit() * -1;
for i = 1, STEPS do
	local angle = 2*math.pi*(i/STEPS)^2;
	for j = 2, 5 do
		local a = angle + 2*math.pi*j/4;
		camera.objects[j].pos = Vector3.new(9*math.cos(a), 0, 9*math.sin(a));
	end
	camera.lights[1] = Vector3.new(14*math.cos(angle), 14, 12*math.sin(2*angle));
	camera:render(250, 200);
end