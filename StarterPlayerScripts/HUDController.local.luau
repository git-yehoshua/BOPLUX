local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local matchSystems = ReplicatedStorage:WaitForChild("MatchSystems")
local matchStateSync = matchSystems:WaitForChild("MatchStateSync")
local playerStateSync = matchSystems:WaitForChild("PlayerStateSync")
local environmentSync = matchSystems:WaitForChild("EnvironmentSync", 10)
local StaminaConstants = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("StaminaConstants"))

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
local minimap = waitForChild(hud, "Minimap", 8)

if not topBar then
	warn("[BOPLUX_HUD] Missing TopBar")
	return
end

local teamBadge = waitForChild(topBar, "TeamBadge")
local scoreLabel = waitForChild(topBar, "Score")
local phaseLabel = waitForChild(topBar, "Phase")
local roundLabel = waitForChild(topBar, "Round")
local timerLabel = waitForChild(topBar, "Timer")
local speedBuff = waitForChild(topBar, "SpeedBuff")
local immunityLabel = waitForChild(topBar, "Immunity")
local modeLabel = waitForChild(topBar, "ModeLabel", 5)
local warningBanner = bottomNotify and waitForChild(bottomNotify, "WarningBanner")
local warningText = warningBanner and waitForChild(warningBanner, "Text")
local revealBanner = bottomNotify and waitForChild(bottomNotify, "RevealBanner")
local revealText = revealBanner and waitForChild(revealBanner, "Text")
local staminaPipsRow = waitForChild(hud, "StaminaPips", 8)
local batteryPipsRow = waitForChild(hud, "BatteryPips", 8)
local healthBar = waitForChild(hud, "HealthBar", 8)
local healthFill = healthBar and waitForChild(healthBar, "Fill")
local healthNumber = waitForChild(hud, "HealthNumber", 8)
local crosshair = waitForChild(hud, "Crosshair", 8)
local markerJailA = minimap and waitForChild(minimap, "MarkerJailA", 5)
local markerJailB = minimap and waitForChild(minimap, "MarkerJailB", 5)
local markerSiteA = minimap and waitForChild(minimap, "MarkerSiteA", 5)
local markerSiteB = minimap and waitForChild(minimap, "MarkerSiteB", 5)
local playerMarker = minimap and waitForChild(minimap, "PlayerMarker", 5)

-- Crosshair state + hint (driven per-tick from proximity; colors follow the
-- project status semantics: red = target, amber = jail, blue = site).
local crosshairRing = crosshair and waitForChild(crosshair, "Ring", 5)
local crosshairStroke = crosshairRing and waitForChild(crosshairRing, "Stroke", 5)
local crosshairDot = crosshair and waitForChild(crosshair, "Dot", 5)
local hintLabel = crosshair and waitForChild(crosshair, "HintLabel", 5)
local localPlayerTeam = nil
local localIsJailed = false
local detonationActive = false
local detonationRemaining = 0
local lastCrossState = nil
local lastHint = nil
local plantWarned = {}
local flashUntil = 0
local flashState = nil
local flashCrosshair -- forward: defined with setCrosshair below, called by the status updaters above
local prevOcc = { A = 0, B = 0 }
local prevPlantChannel = { A = false, B = false }

local function formatTime(seconds)
	local s = math.ceil(math.max(0, seconds))
	local m = math.floor(s / 60)
	s = s % 60
	return string.format("%d:%02d", m, s)
end

-- Diamond status glyphs (rebuilt fresh; no prior diamond implementation exists in git history).
-- Colors follow the project status semantics: green = clear, red = active/planted/detonating, amber = channel in progress.
local STATUS_COLORS = {
	clear = Color3.fromRGB(80, 200, 120),
	active = Color3.fromRGB(235, 70, 70),
	channel = Color3.fromRGB(255, 180, 60),
	unknown = Color3.fromRGB(160, 160, 170),
}

local function statusColor(kind)
	return STATUS_COLORS[kind] or STATUS_COLORS.unknown
end

local function setKind(frame, kind)
	if frame then frame.BackgroundColor3 = statusColor(kind) end
end

-- Minimap: 2D projection of the 224x224 courtyard (world X/Z -> 112px map)
local MAP_HALF = 112
local MAP_PX = 112
local function worldToMap(x, z)
	return UDim2.fromOffset(MAP_PX / 2 + (x / MAP_HALF) * (MAP_PX / 2), MAP_PX / 2 + (z / MAP_HALF) * (MAP_PX / 2))
end

local function placeMarker(marker, worldPos)
	if marker and worldPos then
		marker.Position = worldToMap(worldPos.X, worldPos.Z)
		marker.Visible = true
	end
end

local function updatePlayerMarker()
	if not playerMarker then return end
	local character = LocalPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then playerMarker.Visible = false return end
	playerMarker.Visible = true
	playerMarker.Position = worldToMap(root.Position.X, root.Position.Z)
	local look = root.CFrame.LookVector
	playerMarker.Rotation = math.deg(math.atan2(look.X, -look.Z))
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
	localPlayerTeam = data.playerTeam
	if phaseLabel then phaseLabel.Text = phaseDisplayName(data.phase) end
	if roundLabel then roundLabel.Text = data.round and ("Round " .. data.round) or "" end
	-- While a spike is planted the detonation countdown owns the timer label.
	if timerLabel and data.timeRemaining and not detonationActive then timerLabel.Text = formatTime(data.timeRemaining) end
	if scoreLabel and data.score then
		scoreLabel.Text = (data.score.Attackers or 0) .. " - " .. (data.score.Defenders or 0)
	end
	if teamBadge then
		if data.playerTeam then
			teamBadge.Text = string.upper(data.playerTeam)
			teamBadge.TextColor3 = data.playerTeam == "Attackers" and Color3.fromRGB(220, 80, 80) or Color3.fromRGB(80, 160, 220)
		else
			-- No team this match (OQ-012 late join sits out) — show truth, not a stale default
			teamBadge.Text = "SPECTATING"
			teamBadge.TextColor3 = Color3.fromRGB(160, 160, 170)
		end
	end
end

local function updatePlayerHUD(data)
	-- Mirror server stamina (pushed on change by RunPlayerState.firePlayerSync) onto a client attribute;
	-- UI binds via GetAttributeChangedSignal("Stamina") — event-driven, no polling.
	LocalPlayer:SetAttribute("Stamina", data.stamina or 0)
	localIsJailed = data.isJailed == true
	if speedBuff then speedBuff.Visible = data.hasSpeedBuff end
	if immunityLabel then immunityLabel.Visible = data.hasCaptureImmunity end
end

local function updateStaminaPips(value)
	if not staminaPipsRow then return end
	local pct = math.clamp(value / StaminaConstants.MaxSprintSeconds, 0, 1)
	local lit = math.floor(pct * 12 + 0.5)
	for i = 1, 12 do
		local pip = staminaPipsRow:FindFirstChild("Pip" .. i)
		if pip then
			pip.BackgroundTransparency = i <= lit and 0.1 or 0.85
		end
	end
end

if staminaPipsRow then
	LocalPlayer:GetAttributeChangedSignal("Stamina"):Connect(function()
		updateStaminaPips(LocalPlayer:GetAttribute("Stamina") or 0)
	end)
end

-- Health display: continuous bar + overlaid number, event-driven via Humanoid.HealthChanged (no polling)
local function updateHealth(value)
	local maxHealth = 100
	local character = LocalPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then maxHealth = humanoid.MaxHealth end
	local pct = math.clamp(value / maxHealth, 0, 1)
	if healthNumber then healthNumber.Text = tostring(math.floor(value + 0.5)) end
	if healthFill then
		healthFill.Size = UDim2.new(pct, 0, 1, 0)
	end
end

local healthConn = nil
local function bindHealth(humanoid)
	if healthConn then healthConn:Disconnect(); healthConn = nil end
	if not humanoid then updateHealth(0); return end
	updateHealth(humanoid.Health)
	healthConn = humanoid.HealthChanged:Connect(function(value)
		updateHealth(value)
	end)
end

if (healthNumber or healthFill) and not healthConn then
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
	if humanoid then
		bindHealth(humanoid)
	end
	LocalPlayer.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid", 5)
		bindHealth(humanoid)
	end)
end

-- Crosshair: hide OS cursor and show a fixed center dot during gameplay; restore cursor when another ScreenGui (menu) is up
if crosshair then
	local function updateCrosshair()
		local gui = LocalPlayer.PlayerGui
		local inMenu = false
		for _, child in ipairs(gui:GetChildren()) do
			if child:IsA("ScreenGui") and child.Name ~= "BOPLUX_HUD" and child.Enabled and child.Name ~= "Freecam" then
				inMenu = true
				break
			end
		end
		crosshair.Visible = not inMenu
		UserInputService.MouseIconEnabled = inMenu
	end
	updateCrosshair()
	PlayerGui.ChildAdded:Connect(updateCrosshair)
	PlayerGui.ChildRemoved:Connect(updateCrosshair)
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

-- Jail camping pressure (REC-0013): the server writes CampingMeterFill (0..1) on each
-- jail Interior; the amber ring thickness on the minimap marker scales with it.
local function updateCampingRing(marker, interior)
	if not marker then return end
	local ring = marker:FindFirstChild("CampingRing")
	if not ring then return end
	local fill = interior and interior:GetAttribute("CampingMeterFill") or 0
	if fill > 0.02 then
		ring.Enabled = true
		ring.Thickness = 1 + fill * 3
	else
		ring.Enabled = false
	end
end

local function updateJailStatus()
	local jailsFolder = Workspace:FindFirstChild("Jails")
	if not jailsFolder then
		if markerJailA then markerJailA.Visible = false end
		if markerJailB then markerJailB.Visible = false end
		return
	end
	local cellA = jailsFolder:FindFirstChild("Cell_A")
	local cellB = jailsFolder:FindFirstChild("Cell_B")
	if cellA then
		local intA = cellA:FindFirstChild("Interior")
		if intA then
			local countA = intA:GetAttribute("JailOccupantCount") or 0
			if countA > (prevOcc.A or 0) then
				flashCrosshair("target")
			end
			prevOcc.A = countA
			placeMarker(markerJailA, intA.Position)
			setKind(markerJailA, countA > 0 and "active" or "clear")
			updateCampingRing(markerJailA, intA)
		end
	end
	if cellB then
		local intB = cellB:FindFirstChild("Interior")
		if intB then
			local countB = intB:GetAttribute("JailOccupantCount") or 0
			if countB > (prevOcc.B or 0) then
				flashCrosshair("target")
			end
			prevOcc.B = countB
			placeMarker(markerJailB, intB.Position)
			setKind(markerJailB, countB > 0 and "active" or "clear")
			updateCampingRing(markerJailB, intB)
		end
	end
end

local function updateObjectiveStatus()
	local sitesFolder = Workspace:FindFirstChild("Sites")
	if not sitesFolder then
		if markerSiteA then markerSiteA.Visible = false end
		if markerSiteB then markerSiteB.Visible = false end
		detonationActive = false
		return
	end
	local minDet = nil
	for _, siteId in ipairs({ "A", "B" }) do
		local site = sitesFolder:FindFirstChild("Site_" .. siteId)
		local marker = siteId == "A" and markerSiteA or markerSiteB
		if site then
			local int = site:FindFirstChild("Interior")
			if int then
				local planted = int:GetAttribute("Planted")
				local channel = int:GetAttribute("ChannelKind")
				local plantRunning = channel == "plant"
				if plantRunning and not prevPlantChannel[siteId] then
					flashCrosshair("site")
				end
				prevPlantChannel[siteId] = plantRunning
				placeMarker(marker, int.Position)
				setKind(marker, planted and "active" or (channel and "channel" or "clear"))
				if planted then
					local det = int:GetAttribute("DetonationRemaining") or 0
					if not minDet or det < minDet then minDet = det end
					if not plantWarned[siteId] then
						plantWarned[siteId] = true
						if localPlayerTeam == "Defenders" then
							showWarning("SPIKE PLANTED — defuse it (hold E)!", 6)
						else
							showWarning("SPIKE PLANTED — defend it!", 6)
						end
					end
				else
					plantWarned[siteId] = false
				end
			end
		end
	end
	if minDet then
		detonationActive = true
		detonationRemaining = minDet
	else
		detonationActive = false
	end
end

-- Proximity mirrors the server ranges (JailConfig / ObjectiveConfig) so the
-- crosshair and hint reflect what the server will actually accept.
local CAPTURE_RANGE = 1.5
local JAIL_RANGE = 4.5
local SITE_RANGE = 2.0

local function myRootPart()
	local character = LocalPlayer.Character
	return character and character:FindFirstChild("HumanoidRootPart")
end

local function nearestPlayerDist(root)
	local best = math.huge
	for _, other in ipairs(Players:GetPlayers()) do
		if other ~= LocalPlayer then
			local otherRoot = other.Character and other.Character:FindFirstChild("HumanoidRootPart")
			if otherRoot then
				local d = (otherRoot.Position - root.Position).Magnitude
				if d < best then best = d end
			end
		end
	end
	return best
end

local function nearestSite(root)
	local sitesFolder = Workspace:FindFirstChild("Sites")
	if not sitesFolder then return nil end
	-- XZ-only distance, mirroring RunObjectiveSystem's channel validation.
	local flatRoot = Vector3.new(root.Position.X, 0, root.Position.Z)
	local best, bestDist, bestPlanted = nil, math.huge, false
	for _, siteId in ipairs({ "A", "B" }) do
		local site = sitesFolder:FindFirstChild("Site_" .. siteId)
		local int = site and site:FindFirstChild("Interior")
		if int then
			local d = (Vector3.new(int.Position.X, 0, int.Position.Z) - flatRoot).Magnitude
			if d < bestDist then
				bestDist = d
				best = siteId
				bestPlanted = int:GetAttribute("Planted") == true
			end
		end
	end
	if best and bestDist <= SITE_RANGE then
		return best, bestPlanted
	end
	return nil
end

local function nearestJail(root)
	local jailsFolder = Workspace:FindFirstChild("Jails")
	if not jailsFolder then return nil end
	local best, bestDist = nil, math.huge
	for _, cellId in ipairs({ "A", "B" }) do
		local cell = jailsFolder:FindFirstChild("Cell_" .. cellId)
		local int = cell and cell:FindFirstChild("Interior")
		if int then
			local d = (int.Position - root.Position).Magnitude
			if d < bestDist then
				bestDist = d
				best = cellId
			end
		end
	end
	if best and bestDist <= JAIL_RANGE then
		return best
	end
	return nil
end

local CROSS_COLORS = {
	default = Color3.new(1, 1, 1),
	target = Color3.fromRGB(235, 70, 70),
	jail = Color3.fromRGB(255, 180, 60),
	site = Color3.fromRGB(80, 160, 220),
}

local function setCrosshair(state, hint, hintColor)
	-- Hit-flash overrides the proximity state briefly (capture landed red,
	-- plant channel started blue).
	local effective, effSize = state, ((state == "target") and 32 or 24)
	if flashUntil and os.clock() < flashUntil then
		effective = flashState or state
		effSize = 32
	end
	if effective ~= lastCrossState then
		lastCrossState = effective
		if crosshairRing then
			crosshairRing.Size = UDim2.new(0, effSize, 0, effSize)
		end
		if crosshairStroke then
			crosshairStroke.Color = CROSS_COLORS[effective] or CROSS_COLORS.default
		end
		if crosshairDot then
			crosshairDot.BackgroundColor3 = CROSS_COLORS[effective] or CROSS_COLORS.default
		end
	end
	if hint ~= lastHint then
		lastHint = hint
		if hintLabel then
			hintLabel.Text = hint or ""
			hintLabel.Visible = hint ~= nil and hint ~= ""
			if hintColor then hintLabel.TextColor3 = hintColor end
		end
	end
end

flashCrosshair = function(kind)
	flashState = kind
	flashUntil = os.clock() + 0.3
	lastCrossState = nil
end

local function updateCrosshairState()
	if not crosshair then return end
	local root = myRootPart()
	if not root then
		setCrosshair("default", nil)
		return
	end
	-- Priority: breakout (jailed) > defuse/plant (site) > rescue (jail) > capture (player).
	if localIsJailed then
		setCrosshair("jail", "HOLD F — Breakout", CROSS_COLORS.jail)
		return
	end
	local siteId, planted = nearestSite(root)
	if siteId then
		if planted then
			if localPlayerTeam == "Defenders" then
				setCrosshair("site", "HOLD E — Defuse", CROSS_COLORS.site)
			else
				setCrosshair("site", "Defend the spike", CROSS_COLORS.site)
			end
		else
			if localPlayerTeam == "Attackers" then
				setCrosshair("site", "HOLD LMB — Plant", CROSS_COLORS.site)
			elseif localPlayerTeam == nil then
				setCrosshair("site", "LMB Plant · E Defuse", CROSS_COLORS.site)
			else
				setCrosshair("site", nil)
			end
		end
		return
	end
	if nearestJail(root) then
		setCrosshair("jail", "E Rescue · RMB Reset", CROSS_COLORS.jail)
		return
	end
	if nearestPlayerDist(root) <= CAPTURE_RANGE then
		setCrosshair("target", "LMB — Capture", CROSS_COLORS.target)
		return
	end
	setCrosshair("default", nil)
end

local function updateDetonationTimer()
	if not timerLabel then return end
	if detonationActive then
		timerLabel.Text = formatTime(detonationRemaining)
		timerLabel.TextColor3 = Color3.fromRGB(235, 70, 70)
		-- Urgency blink under 10 seconds.
		timerLabel.Visible = detonationRemaining >= 10 or (os.clock() % 0.6) < 0.4
	else
		if timerLabel.TextColor3 ~= Color3.new(1, 1, 1) then
			timerLabel.TextColor3 = Color3.new(1, 1, 1)
		end
		if not timerLabel.Visible then
			timerLabel.Visible = true
		end
	end
end

matchStateSync.OnClientEvent:Connect(function(data)
	updateMatchHUD(data)
end)

playerStateSync.OnClientEvent:Connect(function(data)
	updatePlayerHUD(data)
end)

-- Day/Night + flashlight (EnvironmentSystem): mode badge in the TopBar, battery
-- pips visible only at night. State also mirrors onto LocalPlayer attributes
-- (MatchMode / FlashlightOn / Battery) for any future client consumer.
local function updateBatteryPips(value)
	if not batteryPipsRow then return end
	local pct = math.clamp(value / 100, 0, 1)
	local lit = math.floor(pct * 10 + 0.5)
	for i = 1, 10 do
		local pip = batteryPipsRow:FindFirstChild("BPip" .. i)
		if pip then
			pip.BackgroundTransparency = i <= lit and 0.1 or 0.85
		end
	end
end

if environmentSync then
	environmentSync.OnClientEvent:Connect(function(data)
		LocalPlayer:SetAttribute("MatchMode", data.mode)
		LocalPlayer:SetAttribute("FlashlightOn", data.flashlightOn)
		LocalPlayer:SetAttribute("Battery", data.battery or 0)
		if modeLabel then
			if data.mode == "Night" then
				modeLabel.Text = "NIGHT"
				modeLabel.TextColor3 = Color3.fromRGB(150, 170, 255)
				modeLabel.Visible = true
				if batteryPipsRow then batteryPipsRow.Visible = true end
				updateBatteryPips(data.battery or 0)
			elseif data.mode == "Day" then
				modeLabel.Text = "DAY"
				modeLabel.TextColor3 = Color3.fromRGB(220, 200, 120)
				modeLabel.Visible = true
				if batteryPipsRow then batteryPipsRow.Visible = false end
			end
		end
	end)
end

task.defer(function()
	updateJailStatus()
	updateObjectiveStatus()
end)

RunService.Heartbeat:Connect(function()
	updateJailStatus()
	updateObjectiveStatus()
	updatePlayerMarker()
	updateCrosshairState()
	updateDetonationTimer()
end)

print("[BOPLUX_HUD] Client controller running")
