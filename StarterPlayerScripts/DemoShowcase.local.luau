local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function findRemote(name)
	local ms = ReplicatedStorage:FindFirstChild("MatchSystems")
	if not ms then return nil end
	return ms:FindFirstChild(name)
end

local function log(msg)
	print("[DemoShowcase] " .. msg)
end

local demoMode = script:GetAttribute("DemoMode") == true
if not demoMode then
	return
end

local player = Players.LocalPlayer

local function rootPart()
	local character = player.Character
	if not character then return nil end
	return character:FindFirstChild("HumanoidRootPart")
end

local function humanoidOf()
	local character = player.Character
	if not character then return nil end
	return character:FindFirstChildOfClass("Humanoid")
end

local function walkTo(position, timeout)
	local hrp = rootPart()
	local hum = humanoidOf()
	if not hrp or not hum then return false end
	hum:MoveTo(position)
	local finished = hum.MoveToFinished:Wait(timeout or 20)
	return finished == true
end

local function waitForLive()
	local matchSystems = ReplicatedStorage:FindFirstChild("MatchSystems")
	local matchStateSync = matchSystems and matchSystems:FindFirstChild("MatchStateSync")
	if not matchStateSync then return true end
	local liveSeen = false
	matchStateSync.OnClientEvent:Connect(function(data)
		if data and data.phase == "Live" then
			liveSeen = true
		end
	end)
	local waited = 0
	while not liveSeen and waited < 90 do
		task.wait(1)
		waited = waited + 1
	end
	return liveSeen
end

local function jailSelf(cellId)
	local md = findRemote("MatchDebug")
	if md then
		md:FireServer("jail", cellId or "A")
		task.wait(1.5)
	end
	local h = humanoidOf()
	if h then
		log("Jailed - WalkSpeed locked to 0: " .. tostring(h.WalkSpeed))
	end
end

local function startBreakout(cellId)
	local rbh = findRemote("RequestBreakoutHold")
	if rbh then
		rbh:FireServer(cellId or "A")
	end
end

local function releaseSelf()
	local md = findRemote("MatchDebug")
	if md then
		md:FireServer("release")
		task.wait(1.5)
	end
end

local function plantAt(siteId)
	local od = findRemote("ObjectiveDebug")
	if od then
		od:FireServer("plant", siteId or "A")
		task.wait(1.5)
	end
end

local function fireTell(siteId)
	local ad = findRemote("AudioDebug")
	if ad then
		ad:FireServer("tell", siteId)
	end
end

local function selectImpostor()
	local imd = findRemote("ImpostorDebug")
	if imd then
		imd:FireServer("select")
		task.wait(1.5)
	end
end

local function revealImpostor()
	local imd = findRemote("ImpostorDebug")
	if imd then
		imd:FireServer("reveal")
	end
end

local function siteCenter(siteId)
	local sites = game:GetService("Workspace"):FindFirstChild("Sites")
	if not sites then return nil end
	local site = sites:FindFirstChild("Site_" .. (siteId or "A"))
	return site and site:FindFirstChild("Interior") and site:FindFirstChild("Interior").Position
end

local function waitCharacter()
	local waited = 0
	while not player.Character and waited < 20 do
		task.wait(0.5)
		waited = waited + 0.5
	end
end

log("Starting BOPLUX Demo Showcase (DemoMode=true)")

waitCharacter()
local liveSeen = waitForLive()
log("Match live: " .. tostring(liveSeen))

log("ACT 1 - Jail + breakout (warning ping should play every 3s)")
jailSelf("A")
startBreakout("A")
log("Breakout channel started - listening for warning pings ~12s")
task.wait(12)

log("ACT 2 - Release")
releaseSelf()

log("ACT 3 - Walk to Site A and plant")
local target = siteCenter("A")
if target then
	target = target + Vector3.new(2, 0, 2)
	walkTo(target, 25)
end
plantAt("A")

log("ACT 4 - Impostor tell sound (eerie sting at Site A)")
selectImpostor()
fireTell("A")
task.wait(2)

log("ACT 5 - Reveal banner")
revealImpostor()

log("Demo Showcase complete. HUD should show planted site + reveal banner.")