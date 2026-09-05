local ImpostorState = {}

ImpostorState.SELECTION_CHANCE = 0.3

ImpostorState.WARNING_MESSAGE = "An Impostor is among you. Watch the flanks and the objective."

function ImpostorState.new()
	return {
		current = nil,
	}
end

local function pick(rows, rng)
	local n = #rows
	if n == 0 then
		return nil
	end
	return rows[rng(n)]
end

function ImpostorState.select(state, rows, chance, rng)
	if rng() > (chance or ImpostorState.SELECTION_CHANCE) then
		return nil
	end
	local row = pick(rows, rng)
	if not row then
		return nil
	end
	state.current = {
		userId = row.userId,
		displayName = row.displayName,
		team = row.team,
		objective = nil,
	}
	return state.current
end

function ImpostorState.attachObjective(state, objective)
	if state.current then
		state.current.objective = objective
	end
	return state.current
end

local OBJECTIVE_TEXT = {
	breakout = function(target)
		if not target then
			return "Reset an in-progress breakout at a Jail"
		end
		return "Reset the in-progress breakout at Jail " .. tostring(target)
	end,
	plant = function(target)
		if not target then
			return "Cancel an active plant or defuse at a plant site"
		end
		return "Cancel an active plant or defuse at Plant Site " .. tostring(target)
	end,
}

function ImpostorState.buildObjective(kind, targetId)
	local style = OBJECTIVE_TEXT[kind]
	return {
		kind = kind,
		target = targetId or nil,
		text = style and style(targetId) or "Complete your sabotage objective",
	}
end

function ImpostorState.winsFor(state, roundWinner)
	local current = state.current
	if not current then
		return nil
	end
	return current.team ~= roundWinner
end

function ImpostorState.reveal(state, round, roundWinner)
	local current = state.current
	local won
	if current then
		won = current.team ~= roundWinner
	end
	local result = {
		userId = current and current.userId,
		displayName = current and current.displayName,
		impostorWon = won,
		round = round,
	}
	state.current = nil
	return result
end

return ImpostorState
