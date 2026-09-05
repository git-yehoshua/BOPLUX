local MatchConfig = require(script.Parent.MatchConfig)

local PHASE = {
	Idle = "Idle",
	PreRound = "PreRound",
	Live = "Live",
	RoundEnd = "RoundEnd",
	MatchEnd = "MatchEnd",
}

local TEAM = {
	Attackers = "Attackers",
	Defenders = "Defenders",
}

local OTHER_TEAM = {
	[TEAM.Attackers] = TEAM.Defenders,
	[TEAM.Defenders] = TEAM.Attackers,
}

local liveState

local MatchState = {}
MatchState.PHASE = PHASE
MatchState.TEAM = TEAM

function MatchState.bindState(state)
	liveState = state
end

function MatchState.liveState()
	return liveState
end

local function buildMatchResult(roundsWon)
	local attackerRounds = roundsWon[TEAM.Attackers]
	local defenderRounds = roundsWon[TEAM.Defenders]
	local status
	if attackerRounds > defenderRounds then
		status = "attackerWon"
	elseif defenderRounds > attackerRounds then
		status = "defenderWon"
	else
		status = "tie_pending_oq010"
	end
	return {
		status = status,
		attackerRounds = attackerRounds,
		defenderRounds = defenderRounds,
	}
end

local function beginPreRound(state, roundNumber)
	state.roundNumber = roundNumber
	state.phase = PHASE.PreRound
	state.phaseDuration = MatchConfig.PreRoundDuration
	state.phaseElapsed = 0
	state.pendingOutcome = nil
	state.roundTimerSuperseded = false
end

local function beginLive(state)
	state.phase = PHASE.Live
	state.phaseDuration = MatchConfig.RoundDuration
	state.phaseElapsed = 0
end

local function recordRoundWin(state, winner, reason)
	state.roundsWon[winner] = state.roundsWon[winner] + 1
	table.insert(state.roundOutcomes, {
		round = state.roundNumber,
		winner = winner,
		reason = reason,
	})
end

local function endRound(state, winner, reason, events)
	if state.roundNumber >= MatchConfig.RoundsPerMatch then
		state.phase = PHASE.MatchEnd
		state.matchResult = buildMatchResult(state.roundsWon)
		recordRoundWin(state, winner, reason)
		table.insert(events, {
			event = "MatchEnded",
			result = state.matchResult,
			lastRoundWinner = winner,
			lastRoundReason = reason,
		})
	else
		recordRoundWin(state, winner, reason)
		state.phase = PHASE.RoundEnd
		state.phaseDuration = MatchConfig.RoundEndGraceDuration
		state.phaseElapsed = 0
		state.pendingOutcome = nil
		table.insert(events, {
			event = "RoundEnded",
			round = state.roundNumber,
			winner = winner,
			reason = reason,
		})
	end
end

function MatchState.new()
	return {
		phase = PHASE.Idle,
		roundNumber = 0,
		phaseDuration = 0,
		phaseElapsed = 0,
		pendingOutcome = nil,
		roundTimerSuperseded = false,
		roundsWon = {
			[TEAM.Attackers] = 0,
			[TEAM.Defenders] = 0,
		},
		roundOutcomes = {},
		matchResult = nil,
		roles = {},
	}
end

function MatchState.assignRoles(state, players)
	for index, player in ipairs(players) do
		local initialTeam = index <= MatchConfig.TeamSize and TEAM.Attackers or TEAM.Defenders
		state.roles[player.UserId] = {
			player = player,
			initialTeam = initialTeam,
			team = initialTeam,
		}
	end
	return state.roles
end

function MatchState.teamFor(state, player)
	local role = state.roles[player.UserId]
	if role then
		return role.team
	end
	return nil
end

function MatchState.swapRoles(state)
	for _, role in pairs(state.roles) do
		role.team = OTHER_TEAM[role.team]
	end
end

function MatchState.beginPreRound(state, roundNumber)
	beginPreRound(state, roundNumber)
	return state
end

function MatchState.reportOutcome(state, team, reason)
	if state.phase ~= PHASE.Live then
		return false, "outcome-ignored-not-in-live-round"
	end
	state.pendingOutcome = {
		team = team,
		reason = reason or "reported",
	}
	return true
end

function MatchState.step(state, dt)
	local events = {}

	if state.phase == PHASE.Idle or state.phase == PHASE.MatchEnd then
		return events
	end

	state.phaseElapsed = state.phaseElapsed + dt
	local remaining = state.phaseDuration - state.phaseElapsed

	if state.phase == PHASE.PreRound then
		if remaining <= 0 then
			beginLive(state)
			table.insert(events, {
				event = "LiveStarted",
				round = state.roundNumber,
			})
		end
	elseif state.phase == PHASE.Live then
		if state.pendingOutcome then
			local outcome = state.pendingOutcome
			state.pendingOutcome = nil
			endRound(state, outcome.team, outcome.reason, events)
		elseif (not state.roundTimerSuperseded) and remaining <= 0 then
			endRound(state, TEAM.Defenders, "timer-expired-before-plant", events)
		end
	elseif state.phase == PHASE.RoundEnd then
		if remaining <= 0 then
			local nextRound = state.roundNumber + 1
			local enteredHalfTwo = nextRound == MatchConfig.RoundsPerHalf + 1
			if enteredHalfTwo then
				MatchState.swapRoles(state)
				table.insert(events, {
					event = "Halftime",
					round = nextRound,
				})
			end
			beginPreRound(state, nextRound)
			table.insert(events, {
				event = "PreRoundStarted",
				round = nextRound,
			})
		end
	end

	return events
end

function MatchState.phaseOf(state)
	return state.phase
end

function MatchState.supersedeRoundTimer(state)
	state.roundTimerSuperseded = true
end

function MatchState.roundOf(state)
	return state.roundNumber
end

function MatchState.scoreOf(state)
	return {
		[TEAM.Attackers] = state.roundsWon[TEAM.Attackers],
		[TEAM.Defenders] = state.roundsWon[TEAM.Defenders],
	}
end

function MatchState.resultOf(state)
	return state.matchResult
end

function MatchState.outcomesOf(state)
	return state.roundOutcomes
end

return MatchState