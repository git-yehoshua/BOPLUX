-- MapBuilder: builds the greybox map template per the promoted map contract
-- (project-truth.md -> Architecture Truth): two Jails (A/B), two Plant Sites (A/B),
-- two enclosed single-exit spawn rooms. Geometry-only template; the Jail/Site
-- models carry the contract attributes (CellId / SiteId) that the gameplay
-- systems read. JAIL_LAYOUTS centers must stay in sync with RunJailSystem.CELL_LAYOUT.
local MapBuilder = {}

MapBuilder.MAP_NAME = "Courtyard_v001"

local GROUND = {
	position = Vector3.new(0, -0.5, 0),
	size = Vector3.new(224, 1, 224),
}

local PERIMETER_HALF = 110
local WALL_HEIGHT = 20
local WALL_THICKNESS = 2

local JAIL_LAYOUTS = {
	{ id = "A", center = Vector3.new(24, 3, 20), axis = Vector3.new(1, 0, 0) },
	{ id = "B", center = Vector3.new(-24, 3, -20), axis = Vector3.new(-1, 0, 0) },
}

local SITE_LAYOUTS = {
	{ id = "A", center = Vector3.new(40, 2, -40) },
	{ id = "B", center = Vector3.new(-40, 2, 40) },
}

local SPAWN_ROOMS = {
	{ name = "Room_Attackers", center = Vector3.new(75, 0, 75), doorSide = -1 },
	{ name = "Room_Defenders", center = Vector3.new(-75, 0, -75), doorSide = 1 },
}

local LANE_WALLS = {
	{ position = Vector3.new(20, 5, -60), size = Vector3.new(60, 10, 2) },
	{ position = Vector3.new(-20, 5, 60), size = Vector3.new(60, 10, 2) },
	{ position = Vector3.new(60, 5, 20), size = Vector3.new(2, 10, 60) },
	{ position = Vector3.new(-60, 5, -20), size = Vector3.new(2, 10, 60) },
}

local CRATES = {
	Vector3.new(46, 1.5, -34),
	Vector3.new(34, 1.5, -46),
	Vector3.new(-46, 1.5, 34),
	Vector3.new(-34, 1.5, 46),
}

local function addPart(parent, name, position, size, color, material)
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide = true
	part.Size = size
	part.CFrame = CFrame.new(position)
	part.Color = color
	part.Material = material
	part.Parent = parent
	return part
end

local function addMarker(parent, name, position, size)
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 1
	part.Size = size
	part.CFrame = CFrame.new(position)
	part.Parent = parent
	return part
end

local function buildJail(jailsFolder, layout)
	local model = Instance.new("Model")
	model.Name = "Cell_" .. layout.id
	model.Parent = jailsFolder

	local id = layout.id
	local center = layout.center
	local axis = layout.axis
	local color = Color3.fromRGB(255, 170, 120)

	addPart(model, "Floor", center - Vector3.new(0, 2.75, 0), Vector3.new(6, 0.5, 6), color, Enum.Material.Concrete)
	addPart(model, "Ceiling", center + Vector3.new(0, 4.25, 0), Vector3.new(6, 0.5, 6), color, Enum.Material.Concrete)
	addPart(model, "Back", center - axis * 3, Vector3.new(0.5, 7, 6), color, Enum.Material.Concrete)
	addPart(model, "Front", center + axis * 3, Vector3.new(0.5, 7, 6), color, Enum.Material.Concrete)
	addPart(model, "SideL", center - Vector3.new(0, 0, 3), Vector3.new(6, 7, 0.5), color, Enum.Material.Concrete)
	addPart(model, "SideR", center + Vector3.new(0, 0, 3), Vector3.new(6, 7, 0.5), color, Enum.Material.Concrete)

	local interior = addMarker(model, "Interior", center, Vector3.new(4, 5, 4))
	interior:SetAttribute("CellId", id)
	interior:SetAttribute("JailOccupantCount", 0)
	interior:SetAttribute("ChannelKind", nil)
	interior:SetAttribute("BreakoutProgress", 0)
	interior:SetAttribute("RescueProgress", 0)
	interior:SetAttribute("CampingMeterFill", 0)

	local exterior = addMarker(model, "Exterior", center + axis * 4.5, Vector3.new(3, 3, 3))

	return model, interior, exterior
end

local function buildSite(sitesFolder, layout)
	local model = Instance.new("Model")
	model.Name = "Site_" .. layout.id
	model.Parent = sitesFolder

	local id = layout.id
	local center = layout.center
	local siteColor = Color3.fromRGB(90, 170, 220)

	local pad = addPart(model, "Pad", center - Vector3.new(0, 1.75, 0), Vector3.new(6, 0.5, 6), siteColor, Enum.Material.Slate)

	local post = addPart(model, "Beacon", center - Vector3.new(0, 0.75, 0), Vector3.new(0.5, 1.5, 0.5), siteColor, Enum.Material.SmoothPlastic)

	local interior = addMarker(model, "Interior", center, Vector3.new(4, 4, 4))
	interior:SetAttribute("SiteId", id)
	interior:SetAttribute("Planted", false)
	interior:SetAttribute("ChannelKind", nil)
	interior:SetAttribute("PlantProgress", 0)
	interior:SetAttribute("DefuseProgress", 0)
	interior:SetAttribute("DetonationRemaining", 0)

	return model, interior
end

local function buildSpawnRoom(parent, room)
	local model = Instance.new("Model")
	model.Name = room.name
	model.Parent = parent

	local center = room.center
	local half = 8
	local wallHeight = 10
	local color = Color3.fromRGB(160, 160, 165)

	local doorWallX = center.X + room.doorSide * half
	local solidSideX = center.X - room.doorSide * half

	addPart(model, "Wall_Door_A", Vector3.new(doorWallX, wallHeight / 2, center.Z - half + 2.5), Vector3.new(1, wallHeight, 5), color, Enum.Material.Concrete)
	addPart(model, "Wall_Door_B", Vector3.new(doorWallX, wallHeight / 2, center.Z + half - 2.5), Vector3.new(1, wallHeight, 5), color, Enum.Material.Concrete)
	addPart(model, "Wall_Solid_X", Vector3.new(solidSideX, wallHeight / 2, center.Z), Vector3.new(1, wallHeight, half * 2 + 1), color, Enum.Material.Concrete)
	addPart(model, "Wall_Solid_Z_Pos", Vector3.new(center.X, wallHeight / 2, center.Z + half), Vector3.new(half * 2 + 1, wallHeight, 1), color, Enum.Material.Concrete)
	addPart(model, "Wall_Solid_Z_Neg", Vector3.new(center.X, wallHeight / 2, center.Z - half), Vector3.new(half * 2 + 1, wallHeight, 1), color, Enum.Material.Concrete)
	addPart(model, "Roof", Vector3.new(center.X, wallHeight + 0.5, center.Z), Vector3.new(half * 2 + 1, 1, half * 2 + 1), color, Enum.Material.Concrete)

	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "Spawn"
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Duration = 0
	spawn.Size = Vector3.new(12, 1, 12)
	spawn.CFrame = CFrame.new(center.X, 0.5, center.Z)
	spawn.Color = Color3.fromRGB(120, 200, 120)
	spawn.Material = Enum.Material.SmoothPlastic
	spawn.Parent = model

	return model
end

function MapBuilder.buildTemplate()
	local map = Instance.new("Model")
	map.Name = MapBuilder.MAP_NAME
	map:SetAttribute("MapName", MapBuilder.MAP_NAME)
	map:SetAttribute("ContractVersion", 1)

	addPart(map, "Ground", GROUND.position, GROUND.size, Color3.fromRGB(115, 115, 120), Enum.Material.Concrete)

	local perimeter = Instance.new("Folder")
	perimeter.Name = "Perimeter"
	perimeter.Parent = map
	local wallColor = Color3.fromRGB(90, 90, 95)
	addPart(perimeter, "Wall_North", Vector3.new(0, WALL_HEIGHT / 2, -PERIMETER_HALF), Vector3.new(PERIMETER_HALF * 2 + WALL_THICKNESS * 2, WALL_HEIGHT, WALL_THICKNESS), wallColor, Enum.Material.Concrete)
	addPart(perimeter, "Wall_South", Vector3.new(0, WALL_HEIGHT / 2, PERIMETER_HALF), Vector3.new(PERIMETER_HALF * 2 + WALL_THICKNESS * 2, WALL_HEIGHT, WALL_THICKNESS), wallColor, Enum.Material.Concrete)
	addPart(perimeter, "Wall_West", Vector3.new(-PERIMETER_HALF, WALL_HEIGHT / 2, 0), Vector3.new(WALL_THICKNESS, WALL_HEIGHT, PERIMETER_HALF * 2 + WALL_THICKNESS * 2), wallColor, Enum.Material.Concrete)
	addPart(perimeter, "Wall_East", Vector3.new(PERIMETER_HALF, WALL_HEIGHT / 2, 0), Vector3.new(WALL_THICKNESS, WALL_HEIGHT, PERIMETER_HALF * 2 + WALL_THICKNESS * 2), wallColor, Enum.Material.Concrete)

	local lanes = Instance.new("Folder")
	lanes.Name = "Lanes"
	lanes.Parent = map
	for index, wall in ipairs(LANE_WALLS) do
		addPart(lanes, "LaneWall_" .. index, wall.position, wall.size, Color3.fromRGB(130, 130, 135), Enum.Material.Concrete)
	end
	for index, position in ipairs(CRATES) do
		addPart(lanes, "Crate_" .. index, position, Vector3.new(3, 3, 3), Color3.fromRGB(150, 110, 70), Enum.Material.WoodPlanks)
	end

	local spawnRooms = Instance.new("Folder")
	spawnRooms.Name = "SpawnRooms"
	spawnRooms.Parent = map
	for _, room in ipairs(SPAWN_ROOMS) do
		buildSpawnRoom(spawnRooms, room)
	end

	local jails = Instance.new("Folder")
	jails.Name = "Jails"
	jails.Parent = map
	for _, layout in ipairs(JAIL_LAYOUTS) do
		buildJail(jails, layout)
	end

	local sites = Instance.new("Folder")
	sites.Name = "Sites"
	sites.Parent = map
	for _, layout in ipairs(SITE_LAYOUTS) do
		buildSite(sites, layout)
	end

	return map
end

return MapBuilder
