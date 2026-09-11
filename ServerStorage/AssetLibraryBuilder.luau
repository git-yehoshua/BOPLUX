--[[
	AssetLibraryBuilder (BOPLUX) — v2
	Builds Kenney CC0 OBJ models into MeshPart Models under ServerStorage.AssetLibrary.
	Pipeline: localhost OBJ relay -> HttpService fetch -> OBJ parse -> EditableMesh -> CreateMeshPartAsync.
	Scale: 1 Kenney unit = 2 m = 7.14 studs (opts.scale, default 7.14).
	Model pivot = bbox bottom-center (vertex space), so ground placement = PivotTo(y = surface).

	DEGENERATE-PLANE FIX (v2): material groups whose bbox is flat in any axis
	(< MIN_THICKNESS studs, e.g. zero-thickness backplates / soil discs) are built as
	plain Part blocks instead of MeshParts. Zero-thickness EditableMesh groups produce
	garbage collision/render bounds in CreateMeshPartAsync (engine bbox inflation like
	77.9 studs on a 4.7-stud plant) and render as stretched glitch planes.

	PIVOT NOTE (2026-09-09 fix): despite the line-6 intent, CreateMeshPartAsync
	centers the baked mesh on the Part Position, so finished models arrive with
	bbox-CENTER pivots (pivot Y = half height), not bottom-center. Do NOT rely
	on PivotTo(y = surface) for ground placement — MapDresser.dress now
	bottom-aligns via Model:GetBoundingBox() and is immune to this.

	Usage (from execute_luau):
		local B = require(game:GetService("ServerStorage").AssetLibraryBuilder)
		B.build({ names = {"ru_wall-a", ...}, dest = folder })
]]
local HttpService = game:GetService("HttpService")
local AssetService = game:GetService("AssetService")

local RELAY = "http://127.0.0.1:8787/"
local MIN_THICKNESS = 0.05 -- studs; groups flatter than this on any axis become Parts

local MTL_COLORS = {
	-- furniture-kit: exact baseColorFactor from Kenney GLBs (extract_mtl.js)
	wood = Color3.fromRGB(228, 154, 100),
	woodDark = Color3.fromRGB(173, 116, 76),
	woodLight = Color3.fromRGB(228, 154, 100),
	metal = Color3.fromRGB(189, 210, 214),
	metalDark = Color3.fromRGB(78, 99, 99),
	metalLight = Color3.fromRGB(239, 250, 244),
	metalMedium = Color3.fromRGB(94, 119, 119),
	fabric = Color3.fromRGB(248, 255, 255),
	plastic = Color3.fromRGB(240, 240, 240),
	glass = Color3.fromRGB(178, 211, 196),
	leather = Color3.fromRGB(92, 64, 51),
	paint = Color3.fromRGB(240, 240, 240),
	white = Color3.fromRGB(240, 240, 240),
	black = Color3.fromRGB(40, 40, 40),
	carpet = Color3.fromRGB(240, 94, 87),
	carpetWhite = Color3.fromRGB(248, 255, 255),
	carpetBlue = Color3.fromRGB(91, 132, 221),
	carpetDarker = Color3.fromRGB(155, 76, 73),
	lamp = Color3.fromRGB(255, 233, 150),
	fur = Color3.fromRGB(165, 117, 76),
	concrete = Color3.fromRGB(205, 205, 205),
	asphalt = Color3.fromRGB(70, 70, 72),
	brick = Color3.fromRGB(168, 92, 70),
	roof = Color3.fromRGB(120, 84, 66),
	grass = Color3.fromRGB(96, 152, 80),
	leaf = Color3.fromRGB(88, 140, 74),
	leaves = Color3.fromRGB(88, 140, 74),
	trunk = Color3.fromRGB(112, 84, 60),
	plant = Color3.fromRGB(46, 209, 147),
	soil = Color3.fromRGB(90, 64, 45),
	dirt = Color3.fromRGB(124, 98, 74),
	_defaultMat = Color3.fromRGB(255, 255, 255),
}

-- retro-urban-kit: material name -> uploaded atlas texture (CC0, extracted from kit Textures/)
local TEXTURE_IDS = {
	asphalt = "rbxassetid://75254886050494",
	bars = "rbxassetid://71866471100180",
	concrete = "rbxassetid://133775529284486",
	concreteSmooth = "rbxassetid://133775529284486",
	wall_metal = "rbxassetid://110920002770170",
	dirt = "rbxassetid://137342846652184",
	doors = "rbxassetid://71160448746355",
	grass = "rbxassetid://103044193029788",
	metal = "rbxassetid://127974754338051",
	metal_wall = "rbxassetid://110920002770170",
	planks = "rbxassetid://133841176878548",
	rock = "rbxassetid://91026691889956",
	roof = "rbxassetid://130615256391261",
	roof_plates = "rbxassetid://132241426950960",
	signs = "rbxassetid://134065903143909",
	tiles = "rbxassetid://120574559327427",
	treeA = "rbxassetid://135722202399691",
	treeB = "rbxassetid://111732789641458",
	truck = "rbxassetid://103761544452368",
	truck_alien = "rbxassetid://114238781932835",
	wall = "rbxassetid://97368315421620",
	wall_garage = "rbxassetid://94704756122480",
	wall_lines = "rbxassetid://125195473061354",
	windows = "rbxassetid://115697280321883",
}

local LibraryBuilder = {}
LibraryBuilder.MTL_COLORS = MTL_COLORS
LibraryBuilder.TEXTURE_IDS = TEXTURE_IDS
LibraryBuilder.MIN_THICKNESS = MIN_THICKNESS
LibraryBuilder.unknownMtls = {}

local function parseObj(body)
	local verts, uvs, norms, faces = {}, {}, {}, {}
	local currentMtl = "_defaultMat"
	for line in body:gmatch("[^\r\n]+") do
		local head = line:sub(1, 2)
		if head:sub(1, 1) == "v" then
			if head == "v " then
				local x, y, z = line:match("^v%s+([%-%d%.eE]+)%s+([%-%d%.eE]+)%s+([%-%d%.eE]+)")
				if x then verts[#verts + 1] = Vector3.new(tonumber(x), tonumber(y), tonumber(z)) end
			elseif head == "vt" then
				local u, v = line:match("^vt%s+([%-%d%.eE]+)%s+([%-%d%.eE]+)")
				if u then uvs[#uvs + 1] = Vector2.new(tonumber(u), tonumber(v)) end
			elseif head == "vn" then
				local x, y, z = line:match("^vn%s+([%-%d%.eE]+)%s+([%-%d%.eE]+)%s+([%-%d%.eE]+)")
				if x then norms[#norms + 1] = Vector3.new(tonumber(x), tonumber(y), tonumber(z)) end
			end
		elseif head == "f " then
			local tri = {}
			for tok in line:gmatch("%S+") do
				if tok ~= "f" then
					local vi, ti, ni = tok:match("([%-%d]+)/([%-%d]*)/([%-%d]*)")
					tri[#tri + 1] = { v = tonumber(vi), t = tonumber(ti), n = tonumber(ni) }
				end
			end
			for i = 2, #tri - 1 do
				faces[#faces + 1] = { tri[1], tri[i], tri[i + 1], mtl = currentMtl }
			end
		elseif line:sub(1, 6) == "usemtl" then
			currentMtl = line:match("^usemtl%s+(%S+)") or "_defaultMat"
		end
	end
	return verts, uvs, norms, faces
end

local function applyLook(part, mtl)
	local texId = TEXTURE_IDS[mtl]
	if texId and part:IsA("MeshPart") then
		part.TextureID = texId
		part.Color = Color3.fromRGB(255, 255, 255)
	else
		part.Color = MTL_COLORS[mtl] or Color3.fromRGB(205, 205, 205)
	end
	if not MTL_COLORS[mtl] and not TEXTURE_IDS[mtl] then
		LibraryBuilder.unknownMtls[mtl] = true
	end
end

-- Builds one OBJ (by relay name, e.g. "ru_wall-a") into a Model with bottom-center pivot geometry.
-- COORDINATE FIX (v4, 2026-09-10 — supersedes the v3 Z-negation, which was
-- WRONG): Roblox fronts face -Z while OBJ fronts face +Z, so models need a
-- half-turn to face forward. Negating Z alone is a MIRROR, not a rotation: it
-- flips every triangle's winding and bakes the whole library inside-out
-- (proven by signed-volume forensics: bookcase +0.0417 raw -> -0.0417
-- negated; dumpster +0.2209 -> -0.2209). Inside-out meshes glitch under BOTH
-- DoubleSided settings (false shows interiors as flat/wrong-shaded boxes;
-- true alternates dark/lit faces = checkerboard) — this was the true cause
-- behind every "checkered / glitchy / flat" asset report. The correct
-- transform is a 180-degree rotation about Y (negate X AND Z): same
-- front-facing result, winding preserved (signed volumes stay positive).
-- opts: { scale = studsPerUnit, dest = Instance }
function LibraryBuilder.buildOne(base, opts)
	opts = opts or {}
	local scale = opts.scale or 7.14
	local okFetch, body = pcall(function()
		return HttpService:GetAsync(RELAY .. base .. ".obj")
	end)
	if not okFetch then return nil, "fetch failed: " .. tostring(body) end

	local verts, uvs, norms, faces = parseObj(body)
	if #verts == 0 then return nil, "no vertices" end

	-- bounds -> translate: bottom-center at origin, scaled to studs
	local bbMin, bbMax = verts[1], verts[1]
	for _, v in ipairs(verts) do
		bbMin = Vector3.new(math.min(bbMin.X, v.X), math.min(bbMin.Y, v.Y), math.min(bbMin.Z, v.Z))
		bbMax = Vector3.new(math.max(bbMax.X, v.X), math.max(bbMax.Y, v.Y), math.max(bbMax.Z, v.Z))
	end
	local midX, midZ = (bbMin.X + bbMax.X) / 2, (bbMin.Z + bbMax.Z) / 2

	local groups, order = {}, {}
	for _, f in ipairs(faces) do
		if not groups[f.mtl] then groups[f.mtl] = {}; order[#order + 1] = f.mtl end
		table.insert(groups[f.mtl], f)
	end

	-- Y-rotation into Roblox space: (-x, y, -z). Triangle order is unchanged
	-- (rotation preserves winding); bounds are symmetric so midX/midZ stand.
	local function toModelSpace(p)
		return Vector3.new((midX - p.X) * scale, (p.Y - bbMin.Y) * scale, (midZ - p.Z) * scale)
	end

	local model = Instance.new("Model")
	model.Name = base
	local partCount = 0
	for _, mtl in ipairs(order) do
		local g = groups[mtl]
		-- group bbox in scaled model space (for degenerate detection + Part fallback)
		local gMin, gMax
		local vidMap = {}
		for _, f in ipairs(g) do
			for _, corner in ipairs(f) do
				local vi = corner.v
				if vi and vi < 0 then vi = #verts + vi + 1 end
				local p = vi and verts[vi]
				if p and not vidMap[vi] then
					vidMap[vi] = toModelSpace(p)
				end
			end
		end
		for _, v in pairs(vidMap) do
			gMin = gMin and Vector3.new(math.min(gMin.X, v.X), math.min(gMin.Y, v.Y), math.min(gMin.Z, v.Z)) or v
			gMax = gMax and Vector3.new(math.max(gMax.X, v.X), math.max(gMax.Y, v.Y), math.max(gMax.Z, v.Z)) or v
		end
		if not gMin then continue end
		local gSize = gMax - gMin

		if gSize.X < MIN_THICKNESS or gSize.Y < MIN_THICKNESS or gSize.Z < MIN_THICKNESS then
			-- degenerate flat group -> clean Part block (avoids garbage mesh geometry)
			local part = Instance.new("Part")
			part.Name = mtl
			part.Anchored = true
			part.CanCollide = true
			part.Size = Vector3.new(
				math.max(gSize.X, MIN_THICKNESS),
				math.max(gSize.Y, MIN_THICKNESS),
				math.max(gSize.Z, MIN_THICKNESS))
			part.CFrame = CFrame.new((gMin + gMax) / 2)
			applyLook(part, mtl)
			part.Parent = model
			partCount += 1
		else
			local em = AssetService:CreateEditableMesh()
			local vIds, ok1 = {}, true
			for _, f in ipairs(g) do
				local vids = {}
				for ci, corner in ipairs(f) do
					local vi = corner.v
					if vi and vi < 0 then vi = #verts + vi + 1 end
					if not (vi and verts[vi]) then ok1 = false; break end
					if not vIds[vi] then
						local p = verts[vi]
						vIds[vi] = em:AddVertex(toModelSpace(p))
					end
					vids[ci] = vIds[vi]
				end
				if ok1 then
					local fid = em:AddTriangle(vids[1], vids[2], vids[3])
					local uvids, nids = {}, {}
					local anyUV, anyN = false, false
					for ci, corner in ipairs(f) do
						if corner.t and corner.t > 0 and uvs[corner.t] then
							uvids[ci] = em:AddUV(uvs[corner.t]); anyUV = true
						end
						if corner.n and corner.n > 0 and norms[corner.n] then
							local n = norms[corner.n]
							nids[ci] = em:AddNormal(Vector3.new(-n.X, n.Y, -n.Z)); anyN = true
						end
					end
					if anyUV then em:SetFaceUVs(fid, uvids) end
					if anyN then em:SetFaceNormals(fid, nids) end
				end
			end
			if ok1 and #em:GetFaces() > 0 then
				local okMp, mp = pcall(function()
					return AssetService:CreateMeshPartAsync(Content.fromObject(em), { CollisionFidelity = Enum.CollisionFidelity.Box })
				end)
				if okMp then
					mp.Name = mtl
					mp.Anchored = true
					mp.CanCollide = true
					mp.DoubleSided = true -- safety net for winding edge cases
					applyLook(mp, mtl)
					mp.Parent = model
					partCount += 1
				end
			end
			em:Destroy()
		end
	end
	if partCount == 0 then model:Destroy(); return nil, "no faces built" end
	model:SetAttribute("LibBoundsSize", (bbMax - bbMin) * scale)
	model:SetAttribute("LibScale", scale)
	model.Parent = opts.dest
	return model, nil
end

-- build({ names = {...}, scale = 7.14, dest = Instance })
function LibraryBuilder.build(opts)
	opts = opts or {}
	local dest = opts.dest
	assert(dest, "dest folder required")
	local wasHttp = HttpService.HttpEnabled
	if not wasHttp then HttpService.HttpEnabled = true end
	local built, errors = {}, {}
	for _, name in ipairs(opts.names or {}) do
		local ok, err = LibraryBuilder.buildOne(name, { scale = opts.scale, dest = dest })
		if ok then built[#built + 1] = name else errors[#errors + 1] = name .. ": " .. tostring(err) end
	end
	if not wasHttp then HttpService.HttpEnabled = false end
	return built, errors
end

return LibraryBuilder
