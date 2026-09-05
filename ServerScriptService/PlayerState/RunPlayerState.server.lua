local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PhysicsService = game:GetService("PhysicsService")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerStateModule = require(script.Parent.PlayerStateModule)

local ATTACKER_GROUP = "Attackers"
local DEFENDER_GROUP = "Defenders"
local BASE_GROUP = "Default"
local COOLDOWN_SECONDS = 0.1

local function ensureCollisionGroups()
	PhysicsService:RegisterCollisionGroup(ATTACKER_GROUP)
	PhysicsService:RegisterCollisionGroup(DEFENDER_GROUP)
	PhysicsService:CollisionGroupSetCollidable(ATTACKER_GROUP, ATTACKER_GROUP, true)
	PhysicsService:CollisionGroupSetCollidable(DEFENDER_GROUP, DEFENDER_GROUP, true)
	PhysicsService:CollisionGroupSetCollidable(ATTACKER_GROUP, DEFENDER_GROUP, false)
	PhysicsService:CollisionGroupSetCollidable(DEFENDER_GROUP, ATTACKER_GROUP, false)
	PhysicsService:CollisionGroupSetCollidable(ATTACKER_GROUP, BASE_GROUP, true)
	PhysicsService:CollisionGroupSetCollidable(DEFENDER_GROUP, BASE_GROUP, true)
end

local function collideGroupFor(team)
	if team == "Attackers" then
		return ATTACKER_GROUP
	elseif team == "Defenders" then
		return DEFENDER_GROUP
	end
	return BASE_GROUP
end

local function applyCollisionGroup(character, team)
	local group = collideGroupFor(team)
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CollisionGroup = group
		end
	end
end

local function currentTeamFor(player)
	local MatchState = require(ServerScriptService.MatchManager.MatchState)
	local live = MatchState.liveState()
	if not live then
		return nil
	end
	return MatchState.teamFor(live, player)
end

local function applyRole(player)
	local team = currentTeamFor(player)
	local character = player.Character
	if team and character then
		applyCollisionGroup(character, team)
	end
end

local function syncAllRoles()
	for _, player in ipairs(Players:GetPlayers()) do
		applyRole(player)
	end
end

local function wireMatchEvents()
	local events = ServerScriptService.MatchManager.MatchManager:WaitForChild("Events", 30)
	local phaseChanged = events:WaitForChild("PhaseChanged", 30)
	phaseChanged.Event:Connect(function(phase, round)
		if phase == "PreRound" then
			syncAllRoles()
		elseif phase == "Live" then
			PlayerStateModule.resetAllPlayers()
		elseif phase == "Halftime" then
			syncAllRoles()
		end
	end)
end

ensureCollisionGroups()

local matchSystems = ReplicatedStorage:FindFirstChild("MatchSystems")
if not matchSystems then
	matchSystems = Instance.new("Folder")
	matchSystems.Name = "MatchSystems"
	matchSystems.Parent = ReplicatedStorage
end

local requestSprint = Instance.new("RemoteEvent")
requestSprint.Name = "RequestSprint"
requestSprint.Parent = matchSystems

local playerStateSync = matchSystems:FindFirstChild("PlayerStateSync")
if not playerStateSync then
	playerStateSync = Instance.new("RemoteEvent")
	playerStateSync.Name = "PlayerStateSync"
	playerStateSync.Parent = matchSystems
end

local lastSyncState = {}
local lastToggle = {}

requestSprint.OnServerEvent:Connect(function(player, wanted)
	local now = os.clock()
	local last = lastToggle[player]
	if last and (now - last) < COOLDOWN_SECONDS then
		return
	end
	lastToggle[player] = now
	PlayerStateModule.requestSprint(player, wanted == true)
end)

local function firePlayerSync(player)
	local state = PlayerStateModule.stateFor(player)
	if not state then return end
	local now = os.clock()
	local snapshot = {
		stamina = math.floor(state.stamina * 10) / 10,
		isSprinting = state.sprinting,
		isJailed = state.jailed,
		hasSpeedBuff = state.speedBuffUntil > now,
		hasCaptureImmunity = state.captureImmunityUntil > now,
	}
	local last = lastSyncState[player]
	if last
		and last.stamina == snapshot.stamina
		and last.isSprinting == snapshot.isSprinting
		and last.isJailed == snapshot.isJailed
		and last.hasSpeedBuff == snapshot.hasSpeedBuff
		and last.hasCaptureImmunity == snapshot.hasCaptureImmunity then
		return
	end
	lastSyncState[player] = snapshot
	playerStateSync:FireClient(player, snapshot)
end

local function onCharacterAdded(player, character)
	PlayerStateModule.resetPlayerRound(player)
	applyRole(player)
end

local function onPlayerAdded(player)
	PlayerStateModule.register(player)
	player.CameraMode = Enum.CameraMode.LockFirstPerson
	if player.Character then
		onCharacterAdded(player, player.Character)
	end
	player.CharacterAdded:Connect(function(character)
		onCharacterAdded(player, character)
	end)
end

local function onPlayerRemoving(player)
	lastToggle[player] = nil
	lastSyncState[player] = nil
	PlayerStateModule.unregister(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

wireMatchEvents()

RunService.Heartbeat:Connect(function(dt)
	for _, player in ipairs(Players:GetPlayers()) do
		PlayerStateModule.step(player, dt)
		firePlayerSync(player)
	end
end)
