local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("BOPLUX_HUD") then return end

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
topBar.Size = UDim2.new(1, 0, 0, 44)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = darkBg
topBar.BackgroundTransparency = 0.25
topBar.BorderSizePixel = 0
topBar.Parent = hud

local teamBadge = Instance.new("TextLabel")
teamBadge.Name = "TeamBadge"
teamBadge.Size = UDim2.new(0, 80, 0, 18)
teamBadge.Position = UDim2.new(0, 12, 0, 4)
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
scoreLabel.Position = UDim2.new(0, 12, 0, 24)
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
roundLabel.Position = UDim2.new(0.5, -40, 0, 20)
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
timerLabel.Position = UDim2.new(0.5, -30, 0, 32)
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

local staminaLabel = Instance.new("TextLabel")
staminaLabel.Name = "StaminaLabel"
staminaLabel.Size = UDim2.new(0, 60, 0, 10)
staminaLabel.Position = UDim2.new(1, -170, 0, 6)
staminaLabel.BackgroundTransparency = 1
staminaLabel.FontFace = font
staminaLabel.TextSize = 9
staminaLabel.TextColor3 = dimText
staminaLabel.Text = "STAMINA"
staminaLabel.TextStrokeTransparency = 1
staminaLabel.TextXAlignment = Enum.TextXAlignment.Center
staminaLabel.TextYAlignment = Enum.TextYAlignment.Center
staminaLabel.Parent = topBar

local staminaBar = Instance.new("Frame")
staminaBar.Name = "StaminaBar"
staminaBar.Size = UDim2.new(0, 150, 0, 8)
staminaBar.Position = UDim2.new(1, -170, 0, 20)
staminaBar.BackgroundColor3 = barBg
staminaBar.BorderSizePixel = 0
staminaBar.Parent = topBar

local staminaCorner = Instance.new("UICorner")
staminaCorner.CornerRadius = UDim.new(0, 3)
staminaCorner.Parent = staminaBar

local staminaFill = Instance.new("Frame")
staminaFill.Name = "Fill"
staminaFill.Size = UDim2.new(1, 0, 1, 0)
staminaFill.BackgroundColor3 = fillGreen
staminaFill.BorderSizePixel = 0
staminaFill.Parent = staminaBar

local staminaFillCorner = Instance.new("UICorner")
staminaFillCorner.CornerRadius = UDim.new(0, 3)
staminaFillCorner.Parent = staminaFill

local speedBuff = Instance.new("TextLabel")
speedBuff.Name = "SpeedBuff"
speedBuff.Size = UDim2.new(0, 30, 0, 10)
speedBuff.Position = UDim2.new(1, -170, 0, 32)
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
immunityLabel.Position = UDim2.new(1, -130, 0, 32)
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

local bottomNotify = Instance.new("Frame")
bottomNotify.Name = "BottomNotify"
bottomNotify.Size = UDim2.new(0.5, 0, 0, 44)
bottomNotify.Position = UDim2.new(0.25, 0, 1, -64)
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

local leftSide = Instance.new("Frame")
leftSide.Name = "LeftSide"
leftSide.Size = UDim2.new(0, 160, 0, 70)
leftSide.Position = UDim2.new(0, 8, 0.5, -35)
leftSide.BackgroundTransparency = 1
leftSide.BorderSizePixel = 1
leftSide.BorderColor3 = darkBg
leftSide.Parent = hud

local jailPanel = Instance.new("Frame")
jailPanel.Name = "JailPanel"
jailPanel.Size = UDim2.new(1, 0, 1, 0)
jailPanel.Position = UDim2.new(0, 0, 0, 0)
jailPanel.BackgroundColor3 = panelBg
jailPanel.BackgroundTransparency = 0.35
jailPanel.BorderSizePixel = 0
jailPanel.Visible = false
jailPanel.Parent = leftSide

local jailCorner = Instance.new("UICorner")
jailCorner.CornerRadius = UDim.new(0, 6)
jailCorner.Parent = jailPanel

local jailTitle = Instance.new("TextLabel")
jailTitle.Name = "Title"
jailTitle.Size = UDim2.new(1, -12, 0, 14)
jailTitle.Position = UDim2.new(0, 6, 0, 2)
jailTitle.BackgroundTransparency = 1
jailTitle.FontFace = font
jailTitle.TextSize = 8
jailTitle.TextScaled = true
jailTitle.TextColor3 = lightText
jailTitle.Text = "JAILS"
jailTitle.TextStrokeTransparency = 0.5
jailTitle.TextStrokeColor3 = Color3.new(0, 0, 0)
jailTitle.TextXAlignment = Enum.TextXAlignment.Left
jailTitle.TextYAlignment = Enum.TextYAlignment.Center
jailTitle.Parent = jailPanel

local cellA = Instance.new("TextLabel")
cellA.Name = "CellA"
cellA.Size = UDim2.new(1, -12, 0, 12)
cellA.Position = UDim2.new(0, 6, 0, 18)
cellA.BackgroundTransparency = 1
cellA.FontFace = font
cellA.TextSize = 8
cellA.TextScaled = true
cellA.TextColor3 = dimText
cellA.Text = "Cell A: Empty"
cellA.TextStrokeTransparency = 0.5
cellA.TextStrokeColor3 = Color3.new(0, 0, 0)
cellA.TextXAlignment = Enum.TextXAlignment.Left
cellA.TextYAlignment = Enum.TextYAlignment.Center
cellA.Parent = jailPanel

local cellB = Instance.new("TextLabel")
cellB.Name = "CellB"
cellB.Size = UDim2.new(1, -12, 0, 12)
cellB.Position = UDim2.new(0, 6, 0, 32)
cellB.BackgroundTransparency = 1
cellB.FontFace = font
cellB.TextSize = 8
cellB.TextScaled = true
cellB.TextColor3 = dimText
cellB.Text = "Cell B: Empty"
cellB.TextStrokeTransparency = 0.5
cellB.TextStrokeColor3 = Color3.new(0, 0, 0)
cellB.TextXAlignment = Enum.TextXAlignment.Left
cellB.TextYAlignment = Enum.TextYAlignment.Center
cellB.Parent = jailPanel

local function makeCampingBar(name, posY)
	local bar = Instance.new("Frame")
	bar.Name = name
	bar.Size = UDim2.new(1, -12, 0, 5)
	bar.Position = UDim2.new(0, 6, 0, posY)
	bar.BackgroundColor3 = barBg
	bar.BorderSizePixel = 0
	bar.Parent = jailPanel

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 2)
	corner.Parent = bar

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = campingOrange
	fill.BorderSizePixel = 0
	fill.Parent = bar

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 2)
	fillCorner.Parent = fill

	return bar
end

makeCampingBar("CampingA", 50)
makeCampingBar("CampingB", 58)

local rightSide = Instance.new("Frame")
rightSide.Name = "RightSide"
rightSide.Size = UDim2.new(0, 160, 0, 50)
rightSide.Position = UDim2.new(1, -168, 0.5, -25)
rightSide.BackgroundTransparency = 1
rightSide.BorderSizePixel = 1
rightSide.BorderColor3 = darkBg
rightSide.Parent = hud

local objPanel = Instance.new("Frame")
objPanel.Name = "ObjectivePanel"
objPanel.Size = UDim2.new(1, 0, 1, 0)
objPanel.Position = UDim2.new(0, 0, 0, 0)
objPanel.BackgroundColor3 = panelBg
objPanel.BackgroundTransparency = 0.35
objPanel.BorderSizePixel = 0
objPanel.Visible = false
objPanel.Parent = rightSide

local objCorner = Instance.new("UICorner")
objCorner.CornerRadius = UDim.new(0, 6)
objCorner.Parent = objPanel

local objTitle = Instance.new("TextLabel")
objTitle.Name = "Title"
objTitle.Size = UDim2.new(1, -12, 0, 14)
objTitle.Position = UDim2.new(0, 6, 0, 2)
objTitle.BackgroundTransparency = 1
objTitle.FontFace = font
objTitle.TextSize = 8
objTitle.TextScaled = true
objTitle.TextColor3 = lightText
objTitle.Text = "OBJECTIVES"
objTitle.TextStrokeTransparency = 0.5
objTitle.TextStrokeColor3 = Color3.new(0, 0, 0)
objTitle.TextXAlignment = Enum.TextXAlignment.Left
objTitle.TextYAlignment = Enum.TextYAlignment.Center
objTitle.Parent = objPanel

local siteA = Instance.new("TextLabel")
siteA.Name = "SiteA"
siteA.Size = UDim2.new(1, -12, 0, 12)
siteA.Position = UDim2.new(0, 6, 0, 18)
siteA.BackgroundTransparency = 1
siteA.FontFace = font
siteA.TextSize = 8
siteA.TextScaled = true
siteA.TextColor3 = dimText
siteA.Text = "Site A: Clear"
siteA.TextStrokeTransparency = 0.5
siteA.TextStrokeColor3 = Color3.new(0, 0, 0)
siteA.TextXAlignment = Enum.TextXAlignment.Left
siteA.TextYAlignment = Enum.TextYAlignment.Center
siteA.Parent = objPanel

local siteB = Instance.new("TextLabel")
siteB.Name = "SiteB"
siteB.Size = UDim2.new(1, -12, 0, 12)
siteB.Position = UDim2.new(0, 6, 0, 32)
siteB.BackgroundTransparency = 1
siteB.FontFace = font
siteB.TextSize = 8
siteB.TextScaled = true
siteB.TextColor3 = dimText
siteB.Text = "Site B: Clear"
siteB.TextStrokeTransparency = 0.5
siteB.TextStrokeColor3 = Color3.new(0, 0, 0)
siteB.TextXAlignment = Enum.TextXAlignment.Left
siteB.TextYAlignment = Enum.TextYAlignment.Center
siteB.Parent = objPanel

local TweenService = game:GetService("TweenService")

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 6)
topBarCorner.Parent = topBar

-- Top bar slide-down + fade-in
topBar.BackgroundTransparency = 0.25
local topBarFade = TweenService:Create(topBar, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.25})
topBarFade:Play()

for _, child in ipairs({teamBadge, scoreLabel, phaseLabel, roundLabel, timerLabel, staminaLabel, staminaBar, speedBuff, immunityLabel}) do
	child.BackgroundTransparency = 1
	child.TextTransparency = 1
	local fade = TweenService:Create(child, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0.1, true), {TextTransparency = 0})
	fade:Play()
end

-- Side panels slide-in
leftSide.Position = UDim2.new(-0.2, 8, 0.5, -35)
rightSide.Position = UDim2.new(1.2, -168, 0.5, -25)
task.wait(0.3)
local slideLeft = TweenService:Create(leftSide, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 8, 0.5, -35)})
slideLeft:Play()
local slideRight = TweenService:Create(rightSide, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -168, 0.5, -25)})
slideRight:Play()

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

print("[BOPLUX_HUD] ScreenGui built with animations")
