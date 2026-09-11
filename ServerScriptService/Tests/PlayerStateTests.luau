local PlayerStateModule = require(script.Parent.Parent.PlayerState.PlayerStateModule)

local NEXT_ID = 0

local function makePlayer()
	NEXT_ID = NEXT_ID + 1
	return { UserId = 2000 + NEXT_ID }
end

return {
	["crouch grants at full state and clears cleanly"] = function()
		local player = makePlayer()
		PlayerStateModule.register(player)
		assert(PlayerStateModule.requestCrouch(player, true))
		assert(PlayerStateModule.isCrouching(player))
		assert(PlayerStateModule.requestCrouch(player, false))
		assert(not PlayerStateModule.isCrouching(player))
		PlayerStateModule.unregister(player)
	end,
	["crouch is denied while jailed"] = function()
		local player = makePlayer()
		PlayerStateModule.register(player)
		PlayerStateModule.setJailed(player, true)
		assert(not PlayerStateModule.requestCrouch(player, true))
		assert(not PlayerStateModule.isCrouching(player))
		PlayerStateModule.unregister(player)
	end,
	["crouch cancels an active sprint"] = function()
		local player = makePlayer()
		PlayerStateModule.register(player)
		assert(PlayerStateModule.requestSprint(player, true))
		assert(PlayerStateModule.isSprinting(player))
		assert(PlayerStateModule.requestCrouch(player, true))
		assert(PlayerStateModule.isCrouching(player))
		assert(not PlayerStateModule.isSprinting(player))
		PlayerStateModule.unregister(player)
	end,
	["sprint is denied while crouching"] = function()
		local player = makePlayer()
		PlayerStateModule.register(player)
		assert(PlayerStateModule.requestCrouch(player, true))
		assert(not PlayerStateModule.requestSprint(player, true))
		assert(not PlayerStateModule.isSprinting(player))
		PlayerStateModule.unregister(player)
	end,
	["jailing clears crouch"] = function()
		local player = makePlayer()
		PlayerStateModule.register(player)
		PlayerStateModule.requestCrouch(player, true)
		PlayerStateModule.setJailed(player, true)
		assert(not PlayerStateModule.isCrouching(player))
		PlayerStateModule.unregister(player)
	end,
	["round reset clears crouch"] = function()
		local player = makePlayer()
		PlayerStateModule.register(player)
		PlayerStateModule.requestCrouch(player, true)
		PlayerStateModule.resetPlayerRound(player)
		assert(not PlayerStateModule.isCrouching(player))
		PlayerStateModule.unregister(player)
	end,
	["crouch on unknown player is denied"] = function()
		assert(not PlayerStateModule.requestCrouch({ UserId = 999999 }, true))
		assert(not PlayerStateModule.isCrouching({ UserId = 999999 }))
	end,
}
