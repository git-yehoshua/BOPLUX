local ImpostorState = require(script.Parent.Parent.ImpostorSystem.ImpostorState)

local function makeRows(count)
	local rows = {}
	for i = 1, count do
		table.insert(rows, {
			userId = i,
			displayName = "P" .. i,
			team = i % 2 == 1 and "Attackers" or "Defenders",
		})
	end
	return rows
end

return {
	["full-chance roll selects exactly one impostor"] = function()
		local store = ImpostorState.new()
		local rows = makeRows(10)
		local selected = ImpostorState.select(store, rows, 1, function()
			return 1
		end)
		assert(selected ~= nil)
		assert(store.current ~= nil)
		assert(selected == store.current)
	end,
	["below-chance roll selects no impostor"] = function()
		local store = ImpostorState.new()
		local selected = ImpostorState.select(store, makeRows(10), 0.3, function()
			return 1
		end)
		assert(selected == nil)
		assert(store.current == nil)
	end,
	["selection picks one of the present players"] = function()
		local store = ImpostorState.new()
		local rows = makeRows(3)
		local selected = ImpostorState.select(store, rows, 1, function()
			return 1
		end)
		local found = false
		for _, row in ipairs(rows) do
			if row.userId == selected.userId then
				found = true
			end
		end
		assert(found)
	end,
	["selection records the round team"] = function()
		local store = ImpostorState.new()
		local rows = makeRows(4)
		local selected = ImpostorState.select(store, rows, 1, function()
			return 1
		end)
		assert(selected.team == rows[1].team)
	end,
	["empty roster never selects"] = function()
		local store = ImpostorState.new()
		assert(ImpostorState.select(store, {}, 1, function()
			return 1
		end) == nil)
		assert(store.current == nil)
	end,
	["breakout objective targets a jail"] = function()
		local objective = ImpostorState.buildObjective("breakout", "A")
		assert(objective.kind == "breakout")
		assert(objective.target == "A")
		assert(string.find(objective.text, "Jail A", 1, true) ~= nil)
	end,
	["plant objective targets a site"] = function()
		local objective = ImpostorState.buildObjective("plant", "1")
		assert(objective.kind == "plant")
		assert(objective.target == "1")
		assert(string.find(objective.text, "Plant Site 1", 1, true) ~= nil)
	end,
	["objective attaches to the selected impostor"] = function()
		local store = ImpostorState.new()
		ImpostorState.select(store, makeRows(1), 1, function()
			return 1
		end)
		local current = ImpostorState.attachObjective(store, ImpostorState.buildObjective("plant", "1"))
		assert(current.objective.kind == "plant")
		assert(store.current.objective.target == "1")
	end,
	["warning carries no identity from any roster"] = function()
		local message = ImpostorState.WARNING_MESSAGE
		assert(message ~= "")
		for i = 1, 10 do
			assert(string.find(message, "P" .. i, 1, true) == nil)
		end
	end,
	["impostor wins when their team loses the round"] = function()
		local store = ImpostorState.new()
		local rows = makeRows(2)
		ImpostorState.select(store, rows, 1, function()
			return 1
		end)
		local impostorTeam = rows[1].team
		local otherTeam = impostorTeam == "Attackers" and "Defenders" or "Attackers"
		assert(ImpostorState.winsFor(store, otherTeam) == true)
	end,
	["impostor does not win when their team wins the round"] = function()
		local store = ImpostorState.new()
		local rows = makeRows(2)
		ImpostorState.select(store, rows, 1, function()
			return 1
		end)
		assert(ImpostorState.winsFor(store, rows[1].team) == false)
	end,
	["no win evaluation without an impostor"] = function()
		local store = ImpostorState.new()
		assert(ImpostorState.winsFor(store, "Attackers") == nil)
	end,
	["reveal reports the identity once and clears the store"] = function()
		local store = ImpostorState.new()
		local rows = makeRows(2)
		ImpostorState.select(store, rows, 1, function()
			return 1
		end)
		local reveal = ImpostorState.reveal(store, 6, "Attackers")
		assert(reveal.userId == rows[1].userId)
		assert(reveal.displayName == rows[1].displayName)
		assert(reveal.round == 6)
		assert(store.current == nil)
		local again = ImpostorState.reveal(store, 6, "Attackers")
		assert(again.userId == nil)
		assert(again.impostorWon == nil)
	end,
	["reveal reports no impostor when none was selected"] = function()
		local store = ImpostorState.new()
		local reveal = ImpostorState.reveal(store, 1, "Defenders")
		assert(reveal.userId == nil)
		assert(reveal.displayName == nil)
		assert(reveal.impostorWon == nil)
	end,
	["reveal resolves the win condition from the stored team"] = function()
		local store = ImpostorState.new()
		local rows = makeRows(2)
		ImpostorState.select(store, rows, 1, function()
			return 1
		end)
		local impostorTeam = rows[1].team
		local otherTeam = impostorTeam == "Attackers" and "Defenders" or "Attackers"
		local reveal = ImpostorState.reveal(store, 3, otherTeam)
		assert(reveal.impostorWon == true)
	end,
	["disconnected impostor still reveals from stored identity"] = function()
		local store = ImpostorState.new()
		local rows = makeRows(2)
		ImpostorState.select(store, rows, 1, function()
			return 1
		end)
		local reveal = ImpostorState.reveal(store, 3, rows[2].team)
		assert(reveal.displayName == rows[1].displayName)
	end,
}
