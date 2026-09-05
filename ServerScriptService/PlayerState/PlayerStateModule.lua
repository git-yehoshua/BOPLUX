local Players = game:GetService("Players")

local PlayerStateModule = {}

local stateBy = {}
local staminaCapacity = 6
local walkSpeed = 16
local sprintSpeed = 25
local rescueBuffSpeed = 21
local sprintRegenPerSecond = 1 / 3

function PlayerStateModule.register(player)
	local state = {
		player = player,
		stamina = staminaCapacity,
		sprinting = false,
		jailed = false,
		speedBuffUntil = 0,
		speedBuffActive = false,
		captureImmunityUntil = 0,
	}
	stateBy[player] = state
	return state
end

function PlayerStateModule.unregister(player)
	stateBy[player] = nil
end

function PlayerStateModule.stateFor(player)
	return stateBy[player]
end

local function humanoidFor(player)
	local character = player.Character
	if not character then
		return nil
	end
	return character:FindFirstChildOfClass("Humanoid")
end

local function applySpeed(player, state)
	local humanoid = humanoidFor(player)
	if not humanoid then
		return
	end
	if state.jailed then
		humanoid.WalkSpeed = 0
	elseif state.sprinting then
		humanoid.WalkSpeed = sprintSpeed
	elseif state.speedBuffActive then
		humanoid.WalkSpeed = rescueBuffSpeed
	else
		humanoid.WalkSpeed = walkSpeed
	end
end

function PlayerStateModule.step(player, dt)
	local state = stateBy[player]
	if not state then
		return
	end
	if state.sprinting then
		state.stamina = math.max(0, state.stamina - dt)
		if state.stamina <= 0 then
			state.sprinting = false
			applySpeed(player, state)
		end
	else
		state.stamina = math.min(staminaCapacity, state.stamina + dt * sprintRegenPerSecond)
	end
	if state.speedBuffActive and state.speedBuffUntil <= os.clock() then
		state.speedBuffActive = false
		applySpeed(player, state)
	end
end

function PlayerStateModule.requestSprint(player, wanted)
	local state = stateBy[player]
	if not state then
		return false
	end
	if wanted and (state.jailed or state.stamina <= 0) then
		return false
	end
	if state.sprinting ~= wanted then
		state.sprinting = wanted
		applySpeed(player, state)
	end
	return true
end

function PlayerStateModule.setJailed(player, jailed)
	local state = stateBy[player]
	if not state then
		return false
	end
	state.jailed = jailed
	if jailed then
		state.sprinting = false
	end
	applySpeed(player, state)
	local humanoid = humanoidFor(player)
	if humanoid then
		humanoid.JumpPower = jailed and 0 or 50
	end
	return true
end

function PlayerStateModule.isJailed(player)
	local state = stateBy[player]
	if not state then
		return false
	end
	return state.jailed
end

function PlayerStateModule.staminaOf(player)
	local state = stateBy[player]
	if not state then
		return 0
	end
	return state.stamina
end

function PlayerStateModule.isSprinting(player)
	local state = stateBy[player]
	if not state then
		return false
	end
	return state.sprinting
end

function PlayerStateModule.grantCaptureImmunity(player, seconds)
	local state = stateBy[player]
	if not state then
		return false
	end
	state.captureImmunityUntil = os.clock() + seconds
	return true
end

function PlayerStateModule.hasCaptureImmunity(player)
	local state = stateBy[player]
	if not state then
		return false
	end
	return state.captureImmunityUntil > os.clock()
end

function PlayerStateModule.grantSpeedBuff(player, seconds)
	local state = stateBy[player]
	if not state then
		return false
	end
	state.speedBuffUntil = os.clock() + seconds
	state.speedBuffActive = true
	applySpeed(player, state)
	return true
end

function PlayerStateModule.resetPlayerRound(player)
	local state = stateBy[player]
	if not state then
		return false
	end
	state.sprinting = false
	state.jailed = false
	state.stamina = staminaCapacity
	state.speedBuffUntil = 0
	state.speedBuffActive = false
	state.captureImmunityUntil = 0
	applySpeed(player, state)
	local humanoid = humanoidFor(player)
	if humanoid then
		humanoid.JumpPower = 50
	end
	return true
end

function PlayerStateModule.resetAllPlayers()
	for player in pairs(stateBy) do
		PlayerStateModule.resetPlayerRound(player)
	end
end

return PlayerStateModule