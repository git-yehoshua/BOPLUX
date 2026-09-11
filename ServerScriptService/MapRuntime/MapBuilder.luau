-- MapBuilder: builds the map template per the promoted map contract
-- (project-truth.md -> Architecture Truth): two Jails (A/B), two Plant Sites (A/B),
-- two enclosed single-exit spawn rooms. Geometry-only template; the Jail/Site
-- models carry the contract attributes (CellId / SiteId) that the gameplay
-- systems read. JAIL_LAYOUTS centers must stay in sync with RunJailSystem.CELL_LAYOUT,
-- SITE_LAYOUTS with RunObjectiveSystem.SITE_LAYOUT, SPAWN_ROOMS with MatchManager.SPAWN_POINTS.
--
-- Tulay_v004 (2026-09-10, owner-directed asset removal): all integrated
-- AssetLibrary props are gone — persistent render glitches the agent could
-- not resolve without vision (winding rebake fixed geometry, but flat-shaded
-- low-poly props still read as checkered/plain boxes on the owner's screen).
-- The map is structural + procedural art only. MapDresser is no longer
-- called; its file stays in the repo as history. The CC0 kit OBJs stay on
-- disk and in the wiki archive if a future textured pass is ever attempted.
--   Visual restyle of the verified v001 layout — gameplay collision is unchanged.
--   The jail becomes a real cell (iron bar skin with a barred gate over the
--   unchanged contract shell, bunk, bench, toilet+sink, floor drain, caged
--   lamp, CELL A/B signage). Canal-town dressing: fiesta banderitas across the
--   bridges and lanes, moored bancas, water-level docks with bollards, bank
--   lamp posts, string lights, terracotta-roof facade silhouettes behind the
--   perimeter (with copings, pilasters and rooftop water tanks), gate-tower
--   roofs + team banners, site plinths with painted capture rings, sandbags,
--   market stalls, reed clusters and algae patches. Parts named "NightLamp"
--   (cell bulbs, lamp posts, string lights) are picked up by the
--   EnvironmentSystem night pass as real light sources.
--   Preserved contract anchors (required by gameplay code, not map design):
--   224x224 footprint (minimap projection), jail centers/axes, site centers,
--   spawn-room centers. 180-degree rotational symmetry is preserved (team
--   fairness under the halftime role swap); fiesta strings use palindrome /
--   reversed color orders so even the festive colors mirror.
local MapBuilder = {}

MapBuilder.MAP_NAME = "Tulay_v004"

local PERIMETER_HALF = 110
local WALL_HEIGHT = 20
local WALL_THICKNESS = 2

-- Canal geometry: the yard splits into a north bank (z < -9, defenders) and a
-- south bank (z > 9, attackers) with water between.
local BANK_HALF = 103 -- bank slab length along Z (9..112)
local CANAL_HALF = 9 -- canal spans z -9..9
local CANAL_DEPTH = 4
local CANAL_FLOOR_Y = -CANAL_DEPTH

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

-- Estero palette: warm canal-town stone, terracotta roofs, adobe facades.
local WARM_BANK = Color3.fromRGB(150, 118, 100)
local COOL_BANK = Color3.fromRGB(108, 118, 138)
local CANAL_STONE = Color3.fromRGB(125, 120, 112)
local BRIDGE_WOOD = Color3.fromRGB(140, 105, 70)
local NEUTRAL = Color3.fromRGB(130, 128, 124)
local CRATE = Color3.fromRGB(155, 115, 72)
local TERRACOTTA = Color3.fromRGB(178, 88, 58)
local CREAM = Color3.fromRGB(228, 213, 186)
local ADOBE = Color3.fromRGB(198, 172, 140)
local IRON = Color3.fromRGB(62, 64, 72)
local GLOW = Color3.fromRGB(255, 224, 160)
local BANNER_RED = Color3.fromRGB(200, 70, 60)
local BANNER_BLUE = Color3.fromRGB(70, 120, 200)
local REED_GREEN = Color3.fromRGB(96, 138, 84)
local ALGAE = Color3.fromRGB(52, 84, 62)
local SANDBAG = Color3.fromRGB(176, 158, 122)

local BANDERITA_COLORS = {
	Color3.fromRGB(205, 80, 70), -- fiesta red
	Color3.fromRGB(235, 220, 190), -- cream
	Color3.fromRGB(80, 125, 205), -- fiesta blue
	Color3.fromRGB(240, 190, 80), -- fiesta yellow
}

-- Every entry is placed as a 180-degree rotational pair: (x, z) and (-x, -z).
-- An axis-aligned box rotated 180 degrees keeps its size, so mirroring only
-- negates the position. Pivot-centered pieces are placed once.
local GATE_TOWERS = {
	{ position = Vector3.new(16, 5, 16), size = Vector3.new(6, 10, 6), banner = BANNER_RED }, -- south (attacker)
	{ position = Vector3.new(16, 5, -16), size = Vector3.new(6, 10, 6), banner = BANNER_BLUE }, -- north (defender)
}

local BRIDGES = {
	{ position = Vector3.new(0, -0.25, 0), size = Vector3.new(12, 1, 20) }, -- mid (self-paired pivot piece)
	{ position = Vector3.new(-55, -0.25, 0), size = Vector3.new(10, 1, 20) },
	{ position = Vector3.new(55, -0.25, 0), size = Vector3.new(10, 1, 20) },
}

-- Rails sit on the deck edges; the pair trick covers both banks because each
-- rail's 180-degree partner lands on the opposite bank at the mirrored span.
local BRIDGE_RAILS = {
	{ position = Vector3.new(-55, 1.25, -9.5), size = Vector3.new(10, 3, 0.5) },
	{ position = Vector3.new(55, 1.25, -9.5), size = Vector3.new(10, 3, 0.5) },
}

-- Bank parapets: one gap per bridge landing (mid x -6..6, side x 50..60 west,
-- x -60..-50 east under rotation). Defined on the north bank; partners land on
-- the south bank at the mirrored x span.
local BANK_PARAPETS = {
	{ position = Vector3.new(-85, 1.25, -CANAL_HALF - 0.25), size = Vector3.new(50, 2.5, 1) },
	{ position = Vector3.new(-28, 1.25, -CANAL_HALF - 0.25), size = Vector3.new(44, 2.5, 1) },
	{ position = Vector3.new(28, 1.25, -CANAL_HALF - 0.25), size = Vector3.new(44, 2.5, 1) },
	{ position = Vector3.new(85, 1.25, -CANAL_HALF - 0.25), size = Vector3.new(50, 2.5, 1) },
}

-- Site colonnade: pillar corners, planter walls between two sides, crates.
local SITE_PILLARS_A = {
	Vector3.new(30, 5.5, -30),
	Vector3.new(50, 5.5, -30),
	Vector3.new(30, 5.5, -50),
	Vector3.new(50, 5.5, -50),
}

local SITE_PLANTERS_A = {
	{ position = Vector3.new(40, 1.25, -30), size = Vector3.new(14, 2.5, 2) },
	{ position = Vector3.new(30, 1.25, -40), size = Vector3.new(2, 2.5, 14) },
}

local SITE_CRATES_A = {
	Vector3.new(45, 1.5, -35),
	Vector3.new(36, 1.5, -44),
	Vector3.new(44, 1.5, -46),
}

-- Screen walls that break the direct spawn-to-site sightlines (one entry per
-- pair; addSymmetricPart mirrors it).
local APPROACH_SCREENS_A = {
	{ position = Vector3.new(46, 5, -22), size = Vector3.new(14, 10, 2) },
}

local YARD_BLOCKS_A = {
	{ position = Vector3.new(65, 2, 45), size = Vector3.new(6, 4, 6) },
}

local YARD_CRATES_A = {
	Vector3.new(18, 1.5, 45),
	Vector3.new(25, 1.5, 52),
	Vector3.new(70, 1.5, 12),
}

local YARD_LOWWALLS_A = {
	{ position = Vector3.new(-18, 1.25, 60), size = Vector3.new(12, 2.5, 2) },
	{ position = Vector3.new(70, 1.25, 20), size = Vector3.new(2, 2.5, 12) },
}

local RING_COVER_A = {
	{ position = Vector3.new(100, 1.25, 30), size = Vector3.new(2, 2.5, 16) },
}

local RING_CRATES_A = {
	Vector3.new(95, 1.5, -60),
	Vector3.new(90, 1.5, -65),
}

local SPAWN_SCREEN_A = {
	position = Vector3.new(54, 5, 68),
	size = Vector3.new(2, 10, 10),
}

-- v002 Estero dressing tables (all decorative, mostly non-collide).
-- Facade silhouettes stand just outside the perimeter (z/x = ±115), paired
-- north<->south and east<->west with identical height sequences.
local FACADE_ROW_X = { -- along the east/west perimeter
	{ offset = -75, width = 45, height = 14, tank = false },
	{ offset = -25, width = 45, height = 20, tank = true },
	{ offset = 25, width = 45, height = 24, tank = false },
	{ offset = 75, width = 45, height = 16, tank = true },
}
local FACADE_ROW_Z = { -- along the north/south perimeter
	{ offset = -75, width = 45, height = 18, tank = false },
	{ offset = -25, width = 45, height = 13, tank = false },
	{ offset = 25, width = 45, height = 22, tank = true },
	{ offset = 75, width = 45, height = 15, tank = false },
}
local FACADE_TINTS = { CREAM, ADOBE, CREAM, ADOBE }

-- Docks jut from the banks over the water; bollards at the outer corners.
local DOCKS_A = {
	{ position = Vector3.new(25, -0.35, 7.2), size = Vector3.new(4, 0.3, 3.6) },
	{ position = Vector3.new(-60, -0.35, 7.2), size = Vector3.new(4, 0.3, 3.6) },
}

local LAMP_POSTS_A = {
	Vector3.new(20, 0, 10.4),
	Vector3.new(70, 0, 10.4),
}

-- Fiesta strings: from/to endpoints. Pivot strings (mid bridge) use a
-- palindromic color sequence so the string mirrors onto itself; paired
-- strings build the partner with reversed color order so colors mirror too.
local FIESTA_STRINGS = {
	{ from = Vector3.new(0, 8.2, -9), to = Vector3.new(0, 8.2, 9), count = 7, palindrome = true }, -- mid bridge (pivot)
	{ from = Vector3.new(-55, 8.2, -9), to = Vector3.new(-55, 8.2, 9), count = 7 },
	{ from = Vector3.new(-20, 8.0, 30), to = Vector3.new(20, 8.0, 30), count = 9 },
	{ from = Vector3.new(80, 8.0, -12), to = Vector3.new(80, 8.0, 12), count = 9 },
}

local BANCA_POSITIONS_A = {
	Vector3.new(33, -1.15, 5.6),
	Vector3.new(-14, -1.15, -5.6),
}

local REED_CLUSTERS_A = {
	Vector3.new(8, -1.4, -8.2),
	Vector3.new(-42, -1.4, 8.2),
	Vector3.new(64, -1.4, 8.2),
}

local BARRELS_A = {
	Vector3.new(28.5, 0.8, 9.6),
	Vector3.new(-66, 0.8, -9.6),
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

-- Decorative placement: anchored, non-collide, arbitrary CFrame (rotated
-- pennants, angled pieces).
local function addDecor(parent, name, cframe, size, color, material)
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide = false
	part.Size = size
	part.CFrame = cframe
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

-- Fiesta string between two points: rope + hanging pennants. `palindrome`
-- mirrors the color sequence around the string center (for pivot strings);
-- `reversed` builds the 180-degree partner with mirrored color order so the
-- pair is color-symmetric under rotation.
local function buildFiestaString(parent, name, from, to, count, reversed, palindrome, bulbs)
	local mid = (from + to) / 2
	local length = (to - from).Magnitude
	local axis = (to - from).Unit
	local rope = addDecor(parent, name .. "_Rope", CFrame.lookAt(mid, to), Vector3.new(0.06, 0.06, length), BRIDGE_WOOD, Enum.Material.WoodPlanks)
	rope.CanCollide = false
	for i = 1, count do
		local t = (i - 0.5) / count
		local pos = from:Lerp(to, t) - Vector3.new(0, 0.42, 0)
		local colorIndex = i
		if reversed then
			colorIndex = count - i + 1
		elseif palindrome then
			colorIndex = math.min(i, count - i + 1)
		end
		local color = BANDERITA_COLORS[((colorIndex - 1) % #BANDERITA_COLORS) + 1]
		local tilt = math.abs(axis.X) > 0.5 and CFrame.Angles(0, 0, math.rad(45)) or CFrame.Angles(math.rad(45), 0, 0)
		addDecor(parent, name .. "_Flag" .. i, CFrame.new(pos) * tilt, Vector3.new(0.55, 0.55, 0.05), color, Enum.Material.Fabric)
		if bulbs and i % 2 == 1 then
			-- String lights: every other pennant trades places with a bulb; a
			-- few become real night light sources (EnvironmentSystem night pass).
			local isLamp = (i % 4 == 1)
			local bulb = addDecor(parent, name .. (isLamp and "_NightLamp" or "_Bulb") .. i, CFrame.new(from:Lerp(to, t) - Vector3.new(0, 0.05, 0)), Vector3.new(0.3, 0.3, 0.3), GLOW, Enum.Material.Neon)
			if not isLamp then
				bulb.Name = name .. "_Bulb" .. i
			end
		end
	end
end

local function buildBanks(map)
	-- Two bank slabs (warm south / cool north) plus the canal cut between them.
	addPart(map, "Bank_South", Vector3.new(0, -0.5, CANAL_HALF + BANK_HALF / 2), Vector3.new(224, 1, BANK_HALF), WARM_BANK, Enum.Material.Concrete)
	addPart(map, "Bank_North", Vector3.new(0, -0.5, -CANAL_HALF - BANK_HALF / 2), Vector3.new(224, 1, BANK_HALF), COOL_BANK, Enum.Material.Concrete)

	local canal = Instance.new("Folder")
	canal.Name = "Canal"
	canal.Parent = map

	addPart(canal, "CanalFloor", Vector3.new(0, CANAL_FLOOR_Y - 0.25, 0), Vector3.new(224, 0.5, CANAL_HALF * 2), CANAL_STONE, Enum.Material.Slate)
	addPart(canal, "CanalWall_North", Vector3.new(0, -CANAL_DEPTH / 2, -CANAL_HALF + 0.5), Vector3.new(224, CANAL_DEPTH, 1), CANAL_STONE, Enum.Material.Slate)
	addPart(canal, "CanalWall_South", Vector3.new(0, -CANAL_DEPTH / 2, CANAL_HALF - 0.5), Vector3.new(224, CANAL_DEPTH, 1), CANAL_STONE, Enum.Material.Slate)

	-- Water fills from the floor (y -4) up to y -1.5; swimmers keep head and
	-- shoulders above the surface and can jump back onto either bank.
	local water = addPart(canal, "Water", Vector3.new(0, CANAL_FLOOR_Y + 1.25, 0), Vector3.new(224, 2.5, CANAL_HALF * 2 - 2), Color3.fromRGB(60, 110, 150), Enum.Material.Glass)
	water.CanCollide = false
	water.Transparency = 0.4
	water.Reflectance = 0.05

	-- Reed clusters at the waterline (point-symmetric blade offsets so the
	-- 180-degree partner cluster mirrors exactly).
	for index, position in ipairs(REED_CLUSTERS_A) do
		local blades = {
			{ offset = Vector3.new(-0.9, 0, 0), height = 2.4 },
			{ offset = Vector3.new(0.9, 0, 0), height = 2.4 },
			{ offset = Vector3.new(-0.45, 0, 0.3), height = 2.6 },
			{ offset = Vector3.new(0.45, 0, -0.3), height = 2.6 },
		}
		for blade, spec in ipairs(blades) do
			addSymmetricPart(canal, "Reed_" .. index .. "_" .. blade, position + spec.offset, Vector3.new(0.14, spec.height, 0.14), REED_GREEN, REED_GREEN, Enum.Material.Grass)
			canal["Reed_" .. index .. "_" .. blade .. "_A"].CanCollide = false
			canal["Reed_" .. index .. "_" .. blade .. "_B"].CanCollide = false
		end
	end
end

-- A moored banca (outrigger canoe): hull, crossbars, floats. Non-collide.
local function buildBanca(parent, name, position)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent
	local base = CFrame.new(position)
	local wood = BRIDGE_WOOD
	addDecor(model, "Hull", base * CFrame.new(0, 0.35, 0), Vector3.new(5.2, 0.9, 1.3), wood, Enum.Material.WoodPlanks)
	addDecor(model, "Bow", base * CFrame.new(2.85, 0.5, 0) * CFrame.Angles(0, 0, math.rad(-20)), Vector3.new(1.2, 0.7, 0.9), wood, Enum.Material.WoodPlanks)
	addDecor(model, "Stern", base * CFrame.new(-2.85, 0.5, 0) * CFrame.Angles(0, 0, math.rad(20)), Vector3.new(1.2, 0.7, 0.9), wood, Enum.Material.WoodPlanks)
	for _, side in ipairs({ -1, 1 }) do
		addDecor(model, "Float" .. side, base * CFrame.new(0, 0.15, side * 2.1), Vector3.new(4.6, 0.35, 0.3), wood, Enum.Material.WoodPlanks)
		addDecor(model, "Arm" .. side .. "F", base * CFrame.new(1.6, 0.5, side * 1.2), Vector3.new(0.12, 0.12, 1.9), wood, Enum.Material.WoodPlanks)
		addDecor(model, "Arm" .. side .. "B", base * CFrame.new(-1.6, 0.5, side * 1.2), Vector3.new(0.12, 0.12, 1.9), wood, Enum.Material.WoodPlanks)
	end
end

local function buildBridges(map)
	local bridges = Instance.new("Folder")
	bridges.Name = "Bridges"
	bridges.Parent = map

	for index, deck in ipairs(BRIDGES) do
		addPart(bridges, "Bridge_" .. index, deck.position, deck.size, BRIDGE_WOOD, Enum.Material.WoodPlanks)
	end
	for index, rail in ipairs(BRIDGE_RAILS) do
		addSymmetricPart(bridges, "BridgeRail_" .. index, rail.position, rail.size, NEUTRAL, NEUTRAL, Enum.Material.WoodPlanks)
	end
	for index, parapet in ipairs(BANK_PARAPETS) do
		addSymmetricPart(bridges, "BankParapet_" .. index, parapet.position, parapet.size, CANAL_STONE, CANAL_STONE, Enum.Material.Slate)
	end
	for index, tower in ipairs(GATE_TOWERS) do
		local tint = index == 1 and BANNER_RED or BANNER_BLUE
		addSymmetricPart(bridges, "GateTower_" .. index, tower.position, tower.size, CANAL_STONE, CANAL_STONE, Enum.Material.Brick)
		-- Tiered terracotta roof + team banner (tint pair: south red / north blue)
		local top = tower.position + Vector3.new(0, tower.size.Y / 2, 0)
		addSymmetricPart(bridges, "TowerRoof1_" .. index, top + Vector3.new(0, 0.5, 0), Vector3.new(7, 1, 7), TERRACOTTA, TERRACOTTA, Enum.Material.Slate)
		addSymmetricPart(bridges, "TowerRoof2_" .. index, top + Vector3.new(0, 1.5, 0), Vector3.new(5, 1, 5), TERRACOTTA, TERRACOTTA, Enum.Material.Slate)
		addSymmetricPart(bridges, "TowerRoof3_" .. index, top + Vector3.new(0, 2.4, 0), Vector3.new(3, 0.8, 3), TERRACOTTA, TERRACOTTA, Enum.Material.Slate)
		addSymmetricPart(bridges, "TowerBanner_" .. index, tower.position + Vector3.new(3.3, 1, 0), Vector3.new(0.15, 3, 1.4), tint, index == 1 and BANNER_BLUE or BANNER_RED, Enum.Material.Fabric)
	end

	-- Fiesta banderitas + string lights (bulbs every other pennant).
	local fiesta = Instance.new("Folder")
	fiesta.Name = "Fiesta"
	fiesta.Parent = bridges
	for index, string in ipairs(FIESTA_STRINGS) do
		local reversed = not string.palindrome
		buildFiestaString(fiesta, "Fiesta_" .. index, string.from, string.to, string.count, reversed, string.palindrome == true, true)
		if not string.palindrome then
			buildFiestaString(
				fiesta,
				"Fiesta_" .. index,
				Vector3.new(-string.from.X, string.from.Y, -string.from.Z),
				Vector3.new(-string.to.X, string.from.Y, -string.to.Z),
				string.count,
				false,
				false,
				true
			)
		end
	end
end

-- Water-level dock with corner bollards, jutting from a bank over the water.
local function buildDock(parent, name, position, size)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent
	local base = CFrame.new(position)
	addDecor(model, "Deck", base, size, BRIDGE_WOOD, Enum.Material.WoodPlanks)
	for _, offset in ipairs({
		Vector3.new(-size.X / 2 + 0.3, 0.5, -size.Z / 2 + 0.3),
		Vector3.new(size.X / 2 - 0.3, 0.5, -size.Z / 2 + 0.3),
		Vector3.new(-size.X / 2 + 0.3, 0.5, size.Z / 2 - 0.3),
		Vector3.new(size.X / 2 - 0.3, 0.5, size.Z / 2 - 0.3),
	}) do
		local bollard = addDecor(model, "Bollard", base * CFrame.new(offset) * CFrame.Angles(0, 0, math.rad(90)), Vector3.new(0.7, 0.34, 0.34), IRON, Enum.Material.Metal)
		bollard.Shape = Enum.PartType.Cylinder
	end
	addDecor(model, "LegF", base * CFrame.new(0, -CANAL_DEPTH / 2 + 0.2, -size.Z / 2 + 0.4), Vector3.new(0.35, CANAL_DEPTH - 0.6, 0.35), BRIDGE_WOOD, Enum.Material.WoodPlanks)
	addDecor(model, "LegB", base * CFrame.new(0, -CANAL_DEPTH / 2 + 0.2, size.Z / 2 - 0.4), Vector3.new(0.35, CANAL_DEPTH - 0.6, 0.35), BRIDGE_WOOD, Enum.Material.WoodPlanks)
end

-- Bank lamp post: pole, canal-facing arm, glowing head (NightLamp).
local function buildLampPost(parent, name, position)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent
	local base = CFrame.new(position)
	local towardCanal = position.Z > 0 and -1 or 1
	addDecor(model, "Pole", base * CFrame.new(0, 2.5, 0), Vector3.new(0.28, 5, 0.28), IRON, Enum.Material.Metal)
	addDecor(model, "Arm", base * CFrame.new(0, 4.9, towardCanal * 0.7), Vector3.new(0.22, 0.22, 1.6), IRON, Enum.Material.Metal)
	addDecor(model, "NightLamp", base * CFrame.new(0, 4.6, towardCanal * 1.4), Vector3.new(0.55, 0.7, 0.55), GLOW, Enum.Material.Neon)
	addDecor(model, "Cap", base * CFrame.new(0, 5.05, towardCanal * 1.4), Vector3.new(0.75, 0.15, 0.75), IRON, Enum.Material.Metal)
end

-- Facade silhouettes behind a perimeter wall. `alongX` builds the north/south
-- rows (buildings offset along X); otherwise the east/west rows. Each row is
-- emitted as 180-degree pairs covering both opposite walls.
local function buildFacadeRow(parent, rowName, axisSign, alongX)
	local row = alongX and FACADE_ROW_X or FACADE_ROW_Z
	for index, spec in ipairs(row) do
		local tint = FACADE_TINTS[((index - 1) % #FACADE_TINTS) + 1]
		local width = spec.width
		local height = spec.height
		local offset = spec.offset
		local center
		local size
		if alongX then
			center = Vector3.new(offset, height / 2, axisSign * 115)
			size = Vector3.new(width, height, 8)
		else
			center = Vector3.new(axisSign * 115, height / 2, offset)
			size = Vector3.new(8, height, width)
		end
		local pairName = rowName .. index
		addSymmetricPart(parent, pairName, center, size, tint, tint, Enum.Material.Brick)
		-- Window bands (dark strips proud of the facade, clear of the wall face)
		for band, bandY in ipairs({ height * 0.42, height * 0.72 }) do
			local bandPos
			local bandSize
			if alongX then
				bandPos = Vector3.new(offset, bandY, axisSign * 111.4)
				bandSize = Vector3.new(width - 6, 1.4, 0.35)
			else
				bandPos = Vector3.new(axisSign * 111.4, bandY, offset)
				bandSize = Vector3.new(0.35, 1.4, width - 6)
			end
			addSymmetricPart(parent, pairName .. "_Win" .. band, bandPos, bandSize, Color3.fromRGB(70, 75, 90), Color3.fromRGB(70, 75, 90), Enum.Material.SmoothPlastic)
		end
		-- Roof slab with overhang
		local roofPos
		local roofSize
		if alongX then
			roofPos = Vector3.new(offset, height + 0.25, axisSign * 114.6)
			roofSize = Vector3.new(width + 2, 0.5, 10.5)
		else
			roofPos = Vector3.new(axisSign * 114.6, height + 0.25, offset)
			roofSize = Vector3.new(10.5, 0.5, width + 2)
		end
		addSymmetricPart(parent, pairName .. "_Roof", roofPos, roofSize, TERRACOTTA, TERRACOTTA, Enum.Material.Slate)
		-- Water tank only where it clears the perimeter wall top
		if spec.tank and height > 20 then
			local tankPos
			if alongX then
				tankPos = Vector3.new(offset + width / 4, height + 1.5, axisSign * 114)
			else
				tankPos = Vector3.new(axisSign * 114, height + 1.5, offset + width / 4)
			end
			addSymmetricPart(parent, pairName .. "_Tank", tankPos, Vector3.new(1.8, 2.2, 1.8), Color3.fromRGB(150, 150, 155), Color3.fromRGB(150, 150, 155), Enum.Material.Metal)
		end
	end
end

local function buildCover(map)
	local cover = Instance.new("Folder")
	cover.Name = "Cover"
	cover.Parent = map

	for index, position in ipairs(SITE_PILLARS_A) do
		addSymmetricPart(cover, "SitePillar_" .. index, position, Vector3.new(2.5, 11, 2.5), NEUTRAL, NEUTRAL, Enum.Material.Concrete)
	end
	for index, wall in ipairs(SITE_PLANTERS_A) do
		addSymmetricPart(cover, "SitePlanter_" .. index, wall.position, wall.size, Color3.fromRGB(120, 135, 100), Color3.fromRGB(120, 135, 100), Enum.Material.Concrete)
	end
	for index, position in ipairs(SITE_CRATES_A) do
		addSymmetricPart(cover, "SiteCrate_" .. index, position, Vector3.new(3, 3, 3), CRATE, CRATE, Enum.Material.WoodPlanks)
	end
	for index, wall in ipairs(APPROACH_SCREENS_A) do
		addSymmetricPart(cover, "ApproachScreen_" .. index, wall.position, wall.size, NEUTRAL, NEUTRAL, Enum.Material.Concrete)
	end
	for index, block in ipairs(YARD_BLOCKS_A) do
		addSymmetricPart(cover, "YardBlock_" .. index, block.position, block.size, WARM_BANK, COOL_BANK, Enum.Material.Concrete)
	end
	for index, position in ipairs(YARD_CRATES_A) do
		addSymmetricPart(cover, "YardCrate_" .. index, position, Vector3.new(3, 3, 3), CRATE, CRATE, Enum.Material.WoodPlanks)
	end
	for index, wall in ipairs(YARD_LOWWALLS_A) do
		addSymmetricPart(cover, "YardLowWall_" .. index, wall.position, wall.size, NEUTRAL, NEUTRAL, Enum.Material.Concrete)
	end
	for index, wall in ipairs(RING_COVER_A) do
		addSymmetricPart(cover, "RingCover_" .. index, wall.position, wall.size, NEUTRAL, NEUTRAL, Enum.Material.Concrete)
	end
	for index, position in ipairs(RING_CRATES_A) do
		addSymmetricPart(cover, "RingCrate_" .. index, position, Vector3.new(3, 3, 3), CRATE, CRATE, Enum.Material.WoodPlanks)
	end
	addSymmetricPart(cover, "SpawnScreen", SPAWN_SCREEN_A.position, SPAWN_SCREEN_A.size, NEUTRAL, NEUTRAL, Enum.Material.Concrete)

	-- Docks + lamp posts + stalls + barrels (pairs)
	local props = Instance.new("Folder")
	props.Name = "Props"
	props.Parent = map
	for index, dock in ipairs(DOCKS_A) do
		buildDock(props, "Dock_" .. index .. "_A", dock.position, dock.size)
		buildDock(props, "Dock_" .. index .. "_B", Vector3.new(-dock.position.X, dock.position.Y, -dock.position.Z), dock.size)
	end
	for index, position in ipairs(LAMP_POSTS_A) do
		buildLampPost(props, "LampPost_" .. index .. "_A", position)
		buildLampPost(props, "LampPost_" .. index .. "_B", Vector3.new(-position.X, position.Y, -position.Z))
	end
	for index, position in ipairs(BANCA_POSITIONS_A) do
		buildBanca(props, "Banca_" .. index .. "_A", position)
		buildBanca(props, "Banca_" .. index .. "_B", Vector3.new(-position.X, position.Y, -position.Z))
	end
	for index, position in ipairs(BARRELS_A) do
		local barrel = addPart(props, "Barrel_" .. index .. "_A", position, Vector3.new(1.2, 1.6, 1.2), CRATE, Enum.Material.WoodPlanks)
		barrel.Shape = Enum.PartType.Cylinder
		barrel.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
		local barrelB = addPart(props, "Barrel_" .. index .. "_B", Vector3.new(-position.X, position.Y, -position.Z), Vector3.new(1.2, 1.6, 1.2), CRATE, Enum.Material.WoodPlanks)
		barrelB.Shape = Enum.PartType.Cylinder
		barrelB.CFrame = CFrame.new(-position.X, position.Y, -position.Z) * CFrame.Angles(0, 0, math.rad(90))
	end

	-- Site plinths: stone base, painted capture ring, corner bollards,
	-- sandbag stacks — built per site; every per-site offset set is
	-- point-symmetric so the 180-degree site pair mirrors exactly.
	for _, layout in ipairs(SITE_LAYOUTS) do
		local center = layout.center
		local siteTag = layout.id
		local groundY = 0
		addPart(cover, "SitePlinth_" .. siteTag, Vector3.new(center.X, groundY + 0.4, center.Z), Vector3.new(8, 0.4, 8), CANAL_STONE, Enum.Material.Slate)
		local ringColor = Color3.fromRGB(90, 170, 220)
		addPart(cover, "SiteRing_Xp_" .. siteTag, Vector3.new(center.X + 3.35, groundY + 0.56, center.Z), Vector3.new(0.18, 0.06, 6.9), ringColor, Enum.Material.Neon).CanCollide = false
		addPart(cover, "SiteRing_Xm_" .. siteTag, Vector3.new(center.X - 3.35, groundY + 0.56, center.Z), Vector3.new(0.18, 0.06, 6.9), ringColor, Enum.Material.Neon).CanCollide = false
		addPart(cover, "SiteRing_Zp_" .. siteTag, Vector3.new(center.X, groundY + 0.56, center.Z + 3.35), Vector3.new(6.9, 0.06, 0.18), ringColor, Enum.Material.Neon).CanCollide = false
		addPart(cover, "SiteRing_Zm_" .. siteTag, Vector3.new(center.X, groundY + 0.56, center.Z - 3.35), Vector3.new(6.9, 0.06, 0.18), ringColor, Enum.Material.Neon).CanCollide = false
		for cornerIndex, corner in ipairs({ Vector3.new(4.4, 0.45, 4.4), Vector3.new(4.4, 0.45, -4.4), Vector3.new(-4.4, 0.45, 4.4), Vector3.new(-4.4, 0.45, -4.4) }) do
			addPart(cover, "SiteBollard_" .. siteTag .. "_" .. cornerIndex, Vector3.new(center.X + corner.X, groundY + corner.Y, center.Z + corner.Z), Vector3.new(0.5, 0.9, 0.5), IRON, Enum.Material.Metal)
		end
		for bagIndex, offset in ipairs({
			Vector3.new(-2.6, 0.3, 2.2),
			Vector3.new(2.6, 0.3, -2.2),
			Vector3.new(-2.6, 0.85, 2.15),
			Vector3.new(2.6, 0.85, -2.15),
		}) do
			addPart(cover, "SiteSandbag_" .. siteTag .. "_" .. bagIndex, Vector3.new(center.X + offset.X, groundY + offset.Y, center.Z + offset.Z), Vector3.new(1.15, 0.5, 0.7), SANDBAG, Enum.Material.Fabric)
		end
	end

	-- Facade silhouettes behind the perimeter (north<->south, east<->west pairs)
	local facades = Instance.new("Folder")
	facades.Name = "Facades"
	facades.Parent = map
	buildFacadeRow(facades, "FacadeNS", -1, true)
	buildFacadeRow(facades, "FacadeEW", 1, false)
end

-- The jail: contract collision shell (invisible) + visible iron-bar skin,
-- furniture and a caged lamp. All contract markers/attributes unchanged.
local function buildJail(jailsFolder, layout)
	local model = Instance.new("Model")
	model.Name = "Cell_" .. layout.id
	model.Parent = jailsFolder

	local id = layout.id
	local center = layout.center
	local axis = layout.axis
	local cross = Vector3.new(0, 0, 1) -- contract side walls span Z
	local color = Color3.fromRGB(255, 170, 120)

	-- Contract collision shell (invisible): keeps teleport/door math and any
	-- physical expectations identical to the verified greybox.
	local shell = addPart(model, "Shell_Front", center + axis * 3, Vector3.new(0.5, 7, 6), color, Enum.Material.Concrete)
	shell.Transparency = 1
	local shellBack = addPart(model, "Shell_Back", center - axis * 3, Vector3.new(0.5, 7, 6), color, Enum.Material.Concrete)
	shellBack.Transparency = 1
	local shellL = addPart(model, "Shell_SideL", center - cross * 3, Vector3.new(6, 7, 0.5), color, Enum.Material.Concrete)
	shellL.Transparency = 1
	local shellR = addPart(model, "Shell_SideR", center + cross * 3, Vector3.new(6, 7, 0.5), color, Enum.Material.Concrete)
	shellR.Transparency = 1

	addPart(model, "Floor", center - Vector3.new(0, 2.75, 0), Vector3.new(6, 0.5, 6), Color3.fromRGB(90, 92, 100), Enum.Material.Concrete)
	addPart(model, "Ceiling", center + Vector3.new(0, 4.25, 0), Vector3.new(6, 0.5, 6), Color3.fromRGB(70, 72, 80), Enum.Material.Concrete)

	-- Visible bar skin: corner posts, top/bottom rails, vertical bars on all
	-- four faces (front face is the barred gate over the contract wall).
	local iron = IRON
	local y0 = center.Y - 3.25
	local y1 = center.Y + 3.25
	local postPositions = {
		center + axis * 3 + cross * 3,
		center + axis * 3 - cross * 3,
		center - axis * 3 + cross * 3,
		center - axis * 3 - cross * 3,
	}
	for index, postPos in ipairs(postPositions) do
		addDecor(model, "Post" .. index, CFrame.new(postPos + Vector3.new(0, (y0 + y1) / 2 - center.Y + center.Y, 0)), Vector3.new(0.45, 7, 0.45), iron, Enum.Material.Metal)
	end
	-- Rails: top + bottom rings (four members each)
	for _, railY in ipairs({ y0 + 0.25, y1 - 0.25 }) do
		addDecor(model, "RailXp", CFrame.new(center + axis * 3 + Vector3.new(0, railY - center.Y, 0)), Vector3.new(0.18, 0.18, 6), iron, Enum.Material.Metal)
		addDecor(model, "RailXm", CFrame.new(center - axis * 3 + Vector3.new(0, railY - center.Y, 0)), Vector3.new(0.18, 0.18, 6), iron, Enum.Material.Metal)
		addDecor(model, "RailZp", CFrame.new(center + cross * 3 + Vector3.new(0, railY - center.Y, 0)), Vector3.new(6, 0.18, 0.18), iron, Enum.Material.Metal)
		addDecor(model, "RailZm", CFrame.new(center - cross * 3 + Vector3.new(0, railY - center.Y, 0)), Vector3.new(6, 0.18, 0.18), iron, Enum.Material.Metal)
	end
	-- Vertical bars: back and side faces; the front face is the barred gate
	-- (slightly heavier bars, middle bar replaced by a seam for a gate read).
	for bar = 1, 7 do
		local t = (bar - 0.5) / 7
		local zOff = -3 + 6 * t
		addDecor(model, "BarBack" .. bar, CFrame.new(center - axis * 3 + cross * zOff), Vector3.new(0.14, 6.4, 0.14), iron, Enum.Material.Metal)
		addDecor(model, "BarSideL" .. bar, CFrame.new(center - axis * (3 - 6 * t) + cross * 3), Vector3.new(0.14, 6.4, 0.14), iron, Enum.Material.Metal)
		addDecor(model, "BarSideR" .. bar, CFrame.new(center - axis * (3 - 6 * t) - cross * 3), Vector3.new(0.14, 6.4, 0.14), iron, Enum.Material.Metal)
		-- Front gate bars (slightly heavier, leave the middle bar off for a
		-- gate seam look)
		if bar ~= 4 then
			addDecor(model, "BarGate" .. bar, CFrame.new(center + axis * 3 + cross * zOff), Vector3.new(0.2, 6.4, 0.2), iron, Enum.Material.Metal)
		end
	end
	addDecor(model, "GateFrameTop", CFrame.new(center + axis * 3), Vector3.new(0.3, 0.3, 6), iron, Enum.Material.Metal)
	addDecor(model, "GateSeam", CFrame.new(center + axis * 3), Vector3.new(0.24, 6.4, 0.12), Color3.fromRGB(48, 50, 56), Enum.Material.Metal)

	-- Furniture (all decor, non-collide; absolute Y from the cell floor at
	-- y 0.5): bunk against the back wall, bench on the rotation-consistent
	-- side (sideSign flips with the layout axis so cells mirror), toilet+sink
	-- centered on the back wall, floor drain mid-cell.
	local sideSign = axis.X > 0 and 1 or -1
	local floorTop = 0.5
	local bunkBase = center - axis * 2.15
	local y = floorTop
	addDecor(model, "BunkFrameL", CFrame.new(bunkBase.X, y + 0.45, bunkBase.Z - 0.55), Vector3.new(0.16, 0.9, 3.6), iron, Enum.Material.Metal)
	addDecor(model, "BunkFrameR", CFrame.new(bunkBase.X, y + 0.45, bunkBase.Z + 0.55), Vector3.new(0.16, 0.9, 3.6), iron, Enum.Material.Metal)
	addDecor(model, "BunkMattressL", CFrame.new(bunkBase.X, y + 0.7, bunkBase.Z), Vector3.new(1.1, 0.22, 3.4), Color3.fromRGB(150, 150, 158), Enum.Material.Fabric)
	addDecor(model, "BunkMattressU", CFrame.new(bunkBase.X, y + 1.95, bunkBase.Z), Vector3.new(1.2, 0.22, 3.4), Color3.fromRGB(150, 150, 158), Enum.Material.Fabric)
	addDecor(model, "BunkPostFL", CFrame.new(bunkBase.X - axis.X * 1.7, y + 1.25, bunkBase.Z - 0.55), Vector3.new(0.14, 2.5, 0.14), iron, Enum.Material.Metal)
	addDecor(model, "BunkPostBL", CFrame.new(bunkBase.X + axis.X * 1.7, y + 1.25, bunkBase.Z - 0.55), Vector3.new(0.14, 2.5, 0.14), iron, Enum.Material.Metal)
	addDecor(model, "BunkPostFR", CFrame.new(bunkBase.X - axis.X * 1.7, y + 1.25, bunkBase.Z + 0.55), Vector3.new(0.14, 2.5, 0.14), iron, Enum.Material.Metal)
	addDecor(model, "BunkPostBR", CFrame.new(bunkBase.X + axis.X * 1.7, y + 1.25, bunkBase.Z + 0.55), Vector3.new(0.14, 2.5, 0.14), iron, Enum.Material.Metal)

	local benchBase = center + cross * (2.5 * sideSign)
	addDecor(model, "Bench", CFrame.new(benchBase.X, y + 0.65, benchBase.Z), Vector3.new(3.6, 0.18, 0.7), BRIDGE_WOOD, Enum.Material.WoodPlanks)
	addDecor(model, "BenchLegL", CFrame.new(benchBase.X - axis.X * 1.5, y + 0.3, benchBase.Z), Vector3.new(0.2, 0.6, 0.6), BRIDGE_WOOD, Enum.Material.WoodPlanks)
	addDecor(model, "BenchLegR", CFrame.new(benchBase.X + axis.X * 1.5, y + 0.3, benchBase.Z), Vector3.new(0.2, 0.6, 0.6), BRIDGE_WOOD, Enum.Material.WoodPlanks)

	local wetBase = center - axis * 2.45
	addDecor(model, "Toilet", CFrame.new(wetBase.X, y + 0.45, wetBase.Z), Vector3.new(0.85, 0.9, 0.95), Color3.fromRGB(225, 228, 230), Enum.Material.SmoothPlastic)
	addDecor(model, "Sink", CFrame.new(wetBase.X + axis.X * 0.8, y + 1.05, wetBase.Z), Vector3.new(0.7, 0.5, 0.7), Color3.fromRGB(225, 228, 230), Enum.Material.SmoothPlastic)

	-- Caged ceiling lamp: glowing bulb picked up by the night pass.
	local lampY = 6.3
	addDecor(model, "NightLamp", CFrame.new(center.X, lampY, center.Z), Vector3.new(0.55, 0.6, 0.55), GLOW, Enum.Material.Neon)
	for _, cageOffset in ipairs({ Vector3.new(0.45, 0, 0), Vector3.new(-0.45, 0, 0), Vector3.new(0, 0, 0.45), Vector3.new(0, 0, -0.45) }) do
		addDecor(model, "LampCage", CFrame.new(center.X + cageOffset.X, lampY, center.Z + cageOffset.Z), Vector3.new(0.1, 0.9, 0.1), iron, Enum.Material.Metal)
	end

	-- Signage above the gate (SurfaceGui, no scripts).
	local sign = addPart(model, "CellSign", center + axis * 3.55 + Vector3.new(0, 4.6, 0), Vector3.new(0.16, 0.75, 2.4), iron, Enum.Material.Metal)
	sign.CanCollide = false
	local gui = Instance.new("SurfaceGui")
	gui.Name = "SignGui"
	gui.Face = axis.X > 0 and Enum.NormalId.Right or Enum.NormalId.Left
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = 50
	gui.Parent = sign
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
	label.TextScaled = true
	label.Text = "CELL " .. id
	label.TextColor3 = Color3.fromRGB(255, 190, 120)
	label.Parent = gui

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

	addPart(model, "Pad", center - Vector3.new(0, 1.75, 0), Vector3.new(6, 0.5, 6), siteColor, Enum.Material.Slate)
	addPart(model, "Beacon", center - Vector3.new(0, 0.75, 0), Vector3.new(0.5, 1.5, 0.5), siteColor, Enum.Material.SmoothPlastic)

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

	-- Spawn-room trim: door awning + interior bench + poster wall strip.
	local towardCenter = -room.doorSide
	addDecor(model, "DoorAwning", CFrame.new(doorWallX + towardCenter * 1.2, 6.2, center.Z), Vector3.new(2.6, 0.2, 9), TERRACOTTA, Enum.Material.Fabric)
	addDecor(model, "AwningStrutA", CFrame.new(doorWallX + towardCenter * 2.2, 3.1, center.Z - 3.8), Vector3.new(0.14, 6.2, 0.14), BRIDGE_WOOD, Enum.Material.WoodPlanks)
	addDecor(model, "AwningStrutB", CFrame.new(doorWallX + towardCenter * 2.2, 3.1, center.Z + 3.8), Vector3.new(0.14, 6.2, 0.14), BRIDGE_WOOD, Enum.Material.WoodPlanks)
	addDecor(model, "InteriorBench", CFrame.new(solidSideX + room.doorSide * 1.1, 0.65, center.Z), Vector3.new(0.8, 0.18, 6), BRIDGE_WOOD, Enum.Material.WoodPlanks)

	-- Interior lamp so the room is never a pitch-black box at night.
	addDecor(model, "NightLamp", CFrame.new(center.X, 9.7, center.Z), Vector3.new(0.55, 0.6, 0.55), GLOW, Enum.Material.Neon)

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

	buildBanks(map)
	buildBridges(map)
	buildCover(map)

	local perimeter = Instance.new("Folder")
	perimeter.Name = "Perimeter"
	perimeter.Parent = map
	local wallColor = Color3.fromRGB(85, 85, 90)
	addPart(perimeter, "Wall_North", Vector3.new(0, WALL_HEIGHT / 2, -PERIMETER_HALF), Vector3.new(PERIMETER_HALF * 2 + WALL_THICKNESS * 2, WALL_HEIGHT, WALL_THICKNESS), wallColor, Enum.Material.Concrete)
	addPart(perimeter, "Wall_South", Vector3.new(0, WALL_HEIGHT / 2, PERIMETER_HALF), Vector3.new(PERIMETER_HALF * 2 + WALL_THICKNESS * 2, WALL_HEIGHT, WALL_THICKNESS), wallColor, Enum.Material.Concrete)
	addPart(perimeter, "Wall_West", Vector3.new(-PERIMETER_HALF, WALL_HEIGHT / 2, 0), Vector3.new(WALL_THICKNESS, WALL_HEIGHT, PERIMETER_HALF * 2 + WALL_THICKNESS * 2), wallColor, Enum.Material.Concrete)
	addPart(perimeter, "Wall_East", Vector3.new(PERIMETER_HALF, WALL_HEIGHT / 2, 0), Vector3.new(WALL_THICKNESS, WALL_HEIGHT, PERIMETER_HALF * 2 + WALL_THICKNESS * 2), wallColor, Enum.Material.Concrete)

	-- Wall copings + pilasters (rhythm on the perimeter face)
	addSymmetricPart(perimeter, "CopingNS", Vector3.new(0, WALL_HEIGHT + 0.15, -PERIMETER_HALF), Vector3.new(PERIMETER_HALF * 2 + WALL_THICKNESS * 2, 0.3, WALL_THICKNESS + 1.2), CANAL_STONE, CANAL_STONE, Enum.Material.Slate)
	addSymmetricPart(perimeter, "CopingEW", Vector3.new(-PERIMETER_HALF, WALL_HEIGHT + 0.15, 0), Vector3.new(WALL_THICKNESS + 1.2, 0.3, PERIMETER_HALF * 2 + WALL_THICKNESS * 2), CANAL_STONE, CANAL_STONE, Enum.Material.Slate)
	for _, offset in ipairs({ -75, -25, 25, 75 }) do
		addSymmetricPart(perimeter, "PilasterNS_" .. offset, Vector3.new(offset, WALL_HEIGHT / 2, -PERIMETER_HALF + 1.4), Vector3.new(1.6, WALL_HEIGHT, 0.8), Color3.fromRGB(78, 78, 84), Color3.fromRGB(78, 78, 84), Enum.Material.Concrete)
		addSymmetricPart(perimeter, "PilasterEW_" .. offset, Vector3.new(-PERIMETER_HALF + 1.4, WALL_HEIGHT / 2, offset), Vector3.new(0.8, WALL_HEIGHT, 1.6), Color3.fromRGB(78, 78, 84), Color3.fromRGB(78, 78, 84), Enum.Material.Concrete)
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
