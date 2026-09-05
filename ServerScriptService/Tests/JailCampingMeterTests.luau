local ServerScriptService = game:GetService("ServerScriptService")
local JailCampingMeter = require(ServerScriptService.JailCampingMeter.JailCampingMeter)
local JailCampingMeterConfig = require(ServerScriptService.JailCampingMeter.JailCampingMeterConfig)

local function approx(a, b, eps)
	return math.abs(a - b) <= (eps or 0.01)
end

return {
	["meter starts at zero for unknown jail"] = function()
		local state = JailCampingMeter.new()
		assert(approx(JailCampingMeter.getMeter(state, "A"), 0))
	end,
	["meter is full after fill time"] = function()
		local state = JailCampingMeter.new()
		JailCampingMeter.newJail(state, "A")
		JailCampingMeter.update(state, 1, "A", 0)
		assert(not JailCampingMeter.isFull(state, "A", 0))
		JailCampingMeter.update(state, 1, "A", JailCampingMeterConfig.GracePeriod + JailCampingMeterConfig.FillTime)
		assert(JailCampingMeter.isFull(state, "A", JailCampingMeterConfig.GracePeriod + JailCampingMeterConfig.FillTime))
	end,
	["meter is not full during grace period"] = function()
		local state = JailCampingMeter.new()
		JailCampingMeter.newJail(state, "A")
		JailCampingMeter.update(state, 1, "A", 0)
		JailCampingMeter.update(state, 1, "A", JailCampingMeterConfig.GracePeriod - 1)
		assert(not JailCampingMeter.isFull(state, "A", JailCampingMeterConfig.GracePeriod - 1))
	end,
	["meter depletes when defender leaves"] = function()
		local state = JailCampingMeter.new()
		JailCampingMeter.newJail(state, "A")
		JailCampingMeter.update(state, 1, "A", 0)
		JailCampingMeter.update(state, 1, "A", JailCampingMeterConfig.GracePeriod + JailCampingMeterConfig.FillTime)
		assert(JailCampingMeter.isFull(state, "A", JailCampingMeterConfig.GracePeriod + JailCampingMeterConfig.FillTime))
		JailCampingMeter.update(state, nil, "A", JailCampingMeterConfig.GracePeriod + JailCampingMeterConfig.FillTime + 1)
		assert(not JailCampingMeter.isFull(state, "A", JailCampingMeterConfig.GracePeriod + JailCampingMeterConfig.FillTime + 1))
	end,
	["resetRound clears all meters"] = function()
		local state = JailCampingMeter.new()
		JailCampingMeter.newJail(state, "A")
		JailCampingMeter.update(state, 1, "A", 0)
		JailCampingMeter.update(state, 1, "A", JailCampingMeterConfig.GracePeriod + JailCampingMeterConfig.FillTime)
		JailCampingMeter.resetRound(state)
		assert(not JailCampingMeter.isFull(state, "A", 0))
	end,
	["selfRescue returns false when not full"] = function()
		local state = JailCampingMeter.new()
		JailCampingMeter.newJail(state, "A")
		assert(JailCampingMeter.selfRescue(state, "A", nil, nil) == false)
	end,
	["newJail creates correct state"] = function()
		local state = JailCampingMeter.new()
		JailCampingMeter.newJail(state, "B")
		local j = state.jails["B"]
		assert(j ~= nil and j.cellId == "B" and j.isFull == false and j.defenderUserId == nil)
	end,
	["meter reaches 1.0 at fill time"] = function()
		local state = JailCampingMeter.new()
		JailCampingMeter.newJail(state, "A")
		JailCampingMeter.update(state, 1, "A", 0)
		JailCampingMeter.update(state, 1, "A", JailCampingMeterConfig.GracePeriod + JailCampingMeterConfig.FillTime)
		assert(approx(JailCampingMeter.getMeter(state, "A", JailCampingMeterConfig.GracePeriod + JailCampingMeterConfig.FillTime), 1.0))
	end,
	["half meter at grace plus half fill"] = function()
		local state = JailCampingMeter.new()
		JailCampingMeter.newJail(state, "A")
		JailCampingMeter.update(state, 1, "A", 0)
		JailCampingMeter.update(state, 1, "A", JailCampingMeterConfig.GracePeriod + JailCampingMeterConfig.FillTime / 2)
		assert(approx(JailCampingMeter.getMeter(state, "A", JailCampingMeterConfig.GracePeriod + JailCampingMeterConfig.FillTime / 2), 0.5))
	end,
	["refill after leave restarts grace"] = function()
		local state = JailCampingMeter.new()
		JailCampingMeter.newJail(state, "A")
		JailCampingMeter.update(state, 1, "A", 0)
		JailCampingMeter.update(state, nil, "A", 16)
		JailCampingMeter.update(state, 1, "A", 16)
		JailCampingMeter.update(state, 1, "A", 46)
		assert(JailCampingMeter.isFull(state, "A", 46))
	end,
	["fillTime parameter matches config"] = function()
		assert(JailCampingMeterConfig.FillTime == 20)
		assert(JailCampingMeterConfig.GracePeriod == 10)
		assert(JailCampingMeterConfig.BuffSeconds == 3)
		assert(JailCampingMeterConfig.ProximityRadius == 6)
	end,
}
