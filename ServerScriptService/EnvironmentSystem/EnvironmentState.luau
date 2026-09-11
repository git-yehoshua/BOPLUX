-- EnvironmentState: pure per-match environment state (mode roll, flashlight
-- permission matrix, battery drain/recharge). No instance access — the runner
-- (RunEnvironmentSystem) applies everything to the DataModel, and the tests
-- drive this module directly.
local EnvironmentConfig = require(script.Parent.EnvironmentConfig)

local MODE = {
	Day = "Day",
	Night = "Night",
}

local EnvironmentState = {}
EnvironmentState.MODE = MODE

function EnvironmentState.new()
	return {
		mode = nil,
		players = {},
	}
end

-- Deterministic under an injected rand() -> [0, 1) so tests can pin the roll.
function EnvironmentState.rollMode(rand)
	return rand() < EnvironmentConfig.NightChance and MODE.Night or MODE.Day
end

function EnvironmentState.startMatch(state, rand)
	state.mode = EnvironmentState.rollMode(rand)
	return state.mode
end

function EnvironmentState.register(state, player)
	local env = {
		flashlightOn = false,
		battery = EnvironmentConfig.BatteryMax,
		emptyLatch = false,
	}
	state.players[player] = env
	return env
end

function EnvironmentState.unregister(state, player)
	state.players[player] = nil
end

function EnvironmentState.envFor(state, player)
	return state.players[player]
end

function EnvironmentState.resetPlayerRound(env)
	env.flashlightOn = false
	env.battery = EnvironmentConfig.BatteryMax
	env.emptyLatch = false
end

function EnvironmentState.resetAllRounds(state)
	for _, env in pairs(state.players) do
		EnvironmentState.resetPlayerRound(env)
	end
end

-- Permission matrix for a toggle request; the runner validates character and
-- alive state separately. `wanted` is the target power state. Returns granted
-- and a machine-readable reason for denies.
function EnvironmentState.toggleFlashlight(state, env, wanted)
	if state.mode ~= MODE.Night then
		return false, "flashlight-day-mode"
	end
	if wanted and env.emptyLatch and env.battery < EnvironmentConfig.BatteryResumeThreshold then
		return false, "flashlight-battery-empty"
	end
	return true
end

-- dt-scaled battery step: drains while on (auto-cutoff + latch at empty),
-- recharges while off and clears the latch at the resume threshold.
function EnvironmentState.stepBattery(env, dt)
	if env.flashlightOn then
		env.battery = math.max(0, env.battery - EnvironmentConfig.BatteryDrainPerSecond * dt)
		if env.battery <= 0 then
			env.flashlightOn = false
			env.emptyLatch = true
		end
	else
		env.battery = math.min(EnvironmentConfig.BatteryMax, env.battery + EnvironmentConfig.BatteryRegenPerSecond * dt)
		if env.emptyLatch and env.battery >= EnvironmentConfig.BatteryResumeThreshold then
			env.emptyLatch = false
		end
	end
end

return EnvironmentState
