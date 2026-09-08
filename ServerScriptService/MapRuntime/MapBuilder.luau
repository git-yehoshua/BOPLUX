-- MapBuilder: builds the greybox map template per the promoted map contract
-- (project-truth.md -> Architecture Truth): two Jails (A/B), two Plant Sites (A/B),
-- two enclosed single-exit spawn rooms. Geometry-only template; the Jail/Site
-- models carry the contract attributes (CellId / SiteId) that the gameplay
-- systems read. JAIL_LAYOUTS centers must stay in sync with RunJailSystem.CELL_LAYOUT.
--
-- v002 layout pass (2026-09-08, owner pre-approved):
--   * Central landmark (monolith + corner pillars) breaks the spawn-to-spawn
--     diagonal sightline through mid.
--   * Lane walls become a full cross with 10m mid gates -> readable three-lane
--     flow (two ring lanes + mid) between the two halves.
--   * Each site gains an L-shaped hard cover (back + side wall) and a low planter
--     wall for post-plant cover; approaches get a screen wall from spawn.
--   * Quadrant yards and the outer ring between lanes and perimeter get sparse
--     cover so rotations are not naked cross-map walks.
--   * Warm/cool zone tint marks the attacker/defender halves.
--   * 180-degree rotational symmetry is preserved (team fairness under the
--     halftime role swap) and the footprint, spawn-room and jail coordinates are
--     unchanged (minimap projection + RunJailSystem.CELL_LAYOUT stay valid).
local MapBuilder = {}

MapBuilder.MAP_NAME = "Courtyard_v002"

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

-- Warm = attacker half, cool = defender half (mirrored pair gets the partner color)
local WARM_YARD = Color3.fromRGB(140, 125, 115)
local COOL_YARD = Color3.fromRGB(115, 125, 140)
local NEUTRAL = Color3.fromRGB(130, 130, 135)

-- Every entry is placed as a 180-degree rotational pair: (x, z) and (-x, -z).
-- An axis-aligned box rotated 180 degrees keeps its size, so mirroring only
-- negates the position.
local LANE_CROSS = {
	{ position = Vector3.new(-27.5, 5, -60), size = Vector3.new(45, 10, 2) },
	{ position = Vector3.new(27.5, 5, -60), size = Vector3.new(45, 10, 2) },
	{ position = Vector3.new(60, 5, -27.5), size = Vector3.new(2, 10, 45) },
	{ position = Vector3.new(60, 5, 27.5), size = Vector3.new(2, 10, 45) },
}

local MID_STRUCTURE = {
	{ position = Vector3.new(10, 7, 10), size = Vector3.new(3, 14, 3) },
	{ position = Vector3.new(10, 7, -10), size = Vector3.new(3, 14, 3) },
}

local SITE_COVER_A = {
	{ position = Vector3.new(52, 5, -40), size = Vector3.new(2, 10, 18) },
	{ position = Vector3.new(40, 5, -52), size = Vector3.new(18, 10, 2) },
	{ position = Vector3.new(30, 1.25, -40), size = Vector3.new(2, 2.5, 12) },
}

local SITE_CRATES_A = {
	Vector3.new(46, 1.5, -34),
	Vector3.new(34, 1.5, -46),
	Vector3.new(44, 1.5, -28),
}

local YARD_COVER_A = {
	{ position = Vector3.new(10, 1.25, 16), size = Vector3.new(12, 2.5, 2) },
}

local YARD_CRATES_A = {
	Vector3.new(15, 1.5, 35),
	Vector3.new(40, 1.5, 8),
}

local RING_COVER_A = {
	{ position = Vector3.new(80, 1.25, 30), size = Vector3.new(2, 2.5, 20) },
}

local RING_CRATES_A = {
	Vector3.new(85, 1.5, -85),
	Vector3.new(90, 1.5, -80),
	Vector3.new(80, 1.5, -90),
}

local SPAWN_SCREEN_A = {
	position = Vector3.new(55, 5, 75),
	size = Vector3.new(2, 10, 12),
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

-- Places the piece at (x, z) and its 180-degree rotated partner at (-x, -z).
-- partnerColor lets the attacker/defender halves tint differently while staying
-- geometrically identical under rotation.
local function addSymmetricPart(parent, name, position, size, colorA, colorB, material)
	addPart(parent, name .. "_A", position, size, colorA, material)
	addPart(parent, name .. "_B", Vector3.new(-position.X, position.Y, -position.Z), size, colorB, material)
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
	map:SetAttribute("ContractVersion", 2)

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
	for index, wall in ipairs(LANE_CROSS) do
		addSymmetricPart(lanes, "LaneWall_" .. index, wall.position, wall.size, NEUTRAL, NEUTRAL, Enum.Material.Concrete)
	end
	for index, position in ipairs(SITE_CRATES_A) do
		addSymmetricPart(lanes, "SiteCrate_" .. index, position, Vector3.new(3, 3, 3), Color3.fromRGB(150, 110, 70), Color3.fromRGB(150, 110, 70), Enum.Material.WoodPlanks)
	end
	for index, wall in ipairs(SITE_COVER_A) do
		addSymmetricPart(lanes, "SiteCover_" .. index, wall.position, wall.size, NEUTRAL, NEUTRAL, Enum.Material.Concrete)
	end
	for index, position in ipairs(YARD_CRATES_A) do
		addSymmetricPart(lanes, "YardCrate_" .. index, position, Vector3.new(3, 3, 3), Color3.fromRGB(150, 110, 70), Color3.fromRGB(150, 110, 70), Enum.Material.WoodPlanks)
	end
	for index, wall in ipairs(YARD_COVER_A) do
		addSymmetricPart(lanes, "YardCover_" .. index, wall.position, wall.size, WARM_YARD, COOL_YARD, Enum.Material.Concrete)
	end
	for index, position in ipairs(RING_CRATES_A) do
		addSymmetricPart(lanes, "RingCrate_" .. index, position, Vector3.new(3, 3, 3), Color3.fromRGB(150, 110, 70), Color3.fromRGB(150, 110, 70), Enum.Material.WoodPlanks)
	end
	for index, wall in ipairs(RING_COVER_A) do
		addSymmetricPart(lanes, "RingCover_" .. index, wall.position, wall.size, NEUTRAL, NEUTRAL, Enum.Material.Concrete)
	end
	addSymmetricPart(lanes, "SpawnScreen", SPAWN_SCREEN_A.position, SPAWN_SCREEN_A.size, NEUTRAL, NEUTRAL, Enum.Material.Concrete)

	for index, piece in ipairs(MID_STRUCTURE) do
		addSymmetricPart(lanes, "MidStructure_" .. index, piece.position, piece.size, NEUTRAL, NEUTRAL, Enum.Material.Concrete)
	end
	-- The central monolith sits on the rotation pivot: place it once (a mirrored
	-- pair would be two coincident boxes and z-fight).
	addPart(lanes, "Monolith", Vector3.new(0, 6, 0), Vector3.new(14, 12, 14), NEUTRAL, Enum.Material.Concrete)

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
