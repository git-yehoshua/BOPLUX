local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MatchConfig = require(script.Parent.MatchConfig)
local MatchState = require(script.Parent.MatchState)

local matchSystems = ReplicatedStorage:WaitForChild("MatchSystems", 10)
if not matchSystems then
	matchSystems = Instance.new("Folder")
	matchSystems.Name = "MatchSystems"
	matchSystems.Parent = ReplicatedStorage
end

local matchStateSync = matchSystems:WaitForChild("MatchStateSync", 10)
if not matchStateSync then
	local remote = Instance.new("RemoteEvent")
	remote.Name = "MatchStateSync"
	remote.Parent = matchSystems
end

local playerStateSync = matchSystems:FindFirstChild("PlayerStateSync")
if not playerStateSync then
	local remote = Instance.new("RemoteEvent")
	remote.Name = "PlayerStateSync"
	remote.Parent = matchSystems
end

local eventsFolder = Instance.new("Folder")
eventsFolder.Name = "Events"
eventsFolder.Parent = script

-- Team spawn rooms (Courtyard_v001 contract; MapRuntime.MapBuilder SPAWN_ROOMS).
-- Server positions players by match role each pre-round — neutral SpawnLocations
-- cannot do team assignment (multi-player pass finding #2).
local SPAWN_POINTS = {
	[MatchState.TEAM.Attackers] = Vector3.new(75, 4, 75),
	[MatchState.TEAM.Defenders] = Vector3.new(-75, 4, -75),
}

local SPAWN_JITTER = {
	Vector3.new(0, 0, 0),
	Vector3.new(4, 0, 4),
	Vector3.new(-4, 0, 4),
	Vector3.new(4, 0, -4),
	Vector3.new(-4, 0, -4),
}

local function repositionPlayers()
	-- Uses liveState() rather than the module-local `state`: this function is defined
	-- before that local is declared, so the name would resolve as a nil global here
	-- (multi-player pass finding #5 - the silent 'attempt to index nil' at every phase transition).
	local live = MatchState.liveState()
	if not live then
		return
	end
	local index = 0
	for _, player in ipairs(Players:GetPlayers()) do
		local team = MatchState.teamFor(live, player)
		local base = team and SPAWN_POINTS[team]
		if base then
			local character = player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			if root then
				index = index + 1
				root.CFrame = CFrame.new(base + SPAWN_JITTER[((index - 1) % #SPAWN_JITTER) + 1])
			end
		end
	end
end

local phaseChanged = Instance.new("BindableEvent")
phaseChanged.Name = "PhaseChanged"
phaseChanged.Parent = eventsFolder

local preRoundStarted = Instance.new("BindableEvent")
preRoundStarted.Name = "PreRoundStarted"
preRoundStarted.Parent = eventsFolder

local roundEnded = Instance.new("BindableEvent")
roundEnded.Name = "RoundEnded"
roundEnded.Parent = eventsFolder

local matchEnded = Instance.new("BindableEvent")
matchEnded.Name = "MatchEnded"
matchEnded.Parent = eventsFolder

local roundOutcomeReported = Instance.new("BindableEvent")
roundOutcomeReported.Name = "RoundOutcomeReported"
roundOutcomeReported.Parent = eventsFolder

local state = MatchState.new()
MatchState.bindState(state)

shared.MatchPhaseApi = {
	getPhase = function()
		return MatchState.phaseOf(state)
	end,
	getRound = function()
		return MatchState.roundOf(state)
	end,
}

local function snapshotActivePlayers()
	local sorted = {}
	for _, player in ipairs(Players:GetPlayers()) do
		table.insert(sorted, player)
	end
	table.sort(sorted, function(a, b)
		return a.UserId < b.UserId
	end)
	return sorted
end

local function fireMatchSync()
	local timeRemaining = math.max(0, state.phaseDuration - state.phaseElapsed)
	local score = {
		Attackers = state.roundsWon[MatchState.TEAM.Attackers],
		Defenders = state.roundsWon[MatchState.TEAM.Defenders],
	}
	for _, player in ipairs(Players:GetPlayers()) do
		local role = state.roles and state.roles[player.UserId]
		local playerTeam = role and role.team or nil
		matchStateSync:FireClient(player, {
			phase = MatchState.phaseOf(state),
			round = MatchState.roundOf(state),
			timeRemaining = timeRemaining,
			score = score,
			playerTeam = playerTeam,
			isSpectator = playerTeam == nil,
		})
	end
end

local function beginMatch()
	local roster = snapshotActivePlayers()
	MatchState.assignRoles(state, roster)
	MatchState.beginPreRound(state, 1)
	script:SetAttribute("Phase", MatchState.phaseOf(state))
	script:SetAttribute("Round", MatchState.roundOf(state))
	phaseChanged:Fire(MatchState.phaseOf(state), MatchState.roundOf(state))
	preRoundStarted:Fire(MatchState.roundOf(state))
	fireMatchSync()
	task.defer(repositionPlayers)
	task.delay(0.5, repositionPlayers)
end

local function beginNextMatch()
	state = MatchState.new()
	MatchState.bindState(state)
	beginMatch()
end

local function handleEvents(events)
	for _, e in ipairs(events) do
		if e.event == "LiveStarted" then
			script:SetAttribute("Phase", "Live")
			script:SetAttribute("Round", e.round)
			phaseChanged:Fire(MatchState.phaseOf(state), e.round)
			fireMatchSync()
		elseif e.event == "RoundEnded" then
			script:SetAttribute("Phase", "RoundEnd")
			script:SetAttribute("Round", e.round)
			phaseChanged:Fire(MatchState.phaseOf(state), e.round)
			roundEnded:Fire(e.round, e.winner, e.reason)
			fireMatchSync()
		elseif e.event == "Halftime" then
			script:SetAttribute("Phase", "Halftime")
			script:SetAttribute("Round", e.round)
			phaseChanged:Fire("Halftime", e.round)
			fireMatchSync()
		elseif e.event == "PreRoundStarted" then
			script:SetAttribute("Phase", "PreRound")
			script:SetAttribute("Round", e.round)
			phaseChanged:Fire(MatchState.phaseOf(state), e.round)
			preRoundStarted:Fire(e.round)
			fireMatchSync()
			task.defer(repositionPlayers)
			task.delay(0.5, repositionPlayers)
		elseif e.event == "MatchEnded" then
			script:SetAttribute("Phase", "MatchEnd")
			script:SetAttribute("Round", MatchState.roundOf(state))
			phaseChanged:Fire(MatchState.phaseOf(state), e.round)
			roundEnded:Fire(0, e.lastRoundWinner, e.lastRoundReason)
			matchEnded:Fire(e.result)
			fireMatchSync()
			task.wait(5)
			beginNextMatch()
		end
	end
end

roundOutcomeReported.Event:Connect(function(winner, reason)
	MatchState.reportOutcome(state, winner, reason)
end)

-- Robust roster handling (multi-player pass findings #1/#2 hardening):
-- clients in a local test connect staggered; any player present before round-1 Live
-- must be folded into the roster (OQ-012 only bars joining mid-match, not mid-setup).
Players.PlayerAdded:Connect(function(player)
	if state.phase == MatchState.PHASE.Idle then
		return -- Idle watcher's settle loop handles this
	end
	if state.phase == MatchState.PHASE.PreRound and MatchState.roundOf(state) == 1 then
		task.delay(1, function()
			if state.phase == MatchState.PHASE.PreRound and MatchState.roundOf(state) == 1 then
				MatchState.assignRoles(state, snapshotActivePlayers())
				repositionPlayers()
				fireMatchSync()
				print("[MatchManager] Roster re-assigned for pre-live join: " .. player.Name)
			end
		end)
	end
end)

RunService.Heartbeat:Connect(function(dt)
	if state.phase == MatchState.PHASE.Idle then
		return
	end
	local events = MatchState.step(state, dt)
	handleEvents(events)
end)

task.spawn(function()
	while true do
		task.wait(1)
		if state.phase == MatchState.PHASE.Idle and #Players:GetPlayers() > 0 then
			-- Roster settle: wait for all clients to connect before assigning teams.
			-- Fix for multi-player pass finding #1: the match previously began 3s after
			-- the FIRST client connected, leaving later clients with no team (nil role).
			-- Settle = stable player count for 2 consecutive seconds (max 10s wait).
			local lastCount = #Players:GetPlayers()
			local stableFor = 0
			for _ = 1, 10 do
				task.wait(1)
				local count = #Players:GetPlayers()
				if count ~= lastCount then
					lastCount = count
					stableFor = 0
				else
					stableFor = stableFor + 1
					if stableFor >= 3 then
						break
					end
				end
			end
			if state.phase == MatchState.PHASE.Idle and #Players:GetPlayers() > 0 then
				beginMatch()
			end
		end
	end
end)
