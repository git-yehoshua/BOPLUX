-- MapRuntime: map lifecycle per the promoted map contract (project-truth.md ->
-- Architecture Truth). Ensures the greybox template exists in ServerStorage.Maps,
-- clones it into Workspace.MapRuntime.ActiveMap, and hoists the contract folders
-- (Jails / Sites) to Workspace root where the gameplay systems expect them.
-- Single-map greybox milestone: the map activates once per server session;
-- per-match clone/destroy rotation activates when a second map template lands.
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local MapBuilder = require(script.Parent.MapBuilder)

local MAP_NAME = MapBuilder.MAP_NAME
local CONTRACT_FOLDERS = { "Jails", "Sites" }

local function ensureMapsFolder()
	local maps = ServerStorage:FindFirstChild("Maps")
	if not maps then
		maps = Instance.new("Folder")
		maps.Name = "Maps"
		maps.Parent = ServerStorage
	end
	return maps
end

local function ensureTemplate()
	local maps = ensureMapsFolder()
	local template = maps:FindFirstChild(MAP_NAME)
	if not template then
		template = MapBuilder.buildTemplate()
		template.Parent = maps
		print("[MapRuntime] Built map template: " .. MAP_NAME)
	end
	return template
end

local function hoistContractFolders(activeMap)
	for _, folderName in ipairs(CONTRACT_FOLDERS) do
		local existing = Workspace:FindFirstChild(folderName)
		if existing then
			existing:Destroy()
		end
		local folder = activeMap:FindFirstChild(folderName)
		if folder then
			folder.Parent = Workspace
		else
			warn("[MapRuntime] Map is missing contract folder: " .. folderName)
		end
	end
end

local function activate()
	local template = ensureTemplate()

	local runtime = Workspace:FindFirstChild("MapRuntime")
	if not runtime then
		runtime = Instance.new("Folder")
		runtime.Name = "MapRuntime"
		runtime.Parent = Workspace
	end

	local stale = runtime:FindFirstChild("ActiveMap")
	if stale then
		stale:Destroy()
	end

	local activeMap = template:Clone()
	activeMap.Name = "ActiveMap"
	activeMap.Parent = runtime

	hoistContractFolders(activeMap)

	script:SetAttribute("ActiveMap", MAP_NAME)
	print("[MapRuntime] Active map: " .. MAP_NAME)
end

activate()
