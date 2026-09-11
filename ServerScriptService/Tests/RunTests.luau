local TestFramework = require(script.Parent.TestFramework)
local MatchStateTests = require(script.Parent.MatchStateTests)
local JailStateTests = require(script.Parent.JailStateTests)
local ImpostorStateTests = require(script.Parent.ImpostorStateTests)
local SabotageStateTests = require(script.Parent.SabotageStateTests)
local JailCampingMeterTests = require(script.Parent.JailCampingMeterTests)
local EnvironmentStateTests = require(script.Parent.EnvironmentStateTests)
local PlayerStateTests = require(script.Parent.PlayerStateTests)

local function run()
	return TestFramework.run({
		MatchStateTests,
		JailStateTests,
		ImpostorStateTests,
		SabotageStateTests,
		JailCampingMeterTests,
		EnvironmentStateTests,
		PlayerStateTests,
	})
end

return run