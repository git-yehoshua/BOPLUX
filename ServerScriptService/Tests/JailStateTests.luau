local JailState = require(script.Parent.Parent.JailSystem.JailState)

local NEXT_ID = 0

local function makePlayer()
	NEXT_ID = NEXT_ID + 1
	return { UserId = 1000 + NEXT_ID }
end

local function freshCell()
	NEXT_ID = NEXT_ID + 1
	local cellId = "U" .. tostring(NEXT_ID)
	JailState.registerCell(cellId, Vector3.new(0, 0, 0), Vector3.new(5, 0, 0), 45, 3)
	return cellId
end

return {
	["single release keeps the other occupant jailed"] = function()
		local cellId = freshCell()
		local a = makePlayer()
		local b = makePlayer()
		assert(JailState.jailPlayer(a, cellId))
		assert(JailState.jailPlayer(b, cellId))
		assert(JailState.occupantCount(cellId) == 2)
		assert(JailState.releasePlayer(a))
		assert(JailState.occupantCount(cellId) == 1)
		assert(JailState.isJailed(b))
		assert(not JailState.isJailed(a))
	end,
	["ejecting the active player clears only them"] = function()
		local cellId = freshCell()
		local a = makePlayer()
		local b = makePlayer()
		JailState.jailPlayer(a, cellId)
		JailState.jailPlayer(b, cellId)
		JailState.releasePlayer(a)
		assert(JailState.cellForPlayer(b) == cellId)
		assert(JailState.cellForPlayer(a) == nil)
	end,
	["releaseAll empties the cell and returns everyone"] = function()
		local cellId = freshCell()
		local a = makePlayer()
		local b = makePlayer()
		JailState.jailPlayer(a, cellId)
		JailState.jailPlayer(b, cellId)
		local released = JailState.releaseAll(cellId)
		assert(#released == 2)
		assert(JailState.occupantCount(cellId) == 0)
	end,
	["channel is exclusive per cell"] = function()
		local cellId = freshCell()
		local a = makePlayer()
		local b = makePlayer()
		assert(JailState.startChannel(cellId, "breakout", a, Vector3.new(0, 0, 0)))
		local ok, reason = JailState.startChannel(cellId, "rescue", b, Vector3.new(0, 0, 0))
		assert(not ok)
		assert(reason == "channel-busy")
	end,
	["completed channel clears for a new interaction"] = function()
		local cellId = freshCell()
		local a = makePlayer()
		JailState.startChannel(cellId, "breakout", a, Vector3.new(0, 0, 0))
		local result = JailState.stepChannel(cellId, 46)
		assert(result.complete)
		assert(JailState.startChannel(cellId, "rescue", a, Vector3.new(0, 0, 0)))
	end,
	["resetRound clears occupancy and channels"] = function()
		local cellId = freshCell()
		local a = makePlayer()
		JailState.jailPlayer(a, cellId)
		JailState.startChannel(cellId, "breakout", a, Vector3.new(0, 0, 0))
		JailState.resetRound()
		assert(JailState.occupantCount(cellId) == 0)
		assert(JailState.channelInfo(cellId) == nil)
	end,
}