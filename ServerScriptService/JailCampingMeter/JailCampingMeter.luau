local JailCampingMeter = {}
local JailCampingMeterConfig = require(script.Parent.JailCampingMeterConfig)

function JailCampingMeter.new()
	return { jails = {} }
end

function JailCampingMeter.newJail(state, cellId)
	state.jails[cellId] = {
		cellId = cellId, defenderUserId = nil, graceStart = nil, fillStart = nil, isFull = false,
	}
end

function JailCampingMeter.getMeter(state, cellId, now)
	local j = state.jails[cellId]
	if not j then return 0 end
	if j.isFull then return 1 end
	if not j.fillStart then return 0 end
	return math.min((now - j.fillStart) / JailCampingMeterConfig.FillTime, 1)
end

function JailCampingMeter.isFull(state, cellId, now)
	return JailCampingMeter.getMeter(state, cellId, now) >= 1
end

function JailCampingMeter.update(state, defenderUserId, cellId, now)
	local j = state.jails[cellId]
	if not j then JailCampingMeter.newJail(state, cellId); j = state.jails[cellId] end
	if defenderUserId then
		j.defenderUserId = defenderUserId
		if not j.graceStart then j.graceStart = now end
		if not j.fillStart and (now - j.graceStart) >= JailCampingMeterConfig.GracePeriod then
			j.fillStart = j.graceStart + JailCampingMeterConfig.GracePeriod
		end
		if JailCampingMeter.isFull(state, cellId, now) then j.isFull = true end
	else
		j.defenderUserId = nil; j.graceStart = nil; j.fillStart = nil; j.isFull = false
	end
end

function JailCampingMeter.selfRescue(state, cellId, jailState, playerState)
	local j = state.jails[cellId]
	if not j or not j.isFull then return false end
	local occupants = {}
	for _, id in ipairs(jailState.cellIds()) do
		local info = jailState.channelInfo(id)
		if info and info.player then table.insert(occupants, info.player) end
	end
	if #occupants == 0 then return false end
	local buffSeconds = JailCampingMeterConfig.BuffSeconds
	for _, occupant in ipairs(occupants) do
		playerState.grantSpeedBuff(occupant, buffSeconds)
		playerState.grantCaptureImmunity(occupant, buffSeconds)
		jailState.releasePlayer(occupant)
	end
	j.isFull = false; j.graceStart = nil; j.fillStart = nil; j.defenderUserId = nil
	return true
end

function JailCampingMeter.resetRound(state)
	for _, j in pairs(state.jails) do
		j.defenderUserId = nil; j.graceStart = nil; j.fillStart = nil; j.isFull = false
	end
end

return JailCampingMeter
