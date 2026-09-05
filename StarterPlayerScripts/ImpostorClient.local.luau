local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local hud = playerGui:WaitForChild("BOPLUX_HUD", 15)
local bottomNotify = hud and hud:FindFirstChild("BottomNotify")
local warningBanner = bottomNotify and bottomNotify:FindFirstChild("WarningBanner")
local warningText = warningBanner and warningBanner:FindFirstChild("Text")
local revealBanner = bottomNotify and bottomNotify:FindFirstChild("RevealBanner")
local revealText = revealBanner and revealBanner:FindFirstChild("Text")

local function showWarning(text, duration)
	if not warningText or not warningBanner then return end
	warningText.Text = text
	warningBanner.Visible = true
	if revealBanner then revealBanner.Visible = false end
	task.delay(duration or 6, function()
		if warningText and warningText.Text == text then warningBanner.Visible = false end
	end)
end

local function showReveal(text, duration)
	if not revealText or not revealBanner then return end
	revealText.Text = text
	revealBanner.Visible = true
	if warningBanner then warningBanner.Visible = false end
	task.delay(duration or 5, function()
		if revealText and revealText.Text == text then revealBanner.Visible = false end
	end)
end

local matchSystems = ReplicatedStorage:WaitForChild("MatchSystems", 30)
if matchSystems then
	local warning = matchSystems:WaitForChild("ImpostorWarning", 10)
	if warning then
		warning.OnClientEvent:Connect(function(payload)
			if payload and payload.text then
				showWarning("[Warning] " .. payload.text)
			end
		end)
	end

	local role = matchSystems:WaitForChild("ImpostorRole", 10)
	if role then
		role.OnClientEvent:Connect(function(payload)
			if payload and payload.objective then
				showWarning("[Secret Objective] " .. tostring(payload.objective.text), 8)
			end
		end)
	end

	local reveal = matchSystems:WaitForChild("ImpostorReveal", 10)
	if reveal then
		reveal.OnClientEvent:Connect(function(payload)
			if not payload then return end
			if not payload.userId then
				showReveal("[Round Over] No Impostor was active this round.", 5)
			else
				local outcome = payload.impostorWon and " - the Impostor won!" or " - the Impostor lost."
				showReveal("[Round Over] " .. tostring(payload.displayName) .. " was the Impostor" .. outcome, 5)
			end
		end)
	end
end
