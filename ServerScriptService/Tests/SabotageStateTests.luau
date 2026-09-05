local ServerScriptService = game:GetService("ServerScriptService")
local SabotageState = require(ServerScriptService.SabotageSystem.SabotageState)

local function approx(a, b, eps)
	return math.abs(a - b) <= (eps or 0.01)
end

return {
	["range zero distance"] = function()
		assert(SabotageState.validateRange(Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), 5) == true)
	end,
	["range exactly at boundary"] = function()
		assert(SabotageState.validateRange(Vector3.new(0, 0, 0), Vector3.new(3, 0, 0), 3) == true)
	end,
	["range just outside"] = function()
		assert(SabotageState.validateRange(Vector3.new(0, 0, 0), Vector3.new(3.1, 0, 0), 3) == false)
	end,
	["range diagonal within"] = function()
		assert(SabotageState.validateRange(Vector3.new(0, 0, 0), Vector3.new(2, 2, 0), 3) == true)
	end,
	["range diagonal outside"] = function()
		assert(SabotageState.validateRange(Vector3.new(0, 0, 0), Vector3.new(3, 3, 0), 3) == false)
	end,
	["range nil player pos"] = function()
		assert(SabotageState.validateRange(nil, Vector3.new(0, 0, 0), 5) == false)
	end,
	["range nil target pos"] = function()
		assert(SabotageState.validateRange(Vector3.new(0, 0, 0), nil, 5) == false)
	end,
	["cooldown no previous use"] = function()
		local s = SabotageState.new()
		assert(SabotageState.validateCooldown(s, 100) == true)
	end,
	["cooldown just recorded"] = function()
		local s = SabotageState.new()
		SabotageState.recordCooldown(s, 100, 20)
		assert(SabotageState.validateCooldown(s, 100) == false)
	end,
	["cooldown not yet expired"] = function()
		local s = SabotageState.new()
		SabotageState.recordCooldown(s, 100, 20)
		assert(SabotageState.validateCooldown(s, 119) == false)
	end,
	["cooldown exactly expired"] = function()
		local s = SabotageState.new()
		SabotageState.recordCooldown(s, 100, 20)
		assert(SabotageState.validateCooldown(s, 120) == true)
	end,
	["cooldown long after expired"] = function()
		local s = SabotageState.new()
		SabotageState.recordCooldown(s, 100, 20)
		assert(SabotageState.validateCooldown(s, 200) == true)
	end,
	["remaining no cooldown"] = function()
		local s = SabotageState.new()
		assert(approx(SabotageState.remainingCooldown(s, 100), 0))
	end,
	["remaining full"] = function()
		local s = SabotageState.new()
		SabotageState.recordCooldown(s, 100, 20)
		assert(approx(SabotageState.remainingCooldown(s, 100), 20))
	end,
	["remaining half"] = function()
		local s = SabotageState.new()
		SabotageState.recordCooldown(s, 100, 20)
		assert(approx(SabotageState.remainingCooldown(s, 110), 10))
	end,
	["remaining expired"] = function()
		local s = SabotageState.new()
		SabotageState.recordCooldown(s, 100, 20)
		assert(approx(SabotageState.remainingCooldown(s, 120), 0))
	end,
	["remaining long expired"] = function()
		local s = SabotageState.new()
		SabotageState.recordCooldown(s, 100, 20)
		assert(approx(SabotageState.remainingCooldown(s, 200), 0))
	end,
	["context near jail A"] = function()
		local jails = { { id = "A", position = Vector3.new(10, 0, 0) } }
		local sites = { { id = "A", position = Vector3.new(0, 0, 10) } }
		local ctx = SabotageState.determineContext(Vector3.new(10, 0, 0), jails, sites, 3)
		assert(ctx ~= nil and ctx.kind == "jail" and ctx.id == "A")
	end,
	["context near jail B"] = function()
		local jails = { { id = "B", position = Vector3.new(-10, 0, 0) } }
		local sites = { { id = "A", position = Vector3.new(0, 0, 10) } }
		local ctx = SabotageState.determineContext(Vector3.new(-10, 0, 0), jails, sites, 3)
		assert(ctx ~= nil and ctx.kind == "jail" and ctx.id == "B")
	end,
	["context near site A"] = function()
		local jails = { { id = "A", position = Vector3.new(10, 0, 0) } }
		local sites = { { id = "A", position = Vector3.new(0, 0, 10) } }
		local ctx = SabotageState.determineContext(Vector3.new(0, 0, 10), jails, sites, 3)
		assert(ctx ~= nil and ctx.kind == "site" and ctx.id == "A")
	end,
	["context near site B"] = function()
		local jails = { { id = "A", position = Vector3.new(10, 0, 0) } }
		local sites = { { id = "B", position = Vector3.new(0, 0, -10) } }
		local ctx = SabotageState.determineContext(Vector3.new(0, 0, -10), jails, sites, 3)
		assert(ctx ~= nil and ctx.kind == "site" and ctx.id == "B")
	end,
	["context far from everything"] = function()
		local jails = { { id = "A", position = Vector3.new(10, 0, 0) } }
		local sites = { { id = "A", position = Vector3.new(0, 0, 10) } }
		local ctx = SabotageState.determineContext(Vector3.new(0, 0, 0), jails, sites, 3)
		assert(ctx == nil)
	end,
	["context nil position"] = function()
		local jails = { { id = "A", position = Vector3.new(10, 0, 0) } }
		local sites = { { id = "A", position = Vector3.new(0, 0, 10) } }
		local ctx = SabotageState.determineContext(nil, jails, sites, 3)
		assert(ctx == nil)
	end,
	["reset round clears cooldown"] = function()
		local s = SabotageState.new()
		SabotageState.recordCooldown(s, 100, 20)
		assert(SabotageState.validateCooldown(s, 100) == false)
		SabotageState.resetRound(s)
		assert(SabotageState.validateCooldown(s, 100) == true)
	end,
	["context priority jail over site"] = function()
		local jails = { { id = "A", position = Vector3.new(5, 0, 0) } }
		local sites = { { id = "A", position = Vector3.new(5.5, 0, 0) } }
		local ctx = SabotageState.determineContext(Vector3.new(5, 0, 0), jails, sites, 3)
		assert(ctx ~= nil and ctx.kind == "jail")
	end,
}
