local JailState = {}

local cells = {}
local jailByPlayer = {}

function JailState.registerCell(id, center, exterior, breakoutDuration, rescueDuration)
	cells[id] = {
		id = id,
		center = center,
		exterior = exterior,
		breakoutDuration = breakoutDuration,
		rescueDuration = rescueDuration,
		occupants = {},
		channel = nil,
	}
end

function JailState.cellIds()
	local ids = {}
	for id in pairs(cells) do
		table.insert(ids, id)
	end
	table.sort(ids)
	return ids
end

function JailState.cellForPlayer(player)
	return jailByPlayer[player]
end

function JailState.isJailed(player)
	return jailByPlayer[player] ~= nil
end

function JailState.occupantCount(cellId)
	local cell = cells[cellId]
	if not cell then
		return 0
	end
	local count = 0
	for _ in pairs(cell.occupants) do
		count = count + 1
	end
	return count
end

function JailState.jailPlayer(player, cellId)
	local cell = cells[cellId]
	if not cell or jailByPlayer[player] then
		return false
	end
	cell.occupants[player] = true
	jailByPlayer[player] = cellId
	return true
end

function JailState.releasePlayer(player)
	local cellId = jailByPlayer[player]
	if not cellId then
		return false
	end
	local cell = cells[cellId]
	if cell then
		cell.occupants[player] = nil
	end
	jailByPlayer[player] = nil
	return true
end

function JailState.releaseAll(cellId)
	local cell = cells[cellId]
	if not cell then
		return {}
	end
	local released = {}
	for player in pairs(cell.occupants) do
		table.insert(released, player)
		jailByPlayer[player] = nil
		cell.occupants[player] = nil
	end
	return released
end

function JailState.startChannel(cellId, kind, player, startPos)
	local cell = cells[cellId]
	if not cell then
		return false, "no-cell"
	end
	if cell.channel then
		return false, "channel-busy"
	end
	cell.channel = {
		kind = kind,
		player = player,
		progress = 0,
		startPos = startPos,
	}
	return true
end

function JailState.cancelChannel(cellId)
	local cell = cells[cellId]
	if not cell or not cell.channel then
		return false
	end
	cell.channel = nil
	return true
end

function JailState.cancelChannelFor(player)
	for _, cell in pairs(cells) do
		if cell.channel and cell.channel.player == player then
			cell.channel = nil
			return true
		end
	end
	return false
end

function JailState.channelInfo(cellId)
	local cell = cells[cellId]
	if not cell or not cell.channel then
		return nil
	end
	return {
		kind = cell.channel.kind,
		player = cell.channel.player,
		progress = cell.channel.progress,
		startPos = cell.channel.startPos,
	}
end

function JailState.resetBreakout(cellId)
	local cell = cells[cellId]
	if not cell or not cell.channel or cell.channel.kind ~= "breakout" then
		return false
	end
	cell.channel.progress = 0
	cell.channel.startPos = nil
	return true
end

function JailState.stepChannel(cellId, dt)
	local cell = cells[cellId]
	if not cell or not cell.channel then
		return nil
	end
	local channel = cell.channel
	local duration = channel.kind == "breakout" and cell.breakoutDuration or cell.rescueDuration
	channel.progress = channel.progress + dt
	if channel.progress >= duration then
		cell.channel = nil
		return {
			kind = channel.kind,
			complete = true,
			player = channel.player,
		}
	end
	return {
		kind = channel.kind,
		progress = channel.progress,
		complete = false,
	}
end

function JailState.resetRound()
	for player, cellId in pairs(jailByPlayer) do
		local cell = cells[cellId]
		if cell then
			cell.occupants[player] = nil
		end
		jailByPlayer[player] = nil
	end
	for _, cell in pairs(cells) do
		cell.channel = nil
	end
end

return JailState