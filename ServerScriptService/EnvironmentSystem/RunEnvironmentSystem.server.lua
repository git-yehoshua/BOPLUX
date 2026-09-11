-- RunEnvironmentSystem: Day/Night match mode + night flashlight (owner feature,
-- 2026-09-10). Server-authoritative per GDD §15: the mode is rolled once per
-- match start, applied to Lighting, and mirrored to clients; the flashlight is
-- a head-mounted SpotLight granted on request (L key -> RequestFlashlight) with
-- a battery that drains while lit and recharges while dark. Because the beam
-- lives on the character, every client sees who is lit — light reveals you.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local EnvironmentConfig = require(script.Parent.EnvironmentConfig)
local EnvironmentState = require(script.Parent.EnvironmentState)
local MatchState = require(ServerScriptService.MatchManager.MatchState)

local TOGGLE_COOLDOWN = 0.25

local state = EnvironmentState.new()
local lastToggle = {}
local lastSync = {}
local nightProps = {}

local function ensureMatchSystems()
	local matchSystems = ReplicatedStorage:FindFirstChild("MatchSystems")
	if not matchSystems then
		matchSystems = Instance.new("Folder")
		matchSystems.Name = "MatchSystems"
		matchSystems.Parent = ReplicatedStorage
	end
	return matchSystems
end

local function ensureRemote(parent, name)
	local remote = parent:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = parent
	end
	return remote
end

local matchSystems = ensureMatchSystems()
local requestFlashlight = ensureRemote(matchSystems, "RequestFlashlight")
local environmentSync = ensureRemote(matchSystems, "EnvironmentSync")

-- Night-only objective readability: site beacons glow, and every part named
-- *NightLamp* (jail cell bulbs, bank lamp posts, fiesta string lights — see
-- MapBuilder v002) gains a real light source. Tracked in nightProps so a day
-- match (or next application) restores the contract materials exactly.
local function clearNightProps()
	for _, instance in ipairs(nightProps) do
		instance:Destroy()
	end
	nightProps = {}
	local sites = Workspace:FindFirstChild("Sites")
	if sites then
		for _, model in ipairs(sites:GetChildren()) do
			local beacon = model:FindFirstChild("Beacon")
			if beacon then
				beacon.Material = Enum.Material.SmoothPlastic
			end
		end
	end
end

local function applyNightObjectiveProps()
	local sites = Workspace:FindFirstChild("Sites")
	if sites then
		for _, model in ipairs(sites:GetChildren()) do
			local beacon = model:FindFirstChild("Beacon")
			if beacon then
				beacon.Material = Enum.Material.Neon
				local light = Instance.new("PointLight")
				light.Name = "NightBeaconLight"
				light.Range = 16
				light.Brightness = 2
				light.Color = Color3.fromRGB(120, 190, 255)
				light.Parent = beacon
				table.insert(nightProps, light)
			end
		end
	end
	for _, descendant in ipairs(Workspace:GetDescendants()) do
		if descendant:IsA("BasePart") and string.find(descendant.Name, "NightLamp", 1, true) then
			local light = Instance.new("PointLight")
			light.Name = "NightLampLight"
			light.Range = 11
			light.Brightness = 1.4
			light.Color = Color3.fromRGB(255, 214, 150)
			light.Parent = descendant
			table.insert(nightProps, light)
		end
	end
end

local function applyLighting(mode)
	local snapshot = mode == EnvironmentState.MODE.Night and EnvironmentConfig.Night or EnvironmentConfig.Day
	Lighting.ClockTime = snapshot.ClockTime
	Lighting.Brightness = snapshot.Brightness
	Lighting.Ambient = snapshot.Ambient
	Lighting.OutdoorAmbient = snapshot.OutdoorAmbient
	Lighting.FogColor = snapshot.FogColor
	Lighting.FogEnd = snapshot.FogEnd
	Lighting.ExposureCompensation = snapshot.ExposureCompensation
	if mode == EnvironmentState.MODE.Night then
		applyNightObjectiveProps()
	else
		clearNightProps()
	end
end

local function setFlashlight(player, env, on)
	env.flashlightOn = on
	if env.light then
		env.light:Destroy()
		env.light = nil
	end
	if env.mount then
		env.mount:Destroy()
		env.mount = nil
	end
	if not on then
		return
	end
	local character = player.Character
	local head = character and character:FindFirstChild("Head")
	if not head then
		env.flashlightOn = false
		return
	end
	-- Emission origin sits ~1.5 studs in FRONT of the head face: a SpotLight
	-- parented directly to the head emits from the face plane, so anything
	-- closer than that (walls you hug) sits behind the origin and stays
	-- unlit, and the head shadows its own near beam. The forward mount fixes
	-- close-range illumination.
	local mount = Instance.new("Attachment")
	mount.Name = "FlashlightMount"
	mount.Position = Vector3.new(0, 0.3, -1.5)
	mount.Parent = head
	env.mount = mount
	local spot = Instance.new("SpotLight")
	spot.Name = "Flashlight"
	spot.Range = EnvironmentConfig.FlashlightRange
	spot.Angle = EnvironmentConfig.FlashlightAngle
	spot.Brightness = EnvironmentConfig.FlashlightBrightness
	spot.Color = EnvironmentConfig.FlashlightColor
	spot.Shadows = true
	spot.Face = Enum.NormalId.Front
	spot.Parent = mount
	env.light = spot
end

local function fireEnvironmentSync(player)
	local env = EnvironmentState.envFor(state, player)
	if not env then
		return
	end
	local snapshot = {
		mode = state.mode,
		flashlightOn = env.flashlightOn,
		battery = math.floor(env.battery * 10) / 10,
	}
	local last = lastSync[player]
	if last and last.mode == snapshot.mode and last.flashlightOn == snapshot.flashlightOn and last.battery == snapshot.battery then
		return
	end
	lastSync[player] = snapshot
	environmentSync:FireClient(player, snapshot)
end

requestFlashlight.OnServerEvent:Connect(function(player)
	local now = os.clock()
	local last = lastToggle[player]
	if last and (now - last) < TOGGLE_COOLDOWN then
		return
	end
	lastToggle[player] = now

	local env = state.mode and EnvironmentState.envFor(state, player) or nil
	if not env then
		return
	end
	local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end

	local wanted = not env.flashlightOn
	local granted = EnvironmentState.toggleFlashlight(state, env, wanted)
	if not granted then
		-- Silent reject per house convention (invalid requests are a no-op).
		return
	end
	setFlashlight(player, env, wanted)
	print("[Environment] Flashlight " .. (wanted and "ON" or "OFF") .. " for " .. player.Name)
end)

local function onPreRound(round)
	if round == 1 then
		EnvironmentState.startMatch(state, math.random)
		applyLighting(state.mode)
		print("[Environment] Match mode: " .. tostring(state.mode))
	end
	EnvironmentState.resetAllRounds(state)
end

local function wireMatchEvents()
	local events = ServerScriptService.MatchManager.MatchManager:WaitForChild("Events", 30)
	local phaseChanged = events:WaitForChild("PhaseChanged", 30)
	phaseChanged.Event:Connect(function(phase, round)
		if phase == "PreRound" then
			onPreRound(round)
		end
	end)
end

local function onCharacterAdded(player)
	local env = EnvironmentState.envFor(state, player)
	if env then
		EnvironmentState.resetPlayerRound(env)
	end
end

local function onPlayerAdded(player)
	EnvironmentState.register(state, player)
	player.CameraMode = Enum.CameraMode.LockFirstPerson
	if player.Character then
		onCharacterAdded(player, player.Character)
	end
	player.CharacterAdded:Connect(function()
		onCharacterAdded(player)
	end)
end

local function onPlayerRemoving(player)
	EnvironmentState.unregister(state, player)
	lastToggle[player] = nil
	lastSync[player] = nil
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

wireMatchEvents()

RunService.Heartbeat:Connect(function(dt)
	for _, player in ipairs(Players:GetPlayers()) do
		local env = EnvironmentState.envFor(state, player)
		if env then
			EnvironmentState.stepBattery(env, dt)
			fireEnvironmentSync(player)
		end
	end
end)

print("[Environment] Day/Night + flashlight system ready")
