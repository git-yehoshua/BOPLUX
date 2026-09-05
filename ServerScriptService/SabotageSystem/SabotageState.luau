local SabotageState = {}

function SabotageState.new()
	return {
		cooldownUntil = nil,
	}
end

function SabotageState.validateRange(playerPosition, targetPosition, range)
	if not playerPosition or not targetPosition then
		return false
	end
	return (playerPosition - targetPosition).Magnitude <= range
end

function SabotageState.validateCooldown(state, now)
	if not state.cooldownUntil then
		return true
	end
	return now >= state.cooldownUntil
end

function SabotageState.recordCooldown(state, now, duration)
	state.cooldownUntil = now + duration
end

function SabotageState.remainingCooldown(state, now)
	if not state.cooldownUntil then
		return 0
	end
	local remaining = state.cooldownUntil - now
	if remaining <= 0 then
		return 0
	end
	return remaining
end

function SabotageState.determineContext(playerPosition, jailExteriors, siteCenters, range)
	if not playerPosition then
		return nil
	end

	for _, entry in ipairs(jailExteriors) do
		if SabotageState.validateRange(playerPosition, entry.position, range) then
			return { kind = "jail", id = entry.id }
		end
	end

	for _, entry in ipairs(siteCenters) do
		if SabotageState.validateRange(playerPosition, entry.position, range) then
			return { kind = "site", id = entry.id }
		end
	end

	return nil
end

function SabotageState.resetRound(state)
	state.cooldownUntil = nil
end

return SabotageState
