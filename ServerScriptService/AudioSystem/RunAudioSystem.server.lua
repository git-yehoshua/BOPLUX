local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local AudioConfig = require(script.Parent.AudioConfig)

local audioEvents = Instance.new("Folder")
audioEvents.Name = "AudioEvents"
audioEvents.Parent = script

local impostorTellRequested = Instance.new("BindableEvent")
impostorTellRequested.Name = "ImpostorTellRequested"
impostorTellRequested.Parent = audioEvents

local playBreakoutWarning
local playImpostorTell

local function rootPartFor(player)
	local character = player.Character
	if not character then
		return nil
	end
	return character:FindFirstChild("HumanoidRootPart")
end

local function buildPayload(soundId, position)
	return {
		SoundId = soundId,
		Position = position,
	}
end

local function broadcast(remote, soundId, position, radius)
	for _, player in ipairs(Players:GetPlayers()) do
		local root = rootPartFor(player)
		if root and (root.Position - position).Magnitude <= radius then
			remote:FireClient(player, buildPayload(soundId, position))
		end
	end
end

local function completeTell(position)
	broadcast(playImpostorTell, AudioConfig.ImpostorTellSoundId, position, AudioConfig.ImpostorTellAudibleRadius)
end

local lastWarn = {}

local function breakoutWarningHeartbeat()
	local now = os.clock()
	local jails = Workspace:FindFirstChild("Jails")
	if not jails then
		return
	end
	for _, cell in ipairs(jails:GetChildren()) do
		local interior = cell:FindFirstChild("Interior")
		if interior then
			if interior:GetAttribute("ChannelKind") == "breakout" then
				local lastTime = lastWarn[interior]
				if not lastTime or now - lastTime >= AudioConfig.BreakoutWarningInterval then
					lastWarn[interior] = now
					broadcast(
						playBreakoutWarning,
						AudioConfig.BreakoutWarningSoundId,
						interior.Position,
						AudioConfig.BreakoutWarningAudibleRadius
					)
				end
			else
				lastWarn[interior] = nil
			end
		end
	end
end

local function wireRemotes()
	playBreakoutWarning = Instance.new("RemoteEvent")
	playBreakoutWarning.Name = "PlayBreakoutWarning"
	playBreakoutWarning.Parent = ReplicatedStorage

	playImpostorTell = Instance.new("RemoteEvent")
	playImpostorTell.Name = "PlayImpostorTell"
	playImpostorTell.Parent = ReplicatedStorage

	local matchSystems = ReplicatedStorage:FindFirstChild("MatchSystems")
	if not matchSystems then
		matchSystems = Instance.new("Folder")
		matchSystems.Name = "MatchSystems"
		matchSystems.Parent = ReplicatedStorage
	end

	local audioDebug = Instance.new("RemoteEvent")
	audioDebug.Name = "AudioDebug"
	audioDebug.Parent = matchSystems

	audioDebug.OnServerEvent:Connect(function(player, command, siteId)
		if script:GetAttribute("DebugMode") ~= true then
			return
		end
		if command ~= "tell" then
			return
		end
		local position
		if siteId then
			local sites = Workspace:FindFirstChild("Sites")
			local site = sites and sites:FindFirstChild("Site_" .. siteId)
			local interior = site and site:FindFirstChild("Interior")
			if interior then
				position = interior.Position
			end
		end
		local root = rootPartFor(player)
		if not position and root then
			position = root.Position
		end
		if position then
			completeTell(position)
		end
	end)

	impostorTellRequested.Event:Connect(function(worldPosition, radius)
		if type(worldPosition) ~= "Vector3" then
			return
		end
		broadcast(playImpostorTell, AudioConfig.ImpostorTellSoundId, worldPosition, radius or AudioConfig.ImpostorTellAudibleRadius)
	end)
end

wireRemotes()

RunService.Heartbeat:Connect(breakoutWarningHeartbeat)