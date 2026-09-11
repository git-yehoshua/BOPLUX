local EnvironmentState = require(script.Parent.Parent.EnvironmentSystem.EnvironmentState)
local EnvironmentConfig = require(script.Parent.Parent.EnvironmentSystem.EnvironmentConfig)

local MODE = EnvironmentState.MODE

local function alwaysDay()
	return 0.99
end

local function alwaysNight()
	return 0.01
end

return {
	["night chance rolls per injected rand"] = function()
		assert(EnvironmentState.rollMode(alwaysNight) == MODE.Night)
		assert(EnvironmentState.rollMode(alwaysDay) == MODE.Day)
	end,
	["startMatch pins one mode for the whole state"] = function()
		local state = EnvironmentState.new()
		assert(EnvironmentState.startMatch(state, alwaysNight) == MODE.Night)
		assert(state.mode == MODE.Night)
		EnvironmentState.startMatch(state, alwaysDay)
		assert(state.mode == MODE.Day)
	end,
	["toggle is denied in day mode regardless of request"] = function()
		local state = EnvironmentState.new()
		EnvironmentState.startMatch(state, alwaysDay)
		local player = { UserId = 1 }
		local env = EnvironmentState.register(state, player)
		local grantedOn, reasonOn = EnvironmentState.toggleFlashlight(state, env, true)
		assert(not grantedOn)
		assert(reasonOn == "flashlight-day-mode")
		local grantedOff = EnvironmentState.toggleFlashlight(state, env, false)
		assert(not grantedOff)
	end,
	["toggle is granted in night mode with battery"] = function()
		local state = EnvironmentState.new()
		EnvironmentState.startMatch(state, alwaysNight)
		local player = { UserId = 2 }
		local env = EnvironmentState.register(state, player)
		local granted, reason = EnvironmentState.toggleFlashlight(state, env, true)
		assert(granted, reason)
	end,
	["battery drains while on and auto-cutoffs at empty with a latch"] = function()
		local state = EnvironmentState.new()
		EnvironmentState.startMatch(state, alwaysNight)
		local player = { UserId = 3 }
		local env = EnvironmentState.register(state, player)
		env.flashlightOn = true
		EnvironmentState.stepBattery(env, 40)
		assert(env.battery == 20)
		EnvironmentState.stepBattery(env, 40)
		assert(env.battery == 0)
		assert(env.flashlightOn == false)
		assert(env.emptyLatch == true)
		assert(not EnvironmentState.toggleFlashlight(state, env, true))
	end,
	["latch releases only at the resume threshold while recharging"] = function()
		local state = EnvironmentState.new()
		EnvironmentState.startMatch(state, alwaysNight)
		local player = { UserId = 4 }
		local env = EnvironmentState.register(state, player)
		env.battery = 0
		env.emptyLatch = true
		EnvironmentState.stepBattery(env, 2)
		assert(env.battery == 10)
		assert(env.emptyLatch == true)
		assert(not EnvironmentState.toggleFlashlight(state, env, true))
		EnvironmentState.stepBattery(env, 1)
		assert(env.battery >= EnvironmentConfig.BatteryResumeThreshold)
		assert(env.emptyLatch == false)
		assert(EnvironmentState.toggleFlashlight(state, env, true))
	end,
	["battery recharges while off and caps at max"] = function()
		local state = EnvironmentState.new()
		EnvironmentState.startMatch(state, alwaysNight)
		local player = { UserId = 5 }
		local env = EnvironmentState.register(state, player)
		env.battery = 50
		EnvironmentState.stepBattery(env, 10)
		assert(env.battery == 100)
		EnvironmentState.stepBattery(env, 10)
		assert(env.battery == 100)
	end,
	["resetPlayerRound restores a fresh battery and clears the latch"] = function()
		local state = EnvironmentState.new()
		EnvironmentState.startMatch(state, alwaysNight)
		local player = { UserId = 6 }
		local env = EnvironmentState.register(state, player)
		env.battery = 0
		env.emptyLatch = true
		env.flashlightOn = true
		EnvironmentState.resetPlayerRound(env)
		assert(env.battery == EnvironmentConfig.BatteryMax)
		assert(env.emptyLatch == false)
		assert(env.flashlightOn == false)
	end,
	["resetAllRounds resets every registered player"] = function()
		local state = EnvironmentState.new()
		EnvironmentState.startMatch(state, alwaysNight)
		local a = EnvironmentState.register(state, { UserId = 7 })
		local b = EnvironmentState.register(state, { UserId = 8 })
		a.battery = 0
		a.emptyLatch = true
		b.battery = 5
		EnvironmentState.resetAllRounds(state)
		assert(a.battery == EnvironmentConfig.BatteryMax)
		assert(b.battery == EnvironmentConfig.BatteryMax)
	end,
	["unregister removes the player environment"] = function()
		local state = EnvironmentState.new()
		EnvironmentState.startMatch(state, alwaysNight)
		local player = { UserId = 9 }
		EnvironmentState.register(state, player)
		assert(EnvironmentState.envFor(state, player))
		EnvironmentState.unregister(state, player)
		assert(EnvironmentState.envFor(state, player) == nil)
	end,
}
