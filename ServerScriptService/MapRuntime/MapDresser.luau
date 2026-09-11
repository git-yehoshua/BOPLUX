-- MapDresser: Tulay_v003 visual dressing pass. Layers AssetLibrary props onto
-- the v002 structural art WITHOUT touching contract geometry (Jails/Sites/
-- SpawnRooms/footprint/coordinates) or collision: every dressed prop is
-- CanCollide=false, so gameplay remains identical to the verified layout.
-- All placements are 180-degree rotational pairs (position negated on X/Z,
-- same yaw — conjugation of Ry(theta) by Ry(180) is Ry(theta)).
--
-- Inherited hardening (do not regress):
-- * Pivot convention: library models arrive with bbox-CENTER pivots, NOT
--   bottom-center. place() is pivot-agnostic: it bottom-aligns via
--   GetBoundingBox, so ground placements use y = surface height.
-- * Flat-pass: baked library meshes carry corrupt UVs (out-of-range atlas
--   coords break texture sampling). Dress FLAT: strip MeshPart textures and
--   use the exact Kenney palette (TINTS). Fully reversible: delete the strip
--   line to re-enable textures after a library rebake.
-- * Winding: baked meshes carry mirrored winding; DoubleSided=false keeps
--   outward faces only (verified fix).
-- * Overlap-unify: sibling MeshParts with identical bounds z-fight; unify
--   color per identical-bounds group and shrink twins to 97%.
local ServerStorage = game:GetService("ServerStorage")

local MapDresser = {}

local CAN_COLLIDE = false

local TINTS = {
	-- large faces: calm stone tones
	wall_lines = Color3.fromRGB(233, 228, 220),
	wall = Color3.fromRGB(230, 224, 216),
	concrete = Color3.fromRGB(198, 200, 207),
	concreteSmooth = Color3.fromRGB(198, 200, 207),
	wall_metal = Color3.fromRGB(210, 215, 222),
	metal_wall = Color3.fromRGB(210, 215, 222),
	-- detail materials: exact Kenney flat colors (builder MTL palette), so
	-- stripped parts keep their authored look instead of white base
	metal = Color3.fromRGB(189, 210, 214),
	dirt = Color3.fromRGB(124, 98, 74),
	grass = Color3.fromRGB(96, 152, 80),
	planks = Color3.fromRGB(228, 154, 100),
	rock = Color3.fromRGB(170, 170, 175),
	roof = Color3.fromRGB(120, 84, 66),
	roof_plates = Color3.fromRGB(120, 84, 66),
	treeA = Color3.fromRGB(88, 140, 74),
	treeB = Color3.fromRGB(96, 152, 80),
	tiles = Color3.fromRGB(205, 205, 205),
	doors = Color3.fromRGB(150, 110, 80),
	windows = Color3.fromRGB(178, 211, 196),
	signs = Color3.fromRGB(220, 220, 220),
	bars = Color3.fromRGB(78, 99, 99),
	asphalt = Color3.fromRGB(70, 70, 72),
	truck = Color3.fromRGB(120, 130, 135),
	truck_alien = Color3.fromRGB(46, 209, 147),
	wall_garage = Color3.fromRGB(230, 224, 216),
}

-- Siding: everything renders single-sided. Winding is correct at the source
-- (v4 Y-rotation rebake), so outward faces are the right faces. DoubleSided
-- was tried for foliage (crossed leaf planes) but back faces shade wrong and
-- checker — single-sided crossed planes render front-only with correct
-- shading from every angle (slightly sparse from directly behind, standard
-- for this art style). (Fix #9 note corrected 2026-09-10: the old
-- checkerboard was inside-out winding from the v3 Z-negation, NOT
-- DoubleSided. Winding is now correct at the source.)

local function cloneAsset(lib, name)
	for _, cat in ipairs(lib:GetChildren()) do
		if cat:IsA("Folder") then
			local m = cat:FindFirstChild(name)
			if m then
				return m:Clone()
			end
		end
	end
	warn("[MapDresser] missing library asset: " .. tostring(name))
	return nil
end

function MapDresser.dress(map)
	local lib = ServerStorage:FindFirstChild("AssetLibrary")
	if not lib then
		warn("[MapDresser] ServerStorage.AssetLibrary missing; dressing skipped")
		return 0
	end

	local old = map:FindFirstChild("Dressing")
	if old then
		old:Destroy()
	end
	local folder = Instance.new("Folder")
	folder.Name = "Dressing"
	folder.Parent = map

	local placed = 0

	local function place(name, x, y, z, yaw)
		local model = cloneAsset(lib, name)
		if not model then
			return 0
		end
		model:PivotTo(CFrame.new(x, y, z) * CFrame.Angles(0, math.rad(yaw), 0))
		model.Parent = folder
		-- Bottom-align: lift so bbox bottom sits at y (fixes half-buried props).
		local ok, bbCF, bbSize = pcall(function()
			return model:GetBoundingBox()
		end)
		if ok and bbCF and bbSize then
			local bottom = bbCF.Position.Y - bbSize.Y / 2
			local delta = y - bottom
			if math.abs(delta) > 0.001 then
				model:PivotTo(model:GetPivot() + Vector3.new(0, delta, 0))
			end
		else
			warn("[MapDresser] bbox failed for " .. tostring(name))
		end
		for _, d in ipairs(model:GetDescendants()) do
			if d:IsA("BasePart") then
				d.CanCollide = CAN_COLLIDE
				if d:IsA("MeshPart") then
					-- (Fix #9 note corrected 2026-09-10: the old checkerboard
					-- was inside-out winding from the v3 Z-negation, NOT
					-- DoubleSided. Winding is now correct at the source.)
					d.DoubleSided = false
					if d.TextureID ~= "" then
						d.TextureID = ""
					end
					local tint = TINTS[d.Name]
					if tint then
						d.Color = tint
					end
				end
			end
		end
		local buckets = {}
		for _, d in ipairs(model:GetDescendants()) do
			if d:IsA("BasePart") then
				local s, p = d.Size, d.Position
				local key = string.format(
					"%.2f,%.2f,%.2f|%.2f,%.2f,%.2f",
					s.X, s.Y, s.Z, p.X, p.Y, p.Z
				)
				local first = buckets[key]
				if first then
					d.Color = first.Color
					d.Size = s * 0.97
				else
					buckets[key] = d
				end
			end
		end
		return 1
	end

	-- rotational pair: the 180-degree image of pivot (x, y, z) with yaw is
	-- pivot (-x, y, -z) with yaw + 180 (conjugation by Ry(180)). Same-yaw
	-- partners are only correct for yaw = 0; yawed models (cladding facing,
	-- dumpster lids, yawed boxes) need the +180 or their off-center parts
	-- land mirrored-wrong (facing into walls, offset lids).
	local function P(name, x, y, z, yaw)
		placed += place(name, x, y, z, yaw)
		placed += place(name, -x, y, -z, yaw + 180)
	end

	local WALL_WIN = "ru_wall-a-window"
	local WALL_LOW = "ru_wall-a-low"
	local AWNING = "ru_detail-awning-small"
	local DUMPSTER = "ru_detail-dumpster-open"
	local PALLET = "ru_pallet"
	local BRICKS = "ru_detail-bricks-type-a"
	local TREE = "ru_tree-large"
	local TREE_PARK = "ru_tree-park-pine-large"
	local SHRUB = "ru_tree-shrub"
	local BENCH = "fk_bench"
	local BOOKCASE = "fk_bookcaseClosed"
	local RUG = "fk_rugDoormat"
	local PLANT = "fk_pottedPlant"
	local BOX = "fk_cardboardBoxClosed"
	local BOX_OPEN = "fk_cardboardBoxOpen"
	local TRASHCAN = "fk_trashcan"
	local LAMP_FLOOR = "fk_lampSquareFloor"
	local LAMP_WALL = "fk_lampWall"

	-- Site dressing (site centers are identical to the old map, so these
	-- battle-tested coordinates carry over; partners land on the other site).
	P(DUMPSTER, 54.57, 0, -40, 90)
	P(BOX, 46, 3.02, -34, 15)
	P(BOX_OPEN, 48.5, 0, -32.5, 30)
	P(BOX, 34, 3.02, -46, -15)
	P(BOX_OPEN, 44, 3.02, -28, 10)
	P(PLANT, 37.3, 0, -37.3, 0)
	P(PLANT, 42.7, 0, -42.7, 0)
	P(TREE, 30, 0, -55, 0)

	-- Approach-screen cladding: real window modules on the slab faces.
	-- Modules are 7.14 wide; two columns cover the 14-stud screen.
	P(WALL_WIN, 42.43, 0, -20.8, 0)
	P(WALL_WIN, 49.57, 0, -20.8, 0)

	-- Yard dressing (canal-safe: |z| > 12, clear of cells/screens/jails)
	P(PALLET, 15, 0, 35, 0)
	P(BOX, 15, 1.12, 35, 20)
	P(BOX_OPEN, 18.5, 0, 32, 0)
	P(PALLET, 38, 0, 14, 0)
	P(BOX, 38, 1.12, 14, 5)
	P(TRASHCAN, 42.5, 0, 16, 0)
	P(TREE, 35, 0, 30, 0)
	P(SHRUB, 12, 0, 50, 0)
	P(BENCH, 55, 0, 30, 90)

	-- Pallet cargo on the dock decks (bottom-snapped to the deck top)
	P(PALLET, 25, -0.2, 7.2, 0)
	P(PALLET, -60, -0.2, 7.2, 90)

	-- Ring dressing (outer corners, clear of ring cover/crates)
	P(DUMPSTER, 85, 0, -85, 45)
	P(PALLET, 90, 0, -80, 0)
	P(BOX, 90, 1.12, -80, 15)
	P(BOX_OPEN, 80, 0, -90, 0)
	P(WALL_LOW, 80, 0, 24, 90)
	P(WALL_LOW, 80, 0, 30.5, 90)
	P(WALL_LOW, 80, 0, 37, 90)
	P(TREE, 95, 0, 60, 0)
	P(TREE_PARK, 60, 0, 95, 0)
	P(BRICKS, 70, 0, -95, 30)

	-- Jails: small props only (the cell is 6 wide; procedural bars/furniture
	-- stay). Trashcan + wall lamp per cell.
	P(TRASHCAN, 25.8, 0, 22.2, 0)
	P(LAMP_WALL, 21.4, 4.2, 20, 90)

	-- Spawn rooms: interiors identical to the verified old dressing (room
	-- centers and doors are unchanged).
	P(BOOKCASE, 80.6, 0, 75, 90)
	P(BENCH, 72, 0, 80.75, 0)
	P(BENCH, 78, 0, 80.75, 0)
	P(RUG, 69.8, 0.05, 75, 90)
	P(LAMP_FLOOR, 70.5, 0, 69.5, 0)
	P(PLANT, 81, 0, 68.5, 0)
	P(AWNING, 65.8, 8.5, 75, 90)
	P(PLANT, 66.3, 0, 71.8, 0)
	P(PLANT, 66.3, 0, 78.2, 0)

	map:SetAttribute("DressedProps", placed)
	return placed
end

return MapDresser
