local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MatchConfig = require(script.Parent.MatchConfig)
local MatchState = require(script.Parent.MatchState)

local matchSystems = ReplicatedStorage:WaitForChild("MatchSystems")
local matchStateSync = matchSystems:WaitForChild("MatchStateSync")

local eventsFolder = Instance.new("Folder")
eventsFolder.Name = "Events"
eventsFolder.Parent = script

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
			task.wait(3)
			if state.phase == MatchState.PHASE.Idle and #Players:GetPlayers() > 0 then
				beginMatch()
			end
		end
	end
end)
