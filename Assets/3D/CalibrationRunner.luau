-- CalibrationRunner.luau
-- Run via Studio MCP execute_luau (Edit datamodel) or paste into the Studio command bar.
-- Measures every MeshPart under Workspace.CalibrationImport and prints stud dimensions
-- for comparison against the OBJ ground-truth table in the Phase A report.

local root = workspace:FindFirstChild("CalibrationImport")
if not root then
	-- Fall back: measure any loose MeshParts placed by a single-file import
	root = workspace
	print("[Calib] No Workspace.CalibrationImport folder found; scanning all Workspace MeshParts")
end

local results = {}
for _, inst in ipairs(root:GetDescendants()) do
	if inst:IsA("MeshPart") then
		table.insert(results, {
			name = inst.Name,
			sx = inst.Size.X,
			sy = inst.Size.Y,
			sz = inst.Size.Z,
			col = tostring(inst.CollisionFidelity),
			tris = inst.RenderMeshId ~= "" and "has-mesh" or "EMPTY-MESH",
		})
	end
end

print(("[Calib] Found %d MeshParts"):format(#results))
for _, r in ipairs(results) do
	print(("[Calib] %s | %.3f x %.3f x %.3f studs | col=%s | %s"):format(
		r.name, r.sx, r.sy, r.sz, r.col, r.tris))
end

-- Emit a single summary line the agent can parse from console output
local parts = {}
for _, r in ipairs(results) do
	table.insert(parts, ("%s=%.3f,%.3f,%.3f"):format(r.name, r.sx, r.sy, r.sz))
end
print("[CalibSummary] " .. table.concat(parts, "; "))
