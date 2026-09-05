local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local matchSystems = ReplicatedStorage:WaitForChild("MatchSystems")
local matchStateSync = matchSystems:WaitForChild("MatchStateSync")
local playerStateSync = matchSystems:WaitForChild("PlayerStateSync")

local function waitForChild(parent, name, timeout)
	local child = parent:FindFirstChild(name)
	if child then return child end
	local start = os.clock()
	while not child and (os.clock() - start) < (timeout or 10) do
		child = parent:FindFirstChild(name)
		if child then return child end
		task.wait(0.1)
	end
	return parent:FindFirstChild(name)
end

local hud = waitForChild(PlayerGui, "BOPLUX_HUD", 15)
if not hud then
	warn("[BOPLUX_HUD] ScreenGui not found in PlayerGui")
	return
end

local topBar = waitForChild(hud, "TopBar")
local bottomNotify = waitForChild(hud, "BottomNotify")
local leftSide = waitForChild(hud, "LeftSide")
local rightSide = waitForChild(hud, "RightSide")

if not topBar then
	warn("[BOPLUX_HUD] Missing TopBar")
	return
end

local teamBadge = waitForChild(topBar, "TeamBadge")
local scoreLabel = waitForChild(topBar, "Score")
local phaseLabel = waitForChild(topBar, "Phase")
local roundLabel = waitForChild(topBar, "Round")
local timerLabel = waitForChild(topBar, "Timer")
local staminaBar = waitForChild(topBar, "StaminaBar")
local staminaFill = staminaBar and waitForChild(staminaBar, "Fill")
local speedBuff = waitForChild(topBar, "SpeedBuff")
local immunityLabel = waitForChild(topBar, "Immunity")
local warningBanner = bottomNotify and waitForChild(bottomNotify, "WarningBanner")
local warningText = warningBanner and waitForChild(warningBanner, "Text")
local revealBanner = bottomNotify and waitForChild(bottomNotify, "RevealBanner")
local revealText = revealBanner and waitForChild(revealBanner, "Text")
local jailPanel = leftSide and waitForChild(leftSide, "JailPanel")
local objPanel = rightSide and waitForChild(rightSide, "ObjectivePanel")

local function formatTime(seconds)
	local s = math.ceil(math.max(0, seconds))
	local m = math.floor(s / 60)
	s = s % 60
	return string.format("%d:%02d", m, s)
end

local function phaseDisplayName(phase)
	if phase == "PreRound" then return "PREPARATION"
	elseif phase == "Live" then return "LIVE"
	elseif phase == "RoundEnd" then return "ROUND OVER"
	elseif phase == "Halftime" then return "HALFTIME"
	elseif phase == "MatchEnd" then return "MATCH OVER"
	elseif phase == "Idle" then return "WAITING"
	end
	return phase or ""
end

local function updateMatchHUD(data)
	if phaseLabel then phaseLabel.Text = phaseDisplayName(data.phase) end
	if roundLabel then roundLabel.Text = data.round and ("Round " .. data.round) or "" end
	if timerLabel then timerLabel.Text = data.timeRemaining and formatTime(data.timeRemaining) or "" end
	if scoreLabel and data.score then
		scoreLabel.Text = (data.score.Attackers or 0) .. " - " .. (data.score.Defenders or 0)
	end
	if teamBadge and data.playerTeam then
		teamBadge.Text = string.upper(data.playerTeam)
		teamBadge.TextColor3 = data.playerTeam == "Attackers" and Color3.fromRGB(220, 80, 80) or Color3.fromRGB(80, 160, 220)
	end
end

local function updatePlayerHUD(data)
	if staminaFill then
		local pct = math.clamp(data.stamina / 6, 0, 1)
		staminaFill.Size = UDim2.new(pct, 0, 1, 0)
		staminaFill.BackgroundColor3 = pct < 0.25 and Color3.fromRGB(220, 60, 60) or (pct < 0.5 and Color3.fromRGB(220, 180, 60) or Color3.fromRGB(80, 200, 120))
	end
	if speedBuff then speedBuff.Visible = data.hasSpeedBuff end
	if immunityLabel then immunityLabel.Visible = data.hasCaptureImmunity end
end

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

local function updateJailStatus()
	if not jailPanel then return end
	local jailsFolder = Workspace:FindFirstChild("Jails")
	if not jailsFolder then jailPanel.Visible = false; return end
	local cellA = jailsFolder:FindFirstChild("Cell_A")
	local cellB = jailsFolder:FindFirstChild("Cell_B")
	local hasData = false
	if cellA then
		local intA = cellA:FindFirstChild("Interior")
		if intA then
			local countA = intA:GetAttribute("JailOccupantCount") or 0
			local channelA = intA:GetAttribute("ChannelKind")
			local fillA = intA:GetAttribute("CampingMeterFill") or 0
			local s = countA > 0 and (countA .. " jailed") or "Empty"
			if channelA then s = s .. " (" .. channelA .. ")" end
			local lbl = jailPanel:FindFirstChild("CellA")
			if lbl then lbl.Text = "Cell A: " .. s end
			local bar = jailPanel:FindFirstChild("CampingA")
			if bar then local f = bar:FindFirstChild("Fill"); if f then f.Size = UDim2.new(math.clamp(fillA,0,1),0,1,0) end end
			hasData = true
		end
	end
	if cellB then
		local intB = cellB:FindFirstChild("Interior")
		if intB then
			local countB = intB:GetAttribute("JailOccupantCount") or 0
			local channelB = intB:GetAttribute("ChannelKind")
			local fillB = intB:GetAttribute("CampingMeterFill") or 0
			local s = countB > 0 and (countB .. " jailed") or "Empty"
			if channelB then s = s .. " (" .. channelB .. ")" end
			local lbl = jailPanel:FindFirstChild("CellB")
			if lbl then lbl.Text = "Cell B: " .. s end
			local bar = jailPanel:FindFirstChild("CampingB")
			if bar then local f = bar:FindFirstChild("Fill"); if f then f.Size = UDim2.new(math.clamp(fillB,0,1),0,1,0) end end
			hasData = true
		end
	end
	jailPanel.Visible = hasData
end

local function updateObjectiveStatus()
	if not objPanel then return end
	local sitesFolder = Workspace:FindFirstChild("Sites")
	if not sitesFolder then objPanel.Visible = false; return end
	local siteA = sitesFolder:FindFirstChild("Site_A")
	local siteB = sitesFolder:FindFirstChild("Site_B")
	local hasData = false
	if siteA then
		local intA = siteA:FindFirstChild("Interior")
		if intA then
			local planted = intA:GetAttribute("Planted")
			local channel = intA:GetAttribute("ChannelKind")
			local det = intA:GetAttribute("DetonationRemaining")
			local s = planted and ("PLANTED " .. (det and formatTime(det) or "")) or "Clear"
			if channel then s = s .. " (" .. channel .. ")" end
			local lbl = objPanel:FindFirstChild("SiteA")
			if lbl then lbl.Text = "Site A: " .. s; lbl.TextColor3 = planted and Color3.fromRGB(255,80,80) or Color3.fromRGB(180,180,180) end
			hasData = true
		end
	end
	if siteB then
		local intB = siteB:FindFirstChild("Interior")
		if intB then
			local planted = intB:GetAttribute("Planted")
			local channel = intB:GetAttribute("ChannelKind")
			local det = intB:GetAttribute("DetonationRemaining")
			local s = planted and ("PLANTED " .. (det and formatTime(det) or "")) or "Clear"
			if channel then s = s .. " (" .. channel .. ")" end
			local lbl = objPanel:FindFirstChild("SiteB")
			if lbl then lbl.Text = "Site B: " .. s; lbl.TextColor3 = planted and Color3.fromRGB(255,80,80) or Color3.fromRGB(180,180,180) end
			hasData = true
		end
	end
	objPanel.Visible = hasData
end

matchStateSync.OnClientEvent:Connect(function(data)
	updateMatchHUD(data)
end)

playerStateSync.OnClientEvent:Connect(function(data)
	updatePlayerHUD(data)
end)

task.defer(function()
	updateJailStatus()
	updateObjectiveStatus()
end)

RunService.Heartbeat:Connect(function()
	updateJailStatus()
	updateObjectiveStatus()
end)

print("[BOPLUX_HUD] Client controller running")
