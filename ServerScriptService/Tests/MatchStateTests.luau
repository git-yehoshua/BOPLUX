local MatchState = require(script.Parent.Parent.MatchManager.MatchState)

local TRACK = {
	Attackers = "Attackers",
	Defenders = "Defenders",
}

local function makePlayers(count)
	local players = {}
	for i = 1, count do
		table.insert(players, { UserId = i })
	end
	return players
end

local function startMatchWith(playerCount)
	local state = MatchState.new()
	MatchState.bindState(state)
	MatchState.assignRoles(state, makePlayers(playerCount))
	MatchState.beginPreRound(state, 1)
	return state
end

local function playLiveRound(state, winner)
	MatchState.step(state, 100)
	assert(MatchState.phaseOf(state) == MatchState.PHASE.Live)
	local accepted = MatchState.reportOutcome(state, winner)
	assert(accepted)
	MatchState.step(state, 1)
end

local function rolesSplit(state)
	local attackers = 0
	local defenders = 0
	for _, role in pairs(state.roles) do
		if role.team == MatchState.TEAM.Attackers then
			attackers = attackers + 1
		else
			defenders = defenders + 1
		end
	end
	return attackers, defenders
end

local function playFullMatch(state, pattern)
	for index, winner in ipairs(pattern) do
		if index > 1 then
			MatchState.step(state, 100)
		end
		playLiveRound(state, winner)
	end
end

return {
	["teams split 5v5 for ten players"] = function()
		local state = startMatchWith(10)
		local a, d = rolesSplit(state)
		assert(a == 5 and d == 5)
	end,
	["teams split 1v0 for one player"] = function()
		local state = startMatchWith(1)
		local a, d = rolesSplit(state)
		assert(a == 1 and d == 0)
	end,
	["teams split 3v2 for five players"] = function()
		local state = startMatchWith(5)
		local a, d = rolesSplit(state)
		assert(a == 3 and d == 2)
	end,
	["tied six rounds enters sudden-death round seven"] = function()
		local state = startMatchWith(10)
		local initialByUser = {}
		for _, role in pairs(state.roles) do
			initialByUser[role.player.UserId] = role.initialTeam
		end
		local pattern = {
			TRACK.Attackers, TRACK.Defenders, TRACK.Attackers,
			TRACK.Defenders, TRACK.Attackers, TRACK.Defenders,
		}
		playFullMatch(state, pattern)
		assert(MatchState.phaseOf(state) == MatchState.PHASE.RoundEnd)
		assert(MatchState.roundOf(state) == 6)
		assert(MatchState.resultOf(state) == nil)
		MatchState.step(state, 100)
		assert(MatchState.phaseOf(state) == MatchState.PHASE.PreRound)
		assert(MatchState.roundOf(state) == 7)
		for _, role in pairs(state.roles) do
			assert(role.team == initialByUser[role.player.UserId])
		end
	end,
	["sudden-death winner decides the match"] = function()
		local state = startMatchWith(10)
		local pattern = {
			TRACK.Attackers, TRACK.Defenders, TRACK.Attackers,
			TRACK.Defenders, TRACK.Attackers, TRACK.Defenders,
		}
		playFullMatch(state, pattern)
		MatchState.step(state, 100)
		playLiveRound(state, TRACK.Attackers)
		assert(MatchState.phaseOf(state) == MatchState.PHASE.MatchEnd)
		local result = MatchState.resultOf(state)
		assert(result.status == "attackerWon")
		assert(result.attackerRounds == 4)
		assert(result.defenderRounds == 3)
	end,
	["decisive six-round match ends without sudden death"] = function()
		local state = startMatchWith(10)
		local pattern = {
			TRACK.Attackers, TRACK.Attackers, TRACK.Attackers,
			TRACK.Attackers, TRACK.Defenders, TRACK.Defenders,
		}
		playFullMatch(state, pattern)
		assert(MatchState.phaseOf(state) == MatchState.PHASE.MatchEnd)
		assert(MatchState.resultOf(state).status == "attackerWon")
	end,
	["outcome ignored outside live phase"] = function()
		local state = startMatchWith(10)
		local accepted = MatchState.reportOutcome(state, TRACK.Attackers)
		assert(not accepted)
	end,
}