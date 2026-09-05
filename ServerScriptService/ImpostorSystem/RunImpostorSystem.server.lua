local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local ImpostorState = require(script.Parent.ImpostorState)
local MatchState = require(ServerScriptService.MatchManager.MatchState)

local store = ImpostorState.new()
local currentImpostorPlayer
local currentRound

local impostorWarning
local impostorRole
local impostorReveal

local function teamFor(player)
	local state = MatchState.liveState()
	if not state then
		return nil
	end
	return MatchState.teamFor(state, player)
end

local function snapshotRows()
	local sorted = {}
	for _, player in ipairs(Players:GetPlayers()) do
		table.insert(sorted, player)
	end
	table.sort(sorted, function(a, b)
		return a.UserId < b.UserId
	end)
	local rows = {}
	for _, player in ipairs(sorted) do
		local team = teamFor(player)
		if team then
			table.insert(rows, {
				userId = player.UserId,
				displayName = player.DisplayName,
				team = team,
			})
		end
	end
	return rows
end

local function targetIds(kind)
	local folder
	local attribute
	if kind == "breakout" then
		folder = Workspace:FindFirstChild("Jails")
		attribute = "CellId"
	else
		folder = Workspace:FindFirstChild("Sites")
		attribute = "SiteId"
	end
	local ids = {}
	if not folder then
		return ids
	end
	for _, model in ipairs(folder:GetChildren()) do
		local interior = model:FindFirstChild("Interior")
		local id = interior and interior:GetAttribute(attribute) or model.Name
		if id then
			table.insert(ids, tostring(id))
		end
	end
	table.sort(ids)
	return ids
end

local function generateObjective()
	local breakoutIds = targetIds("breakout")
	local plantIds = targetIds("plant")
	local kind
	local ids
	if #breakoutIds > 0 and #plantIds > 0 then
		if math.random(2) == 1 then
			kind = "breakout"
			ids = breakoutIds
		else
			kind = "plant"
			ids = plantIds
		end
	elseif #breakoutIds > 0 then
		kind = "breakout"
		ids = breakoutIds
	elseif #plantIds > 0 then
		kind = "plant"
		ids = plantIds
	else
		return ImpostorState.buildObjective("breakout", nil)
	end
	return ImpostorState.buildObjective(kind, ids[math.random(#ids)])
end

local function applySelectedImpostor()
	local current = store.current
	if not current then
		currentImpostorPlayer = nil
		script:SetAttribute("CurrentImpostorUserId", nil)
		script:SetAttribute("CurrentImpostorTeam", nil)
		script:SetAttribute("CurrentImpostorObjective", nil)
		return
	end
	for _, player in ipairs(Players:GetPlayers()) do
		if player.UserId == current.userId then
			currentImpostorPlayer = player
			break
		end
	end
	script:SetAttribute("CurrentImpostorUserId", current.userId)
	script:SetAttribute("CurrentImpostorTeam", current.team)
	script:SetAttribute("CurrentImpostorObjective", current.objective and current.objective.text or "")
end

local function handlePreRound(round)
	currentRound = round
	if ImpostorState.select(store, snapshotRows(), nil, math.random) then
		ImpostorState.attachObjective(store, generateObjective())
	end
	applySelectedImpostor()
	impostorWarning:FireAllClients({
		text = ImpostorState.WARNING_MESSAGE,
		round = round,
	})
	if currentImpostorPlayer then
		impostorRole:FireClient(currentImpostorPlayer, {
			objective = store.current.objective,
		})
	end
end

local function roundLabel(round)
	if round and round > 0 then
		return round
	end
	local state = MatchState.liveState()
	if state then
		return MatchState.roundOf(state)
	end
	return round or 0
end

local function handleRoundEnd(round, winner)
	local reveal = ImpostorState.reveal(store, roundLabel(round), winner)
	currentImpostorPlayer = nil
	script:SetAttribute("CurrentImpostorUserId", nil)
	script:SetAttribute("CurrentImpostorTeam", nil)
	script:SetAttribute("CurrentImpostorObjective", nil)
	impostorReveal:FireAllClients(reveal)
end

local function wireRemotes()
	local matchSystems = ReplicatedStorage:FindFirstChild("MatchSystems")
	if not matchSystems then
		matchSystems = Instance.new("Folder")
		matchSystems.Name = "MatchSystems"
		matchSystems.Parent = ReplicatedStorage
	end

	impostorWarning = Instance.new("RemoteEvent")
	impostorWarning.Name = "ImpostorWarning"
	impostorWarning.Parent = matchSystems

	impostorRole = Instance.new("RemoteEvent")
	impostorRole.Name = "ImpostorRole"
	impostorRole.Parent = matchSystems

	impostorReveal = Instance.new("RemoteEvent")
	impostorReveal.Name = "ImpostorReveal"
	impostorReveal.Parent = matchSystems

	local impostorDebug = Instance.new("RemoteEvent")
	impostorDebug.Name = "ImpostorDebug"
	impostorDebug.Parent = matchSystems

	impostorDebug.OnServerEvent:Connect(function(player, command)
		if script:GetAttribute("DebugMode") ~= true then
			return
		end
		if command == "select" then
			local rows = {{
				userId = player.UserId,
				displayName = player.DisplayName,
				team = teamFor(player),
			}}
			if ImpostorState.select(store, rows, 1, function()
				return 1
			end) then
				ImpostorState.attachObjective(store, generateObjective())
			end
			applySelectedImpostor()
		elseif command == "reveal" then
			handleRoundEnd(roundLabel(currentRound), teamFor(player) or "Attackers")
		end
	end)
end

local function wireMatchEvents()
	local events = ServerScriptService.MatchManager.MatchManager:WaitForChild("Events", 30)
	local preRound = events:WaitForChild("PreRoundStarted", 30)
	preRound.Event:Connect(handlePreRound)
	local roundEnd = events:WaitForChild("RoundEnded", 30)
	roundEnd.Event:Connect(handleRoundEnd)
end

wireRemotes()
wireMatchEvents()
