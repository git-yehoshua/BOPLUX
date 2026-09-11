local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local existingGui = PlayerGui:FindFirstChild("BOPLUX_HUD")
if existingGui then existingGui:Destroy() end

local font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
local fontHeavy = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
local darkBg = Color3.fromRGB(15, 15, 25)
local panelBg = Color3.fromRGB(15, 15, 25)
local dimText = Color3.fromRGB(160, 160, 170)
local lightText = Color3.fromRGB(200, 200, 220)
local white = Color3.new(1, 1, 1)
local accentRed = Color3.fromRGB(220, 80, 80)
local accentBlue = Color3.fromRGB(80, 160, 220)
local timerYellow = Color3.fromRGB(255, 220, 100)
local fillGreen = Color3.fromRGB(80, 200, 120)
local barBg = Color3.fromRGB(30, 30, 40)
local warnRed = Color3.fromRGB(160, 35, 35)
local revealPurple = Color3.fromRGB(90, 35, 150)
local campingOrange = Color3.fromRGB(255, 140, 50)
local spdBlue = Color3.fromRGB(100, 200, 255)
local immYellow = Color3.fromRGB(255, 200, 80)

-- Kit icons (SunGraphica "FREE Sci-Fi UI", CC BY 4.0) — hidden pending owner review; panels use flat translucent style with single-edge accent frames per owner spec
local KIT_LOCK = "rbxassetid://79475174670694"
local KIT_TARGET = "rbxassetid://93442781397229"

local function applyPanelChrome(panel, iconAsset, iconW, iconH, accentSide, accentColor)
	local icon = Instance.new("ImageLabel")
	icon.Name = "HeaderIcon"
	icon.BackgroundTransparency = 1
	icon.Size = UDim2.new(0, iconW, 0, iconH)
	icon.Position = UDim2.new(0, 5, 0, 2)
	icon.Image = iconAsset
	icon.ImageColor3 = lightText
	icon.Visible = false
	icon.Parent = panel
	local t = panel:FindFirstChild("Title")
	if t then
		t.Size = UDim2.new(1, -12, 0, 14)
		t.Position = UDim2.new(0, 6, 0, 2)
	end
	local line = Instance.new("Frame")
	line.Name = "AccentLine"
	line.AnchorPoint = Vector2.new(0, 0)
	line.Size = UDim2.new(0, 2, 1, 0)
	line.Position = accentSide == "left" and UDim2.new(0, 0, 0, 0) or UDim2.new(1, -2, 0, 0)
	line.BackgroundColor3 = accentColor
	line.BorderSizePixel = 0
	line.Parent = panel
end

local hud = Instance.new("ScreenGui")
hud.Name = "BOPLUX_HUD"
hud.ResetOnSpawn = false
hud.DisplayOrder = 10
hud.IgnoreGuiInset = false
hud.Enabled = true
hud.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
hud.Parent = PlayerGui

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 36)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = darkBg
topBar.BackgroundTransparency = 0.4
topBar.BorderSizePixel = 0
topBar.Parent = hud
-- No rounded corners: a full-bleed bar with UICorner reads as a floating slab

local teamBadge = Instance.new("TextLabel")
teamBadge.Name = "TeamBadge"
teamBadge.Size = UDim2.new(0, 80, 0, 18)
teamBadge.Position = UDim2.new(0, 12, 0, 2)
teamBadge.BackgroundTransparency = 1
teamBadge.FontFace = font
teamBadge.TextSize = 14
teamBadge.TextColor3 = accentRed
teamBadge.Text = "ATTACKERS"
teamBadge.TextStrokeTransparency = 0.5
teamBadge.TextStrokeColor3 = Color3.new(0, 0, 0)
teamBadge.TextXAlignment = Enum.TextXAlignment.Center
teamBadge.TextYAlignment = Enum.TextYAlignment.Center
teamBadge.Parent = topBar

local scoreLabel = Instance.new("TextLabel")
scoreLabel.Name = "Score"
scoreLabel.Size = UDim2.new(0, 80, 0, 16)
scoreLabel.Position = UDim2.new(0, 12, 0, 18)
scoreLabel.BackgroundTransparency = 1
scoreLabel.FontFace = font
scoreLabel.TextSize = 13
scoreLabel.TextColor3 = white
scoreLabel.Text = "0 - 0"
scoreLabel.TextStrokeTransparency = 0.5
scoreLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
scoreLabel.TextXAlignment = Enum.TextXAlignment.Center
scoreLabel.TextYAlignment = Enum.TextYAlignment.Center
scoreLabel.Parent = topBar

local phaseLabel = Instance.new("TextLabel")
phaseLabel.Name = "Phase"
phaseLabel.Size = UDim2.new(0, 120, 0, 18)
phaseLabel.Position = UDim2.new(0.5, -60, 0, 2)
phaseLabel.BackgroundTransparency = 1
phaseLabel.FontFace = fontHeavy
phaseLabel.TextSize = 16
phaseLabel.TextColor3 = white
phaseLabel.Text = "LIVE"
phaseLabel.TextStrokeTransparency = 0.3
phaseLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
phaseLabel.TextXAlignment = Enum.TextXAlignment.Center
phaseLabel.TextYAlignment = Enum.TextYAlignment.Center
phaseLabel.Parent = topBar

local roundLabel = Instance.new("TextLabel")
roundLabel.Name = "Round"
roundLabel.Size = UDim2.new(0, 80, 0, 12)
roundLabel.Position = UDim2.new(0.5, -40, 0, 18)
roundLabel.BackgroundTransparency = 1
roundLabel.FontFace = font
roundLabel.TextSize = 11
roundLabel.TextColor3 = lightText
roundLabel.Text = "Round 1"
roundLabel.TextStrokeTransparency = 0.5
roundLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
roundLabel.TextXAlignment = Enum.TextXAlignment.Center
roundLabel.TextYAlignment = Enum.TextYAlignment.Center
roundLabel.Parent = topBar

local timerLabel = Instance.new("TextLabel")
timerLabel.Name = "Timer"
timerLabel.Size = UDim2.new(0, 60, 0, 12)
timerLabel.Position = UDim2.new(0.5, 66, 0, 2)
timerLabel.BackgroundTransparency = 1
timerLabel.FontFace = font
timerLabel.TextSize = 12
timerLabel.TextColor3 = timerYellow
timerLabel.Text = "3:00"
timerLabel.TextStrokeTransparency = 0.5
timerLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
timerLabel.TextXAlignment = Enum.TextXAlignment.Center
timerLabel.TextYAlignment = Enum.TextYAlignment.Center
timerLabel.Parent = topBar

local speedBuff = Instance.new("TextLabel")
speedBuff.Name = "SpeedBuff"
speedBuff.Size = UDim2.new(0, 30, 0, 10)
speedBuff.Position = UDim2.new(1, -170, 0, 18)
speedBuff.BackgroundTransparency = 1
speedBuff.FontFace = font
speedBuff.TextSize = 9
speedBuff.TextColor3 = spdBlue
speedBuff.Text = "SPD"
speedBuff.TextStrokeTransparency = 1
speedBuff.TextXAlignment = Enum.TextXAlignment.Center
speedBuff.TextYAlignment = Enum.TextYAlignment.Center
speedBuff.Visible = false
speedBuff.Parent = topBar

local immunityLabel = Instance.new("TextLabel")
immunityLabel.Name = "Immunity"
immunityLabel.Size = UDim2.new(0, 30, 0, 10)
immunityLabel.Position = UDim2.new(1, -130, 0, 18)
immunityLabel.BackgroundTransparency = 1
immunityLabel.FontFace = font
immunityLabel.TextSize = 9
immunityLabel.TextColor3 = immYellow
immunityLabel.Text = "IMM"
immunityLabel.TextStrokeTransparency = 1
immunityLabel.TextXAlignment = Enum.TextXAlignment.Center
immunityLabel.TextYAlignment = Enum.TextYAlignment.Center
	immunityLabel.Visible = false
	immunityLabel.Parent = topBar

	-- Day/Night mode badge (top-right, above the status glyphs); text/color set by HUDController from EnvironmentSync
	local modeLabel = Instance.new("TextLabel")
	modeLabel.Name = "ModeLabel"
	modeLabel.Size = UDim2.new(0, 120, 0, 16)
	modeLabel.Position = UDim2.new(1, -140, 0, 2)
	modeLabel.BackgroundTransparency = 1
	modeLabel.FontFace = font
	modeLabel.TextSize = 13
	modeLabel.TextColor3 = lightText
	modeLabel.Text = ""
	modeLabel.Visible = false
	modeLabel.TextXAlignment = Enum.TextXAlignment.Right
	modeLabel.TextYAlignment = Enum.TextYAlignment.Center
	modeLabel.Parent = topBar

	local bottomNotify = Instance.new("Frame")
bottomNotify.Name = "BottomNotify"
bottomNotify.Size = UDim2.new(0.5, 0, 0, 44)
bottomNotify.AnchorPoint = Vector2.new(0.5, 0)
-- Below the round timer, above all gameplay content (owner-specified coordinates)
bottomNotify.Position = UDim2.new(0.5, 0, 0.16, 0)
bottomNotify.BackgroundTransparency = 1
bottomNotify.BorderSizePixel = 1
bottomNotify.BorderColor3 = darkBg
bottomNotify.Parent = hud

local warningBanner = Instance.new("Frame")
warningBanner.Name = "WarningBanner"
warningBanner.Size = UDim2.new(1, 0, 1, 0)
warningBanner.Position = UDim2.new(0, 0, 0, 0)
warningBanner.BackgroundColor3 = warnRed
warningBanner.BackgroundTransparency = 0.15
warningBanner.BorderSizePixel = 0
warningBanner.Visible = false
warningBanner.Parent = bottomNotify

local warningCorner = Instance.new("UICorner")
warningCorner.CornerRadius = UDim.new(0, 6)
warningCorner.Parent = warningBanner

local warningText = Instance.new("TextLabel")
warningText.Name = "Text"
warningText.Size = UDim2.new(1, -16, 1, 0)
warningText.Position = UDim2.new(0, 8, 0, 0)
warningText.BackgroundTransparency = 1
warningText.FontFace = fontHeavy
warningText.TextSize = 14
warningText.TextColor3 = white
warningText.Text = ""
warningText.TextStrokeTransparency = 0.4
warningText.TextStrokeColor3 = Color3.new(0, 0, 0)
warningText.TextXAlignment = Enum.TextXAlignment.Center
warningText.TextYAlignment = Enum.TextYAlignment.Center
warningText.Parent = warningBanner

local revealBanner = Instance.new("Frame")
revealBanner.Name = "RevealBanner"
revealBanner.Size = UDim2.new(1, 0, 1, 0)
revealBanner.Position = UDim2.new(0, 0, 0, 0)
revealBanner.BackgroundColor3 = revealPurple
revealBanner.BackgroundTransparency = 0.1
revealBanner.BorderSizePixel = 0
revealBanner.Visible = false
revealBanner.Parent = bottomNotify

local revealCorner = Instance.new("UICorner")
revealCorner.CornerRadius = UDim.new(0, 6)
revealCorner.Parent = revealBanner

local revealText = Instance.new("TextLabel")
revealText.Name = "Text"
revealText.Size = UDim2.new(1, -16, 1, 0)
revealText.Position = UDim2.new(0, 8, 0, 0)
revealText.BackgroundTransparency = 1
revealText.FontFace = fontHeavy
revealText.TextSize = 14
revealText.TextColor3 = white
revealText.Text = ""
revealText.TextStrokeTransparency = 0.4
revealText.TextStrokeColor3 = Color3.new(0, 0, 0)
revealText.TextXAlignment = Enum.TextXAlignment.Center
revealText.TextYAlignment = Enum.TextYAlignment.Center
revealText.Parent = revealBanner

-- Side status panels replaced by Minimap markers (owner-directed)

-- Vitals stack: continuous health bar (number overlaid) above stamina pips, bottom-center
local healthBar = Instance.new("Frame")
healthBar.Name = "HealthBar"
healthBar.AnchorPoint = Vector2.new(0.5, 1)
healthBar.Position = UDim2.new(0.5, 0, 1, -72)
healthBar.Size = UDim2.new(0, 180, 0, 18)
healthBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
healthBar.BackgroundTransparency = 0.35
healthBar.BorderSizePixel = 0
healthBar.Parent = hud
local hbCorner = Instance.new("UICorner")
hbCorner.CornerRadius = UDim.new(0, 5)
hbCorner.Parent = healthBar

local healthFill = Instance.new("Frame")
healthFill.Name = "Fill"
healthFill.Size = UDim2.new(1, 0, 1, 0)
healthFill.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
healthFill.BorderSizePixel = 0
healthFill.Parent = healthBar
local hfCorner = Instance.new("UICorner")
hfCorner.CornerRadius = UDim.new(0, 5)
hfCorner.Parent = healthFill

local healthNumber = Instance.new("TextLabel")
healthNumber.Name = "HealthNumber"
healthNumber.AnchorPoint = Vector2.new(0.5, 1)
healthNumber.Position = UDim2.new(0.5, 0, 1, -72)
healthNumber.Size = UDim2.new(0, 180, 0, 18)
healthNumber.BackgroundTransparency = 1
healthNumber.ZIndex = 2
healthNumber.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
healthNumber.TextSize = 13
healthNumber.TextColor3 = Color3.fromRGB(20, 20, 26)
healthNumber.TextXAlignment = Enum.TextXAlignment.Center
healthNumber.Text = "100"
healthNumber.TextStrokeTransparency = 1
healthNumber.Parent = hud

local TweenService = game:GetService("TweenService")

-- (TopBar has no rounded corners: a full-bleed bar with UICorner reads as a floating slab)

-- Top bar slide-down + fade-in
topBar.BackgroundTransparency = 0.4
local topBarFade = TweenService:Create(topBar, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.4})
topBarFade:Play()

	for _, child in ipairs({teamBadge, scoreLabel, phaseLabel, roundLabel, timerLabel, speedBuff, immunityLabel, modeLabel}) do
	child.BackgroundTransparency = 1
	child.TextTransparency = 1
	local fade = TweenService:Create(child, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
	fade:Play()
end

-- (Side status panels removed — replaced by Minimap markers, owner-directed)

-- BottomNotify fade-in
bottomNotify.BackgroundTransparency = 1
local bnFade = TweenService:Create(bottomNotify, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
bnFade:Play()

-- Pulse animation for warning/reveal banners when visible
local function pulseBanner(banner, textLabel, text, duration)
	if not banner or not textLabel then return end
	textLabel.Text = text
	banner.Visible = true
	local glow = TweenService:Create(banner, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {BackgroundTransparency = 0.1})
	glow:Play()
	task.delay(duration or 6, function()
		glow:Pause()
		banner.BackgroundTransparency = 0.15
		banner.Visible = false
		if textLabel.Text == text then textLabel.Text = "" end
	end)
end

-- Stamina pip row (bottom-center, under the health display position; lit count mirrors LocalPlayer "Stamina" attribute)
local staminaPips = Instance.new("Frame")
staminaPips.Name = "StaminaPips"
staminaPips.AnchorPoint = Vector2.new(0.5, 1)
staminaPips.Position = UDim2.new(0.5, 0, 1, -52)
staminaPips.Size = UDim2.new(0, 180, 0, 6)
staminaPips.BackgroundTransparency = 1
staminaPips.Parent = hud

local staminaLayout = Instance.new("UIListLayout")
staminaLayout.FillDirection = Enum.FillDirection.Horizontal
staminaLayout.Padding = UDim.new(0, 2)
staminaLayout.SortOrder = Enum.SortOrder.LayoutOrder
staminaLayout.Parent = staminaPips

for i = 1, 12 do
	local pip = Instance.new("Frame")
	pip.Name = "Pip" .. i
	pip.LayoutOrder = i
	pip.Size = UDim2.new(0, 13, 0, 6)
	pip.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
	pip.BackgroundTransparency = 0.85
	pip.BorderSizePixel = 0
	pip.Parent = staminaPips
end

-- Flashlight battery pips (night matches only; lit count mirrors LocalPlayer "Battery" attribute)
local batteryPips = Instance.new("Frame")
batteryPips.Name = "BatteryPips"
batteryPips.AnchorPoint = Vector2.new(0.5, 1)
batteryPips.Position = UDim2.new(0.5, 0, 1, -44)
batteryPips.Size = UDim2.new(0, 180, 0, 5)
batteryPips.BackgroundTransparency = 1
batteryPips.Visible = false
batteryPips.Parent = hud

local batteryLayout = Instance.new("UIListLayout")
batteryLayout.FillDirection = Enum.FillDirection.Horizontal
batteryLayout.Padding = UDim.new(0, 2)
batteryLayout.SortOrder = Enum.SortOrder.LayoutOrder
batteryLayout.Parent = batteryPips

for i = 1, 10 do
	local bpip = Instance.new("Frame")
	bpip.Name = "BPip" .. i
	bpip.LayoutOrder = i
	bpip.Size = UDim2.new(0, 13, 0, 5)
	bpip.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
	bpip.BackgroundTransparency = 0.85
	bpip.BorderSizePixel = 0
	bpip.Parent = batteryPips
end

-- Minimap: 2D projection (world X/Z -> map px), top-right; markers positioned/colored by HUDController
local minimap = Instance.new("Frame")
minimap.Name = "Minimap"
minimap.AnchorPoint = Vector2.new(1, 0)
minimap.Position = UDim2.new(1, -10, 0, 46)
minimap.Size = UDim2.new(0, 112, 0, 112)
minimap.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
minimap.BackgroundTransparency = 0.5
minimap.BorderSizePixel = 0
minimap.ClipsDescendants = true
minimap.Parent = hud
local mmStroke = Instance.new("UIStroke")
mmStroke.Color = Color3.fromRGB(90, 100, 115)
mmStroke.Thickness = 1
mmStroke.Transparency = 0.35
mmStroke.Parent = minimap

local function makeMapMarker(name, letterText)
	local marker = Instance.new("Frame")
	marker.Name = name
	marker.AnchorPoint = Vector2.new(0.5, 0.5)
	marker.Size = UDim2.new(0, 12, 0, 12)
	marker.Rotation = 45
	marker.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
	marker.BorderSizePixel = 0
	marker.ZIndex = 2
	marker.Parent = minimap
	-- Camping-pressure ring (REC-0013): amber stroke on jail markers, driven by
	-- HUDController from the server CampingMeterFill attribute. Hidden by default;
	-- thickness scales 0..3px with fill, so camping pressure is visible on the map.
	local ring = Instance.new("UIStroke")
	ring.Name = "CampingRing"
	ring.Color = Color3.fromRGB(255, 140, 50)
	ring.Thickness = 0
	ring.Transparency = 0.15
	ring.Enabled = false
	ring.Parent = marker
	local letter = Instance.new("TextLabel")
	letter.Name = "Letter"
	letter.Size = UDim2.new(0, 10, 0, 8)
	letter.Position = UDim2.new(0, -1, 0, 7)
	letter.Rotation = -45
	letter.BackgroundTransparency = 1
	letter.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
	letter.TextSize = 7
	letter.TextColor3 = Color3.fromRGB(220, 220, 230)
	letter.Text = letterText
	letter.ZIndex = 2
	letter.Parent = marker
	return marker
end
makeMapMarker("MarkerJailA", "A")
makeMapMarker("MarkerJailB", "B")
makeMapMarker("MarkerSiteA", "A")
makeMapMarker("MarkerSiteB", "B")

local playerMarker = Instance.new("Frame")
playerMarker.Name = "PlayerMarker"
playerMarker.AnchorPoint = Vector2.new(0.5, 0.5)
playerMarker.Size = UDim2.new(0, 12, 0, 12)
playerMarker.BackgroundTransparency = 1
playerMarker.ZIndex = 3
playerMarker.Parent = minimap
local playerDot = Instance.new("Frame")
playerDot.Name = "Dot"
playerDot.AnchorPoint = Vector2.new(0.5, 0.5)
playerDot.Position = UDim2.new(0.5, 0, 0.5, 0)
playerDot.Size = UDim2.new(0, 6, 0, 6)
playerDot.BackgroundColor3 = Color3.new(1, 1, 1)
playerDot.BorderSizePixel = 0
playerDot.ZIndex = 3
playerDot.Parent = playerMarker
local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = playerDot
local playerNose = Instance.new("Frame")
playerNose.Name = "Nose"
playerNose.AnchorPoint = Vector2.new(0.5, 1)
playerNose.Position = UDim2.new(0.5, 0, 0.15, 0)
playerNose.Size = UDim2.new(0, 2, 0, 4)
playerNose.BackgroundColor3 = Color3.new(1, 1, 1)
playerNose.BorderSizePixel = 0
playerNose.ZIndex = 3
playerNose.Parent = playerMarker

-- Crosshair: center dot + state ring + contextual hint (the controller drives
-- color/size/text from proximity; the existing menu-hide logic picks this up).
local crosshair = Instance.new("Frame")
crosshair.Name = "Crosshair"
crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
crosshair.Size = UDim2.new(0, 28, 0, 28)
crosshair.BackgroundTransparency = 1
crosshair.ZIndex = 5
crosshair.Parent = hud

local chDot = Instance.new("Frame")
chDot.Name = "Dot"
chDot.AnchorPoint = Vector2.new(0.5, 0.5)
chDot.Position = UDim2.new(0.5, 0, 0.5, 0)
chDot.Size = UDim2.new(0, 6, 0, 6)
chDot.BackgroundColor3 = Color3.new(1, 1, 1)
chDot.BorderSizePixel = 0
chDot.ZIndex = 6
chDot.Parent = crosshair
local chDotCorner = Instance.new("UICorner")
chDotCorner.CornerRadius = UDim.new(1, 0)
chDotCorner.Parent = chDot
local chDotOutline = Instance.new("UIStroke")
chDotOutline.Thickness = 2
chDotOutline.Color = Color3.new(0, 0, 0)
chDotOutline.Transparency = 0.25
chDotOutline.Parent = chDot

local chRing = Instance.new("Frame")
chRing.Name = "Ring"
chRing.AnchorPoint = Vector2.new(0.5, 0.5)
chRing.Position = UDim2.new(0.5, 0, 0.5, 0)
chRing.Size = UDim2.new(0, 24, 0, 24)
chRing.BackgroundTransparency = 1
chRing.ZIndex = 5
chRing.Parent = crosshair
local chRingCorner = Instance.new("UICorner")
chRingCorner.CornerRadius = UDim.new(1, 0)
chRingCorner.Parent = chRing
local chStroke = Instance.new("UIStroke")
chStroke.Name = "Stroke"
chStroke.Thickness = 3
chStroke.Color = Color3.new(1, 1, 1)
chStroke.Transparency = 0.35
chStroke.Parent = chRing

local hintLabel = Instance.new("TextLabel")
hintLabel.Name = "HintLabel"
hintLabel.AnchorPoint = Vector2.new(0.5, 0)
hintLabel.Position = UDim2.new(0.5, 0, 0.5, 22)
hintLabel.Size = UDim2.new(0, 260, 0, 16)
hintLabel.BackgroundTransparency = 1
hintLabel.FontFace = font
hintLabel.TextSize = 13
hintLabel.TextColor3 = lightText
hintLabel.TextStrokeTransparency = 0.5
hintLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
hintLabel.TextXAlignment = Enum.TextXAlignment.Center
hintLabel.Text = ""
hintLabel.Visible = false
hintLabel.ZIndex = 6
hintLabel.Parent = crosshair

print("[BOPLUX_HUD] ScreenGui built with animations")

