local TestFramework = {}

local function runModule(module)
	local results = { passed = {}, failed = {} }
	for name, fn in pairs(module) do
		if type(fn) == "function" then
			local ok, err = pcall(fn)
			if ok then
				table.insert(results.passed, name)
			else
				table.insert(results.failed, { name = name, error = tostring(err) })
			end
		end
	end
	return results
end

function TestFramework.run(modules)
	local all = { passed = {}, failed = {} }
	for _, module in ipairs(modules) do
		local results = runModule(module)
		for _, name in ipairs(results.passed) do
			table.insert(all.passed, name)
		end
		for _, failure in ipairs(results.failed) do
			table.insert(all.failed, failure)
		end
	end
	return {
		total = #all.passed + #all.failed,
		passed = all.passed,
		failed = all.failed,
		failureCount = #all.failed,
	}
end

return TestFramework