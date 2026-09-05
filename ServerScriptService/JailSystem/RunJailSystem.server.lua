local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local JailConfig = require(script.Parent.JailConfig)
local JailState = require(script.Parent.JailState)
local MatchState = require(ServerScriptService.MatchManager.MatchState)
local PlayerStateModule = require(ServerScriptService.PlayerState.PlayerStateModule)

local CELL_LAYOUT = {
	{
		id = "A",
		center = Vector3.new(24, 8, 20),
		doorAxis = Vector3.new(1, 0, 0),
	},
	{
		id = "B",
		center = Vector3.new(-24, 8, -20),
		doorAxis = Vector3.new(-1, 0, 0),
	},
}

local cellsModel
local cellMarkers = {}

local jailEvents = Instance.new("Folder")
jailEvents.Name = "JailEvents"
jailEvents.Parent = script

local playerJailed = Instance.new("BindableEvent")
playerJailed.Name = "PlayerJailed"
playerJailed.Parent = jailEvents

local playerReleased = Instance.new("BindableEvent")
playerReleased.Name = "PlayerReleased"
playerReleased.Parent = jailEvents

local jailReleasedAll = Instance.new("BindableEvent")
jailReleasedAll.Name = "JailReleasedAll"
jailReleasedAll.Parent = jailEvents

local function phaseOf()
	local state = MatchState.liveState()
	if not state then
		return nil
	end
	return MatchState.phaseOf(state)
end

local function teamFor(player)
	local state = MatchState.liveState()
	if not state then
		return nil
	end
	return MatchState.teamFor(state, player)
end

local function attackers()
	local state = MatchState.liveState()
	if not state then
		return {}
	end
	local result = {}
	for _, role in pairs(state.roles) do
		if role.team == MatchState.TEAM.Attackers then
			table.insert(result, role.player)
		end
	end
	return result
end

local function rootPartFor(player)
	local character = player.Character
	if not character then
		return nil
	end
	return character:FindFirstChild("HumanoidRootPart")
end

local function distanceBetween(requester, target)
	local a = rootPartFor(requester)
	local b = rootPartFor(target)
	if not a or not b then
		return math.huge
	end
	return (a.Position - b.Position).Magnitude
end

local function teleportTo(player, position)
	local root = rootPartFor(player)
	if root then
		root.CFrame = CFrame.new(position)
	end
end

local function outwardOffset(index)
	return Vector3.new(0, 1.5, 0) + Vector3.new(math.fmod(index, 3) - 1, 0, 0) * 2
end

local function updateCellAttributes(cellId)
	local interior = cellMarkers[cellId]
	if not interior then
		return
	end
	interior:SetAttribute("JailOccupantCount", JailState.occupantCount(cellId))
	local info = JailState.channelInfo(cellId)
	if info then
		interior:SetAttribute("ChannelKind", info.kind)
		if info.kind == "breakout" then
			interior:SetAttribute("BreakoutProgress", info.progress)
			interior:SetAttribute("RescueProgress", 0)
		else
			interior:SetAttribute("BreakoutProgress", 0)
			interior:SetAttribute("RescueProgress", info.progress)
		end
	else
		interior:SetAttribute("ChannelKind", nil)
		interior:SetAttribute("BreakoutProgress", 0)
		interior:SetAttribute("RescueProgress", 0)
	end
end

local function buildCells()
	cellsModel = Instance.new("Folder")
	cellsModel.Name = "Jails"
	cellsModel.Parent = Workspace

	local breakoutScale = script:GetAttribute("DebugBreakoutScale") or 1
	local rescueScale = script:GetAttribute("DebugRescueScale") or 1

	local color = Color3.fromRGB(255, 170, 120)

	local function addBox(model, name, position, size)
		local part = Instance.new("Part")
		part.Name = name
		part.Anchored = true
		part.CanCollide = true
		part.Size = size
		part.CFrame = CFrame.new(position)
		part.Color = color
		part.Material = Enum.Material.Concrete
		part.Parent = model
		return part
	end

	for _, layout in ipairs(CELL_LAYOUT) do
		local id = layout.id
		local center = layout.center
		local doorAxis = layout.doorAxis

		local model = Instance.new("Model")
		model.Name = "Cell_" .. id
		model.Parent = cellsModel

		addBox(model, "Floor", center - Vector3.new(0, 2.75, 0), Vector3.new(6, 0.5, 6))
		addBox(model, "Ceiling", center + Vector3.new(0, 2.75, 0), Vector3.new(6, 0.5, 6))
		addBox(model, "Back", center - doorAxis * 3, Vector3.new(0.5, 6, 6))
		addBox(model, "Front", center + doorAxis * 3, Vector3.new(0.5, 6, 6))
		addBox(model, "SideL", center - Vector3.new(0, 0, 3), Vector3.new(6, 6, 0.5))
		addBox(model, "SideR", center + Vector3.new(0, 0, 3), Vector3.new(6, 6, 0.5))

		local interior = Instance.new("Part")
		interior.Name = "Interior"
		interior.Anchored = true
		interior.CanCollide = false
		interior.Transparency = 1
		interior.Size = Vector3.new(4, 4, 4)
		interior.CFrame = CFrame.new(center)
		interior:SetAttribute("CellId", id)
		interior:SetAttribute("JailOccupantCount", 0)
		interior:SetAttribute("ChannelKind", nil)
		interior:SetAttribute("BreakoutProgress", 0)
		interior:SetAttribute("RescueProgress", 0)
		interior.Parent = model

		local exterior = Instance.new("Part")
		exterior.Name = "Exterior"
		exterior.Anchored = true
		exterior.CanCollide = false
		exterior.Transparency = 1
		exterior.Size = Vector3.new(3, 3, 3)
		exterior.CFrame = CFrame.new(center + doorAxis * 4.5)
		exterior.Parent = model

		cellMarkers[id] = interior
		JailState.registerCell(id, center, exterior.CFrame.Position, JailConfig.BreakoutSeconds * breakoutScale, JailConfig.RescueSeconds * rescueScale)
	end
end

local function layoutOf(id)
	for _, layout in ipairs(CELL_LAYOUT) do
		if layout.id == id then
			return layout
		end
	end
	return nil
end

local function doorPositionFor(cellId)
	local layout = layoutOf(cellId)
	if not layout then
		return nil
	end
	return layout.center + layout.doorAxis * 4.5
end

local function exteriorPosition(cellId)
	local layout = layoutOf(cellId)
	if not layout then
		return nil
	end
	return layout.center + layout.doorAxis * 5
end

local function insideCell(player, cellId)
	local interior = cellMarkers[cellId]
	local root = rootPartFor(player)
	if not interior or not root then
		return false
	end
	return (root.Position - interior.Position).Magnitude <= JailConfig.InteriorRange
end

local function nearExterior(player, cellId)
	local door = doorPositionFor(cellId)
	local root = rootPartFor(player)
	if not door or not root then
		return false
	end
	return (root.Position - door).Magnitude <= JailConfig.ExteriorRange
end

local function checkAllJailed()
	if phaseOf() ~= MatchState.PHASE.Live then
		return
	end
	local attackers = attackers()
	if #attackers == 0 then
		return
	end
	for _, player in ipairs(attackers) do
		if not JailState.isJailed(player) then
			return
		end
	end
	local outcome = ServerScriptService.MatchManager.MatchManager:WaitForChild("Events", 10):WaitForChild("RoundOutcomeReported", 10)
	outcome:Fire("Defenders", "all-jailed")
end

local function pickJailCell()
	local bestId
	local bestCount = math.huge
	for _, id in ipairs(JailState.cellIds()) do
		local count = JailState.occupantCount(id)
		if count < bestCount then
			bestCount = count
			bestId = id
		end
	end
	return bestId
end

local function jailPlayer(player, cellId)
	if not JailState.jailPlayer(player, cellId) then
		return false
	end
	JailState.cancelChannelFor(player)
	PlayerStateModule.setJailed(player, true)
	teleportTo(player, cellMarkers[cellId].Position)
	updateCellAttributes(cellId)
	playerJailed:Fire(player, cellId)
	if script:GetAttribute("DebugMode") ~= true then
		checkAllJailed()
	end
	return true
end

local function releasePlayer(player, cellId)
	JailState.releasePlayer(player)
	PlayerStateModule.setJailed(player, false)
	teleportTo(player, ((exteriorPosition(cellId) or player.Character.PrimaryPart.Position) + outwardOffset(0)))
	updateCellAttributes(cellId)
	playerReleased:Fire(player, cellId)
end

local function completeJailChannel(cellId, kind, player)
	local released = JailState.releaseAll(cellId)
	local isRescue = kind == "rescue"

	for index, occupant in ipairs(released) do
		PlayerStateModule.setJailed(occupant, false)
		teleportTo(occupant, (exteriorPosition(cellId) or Vector3.new(0, 10, 0)) + outwardOffset(index - 1))
		if isRescue then
			PlayerStateModule.grantSpeedBuff(occupant, JailConfig.BuffSeconds)
			PlayerStateModule.grantCaptureImmunity(occupant, JailConfig.BuffSeconds)
		end
		playerReleased:Fire(occupant, cellId)
	end

	if isRescue then
		PlayerStateModule.grantSpeedBuff(player, JailConfig.BuffSeconds)
		PlayerStateModule.grantCaptureImmunity(player, JailConfig.BuffSeconds)
	end

	jailReleasedAll:Fire(cellId, kind, isRescue)
	updateCellAttributes(cellId)
end

local function validateChannel(cellId, info)
	if phaseOf() ~= MatchState.PHASE.Live then
		return false
	end
	local player = info.player
	if not player.Parent then
		return false
	end
	if info.kind == "breakout" then
		if not JailState.isJailed(player) then
			return false
		end
		if not insideCell(player, cellId) then
			return false
		end
	elseif info.kind == "rescue" then
		if JailState.isJailed(player) then
			return false
		end
		if not nearExterior(player, cellId) then
			return false
		end
	end
	local root = rootPartFor(player)
	if info.startPos and root and (root.Position - info.startPos).Magnitude > JailConfig.MoveCancelRange then
		return false
	end
	return true
end

local function wireRemotes()
	local matchSystems = ReplicatedStorage:FindFirstChild("MatchSystems")
	if not matchSystems then
		matchSystems = Instance.new("Folder")
		matchSystems.Name = "MatchSystems"
		matchSystems.Parent = ReplicatedStorage
	end

	local requestCapture = Instance.new("RemoteEvent")
	requestCapture.Name = "RequestCapture"
	requestCapture.Parent = matchSystems

	local requestBreakoutHold = Instance.new("RemoteEvent")
	requestBreakoutHold.Name = "RequestBreakoutHold"
	requestBreakoutHold.Parent = matchSystems

	local requestBreakoutRelease = Instance.new("RemoteEvent")
	requestBreakoutRelease.Name = "RequestBreakoutRelease"
	requestBreakoutRelease.Parent = matchSystems

	local requestJailReset = Instance.new("RemoteEvent")
	requestJailReset.Name = "RequestJailReset"
	requestJailReset.Parent = matchSystems

	local requestRescue = Instance.new("RemoteEvent")
	requestRescue.Name = "RequestRescue"
	requestRescue.Parent = matchSystems

	local matchDebug = Instance.new("RemoteEvent")
	matchDebug.Name = "MatchDebug"
	matchDebug.Parent = matchSystems

	requestCapture.OnServerEvent:Connect(function(player, target)
		if phaseOf() ~= MatchState.PHASE.Live then
			return
		end
		if teamFor(player) ~= MatchState.TEAM.Defenders then
			return
		end
		if not target or target == player then
			return
		end
		if teamFor(target) ~= MatchState.TEAM.Attackers then
			return
		end
		if JailState.isJailed(target) or PlayerStateModule.hasCaptureImmunity(target) then
			return
		end
		if distanceBetween(player, target) > JailConfig.CaptureRange then
			return
		end
		local cellId = pickJailCell()
		jailPlayer(target, cellId)
	end)

	requestBreakoutHold.OnServerEvent:Connect(function(player, cellId)
		if phaseOf() ~= MatchState.PHASE.Live then
			return
		end
		if not JailState.isJailed(player) then
			return
		end
		if JailState.cellForPlayer(player) ~= cellId then
			return
		end
		if not insideCell(player, cellId) then
			return
		end
		local root = rootPartFor(player)
		JailState.startChannel(cellId, "breakout", player, root and root.Position or nil)
		updateCellAttributes(cellId)
	end)

	requestBreakoutRelease.OnServerEvent:Connect(function(player)
		if JailState.cancelChannelFor(player) then
			for _, cellId in ipairs(JailState.cellIds()) do
				updateCellAttributes(cellId)
			end
		end
	end)

	requestJailReset.OnServerEvent:Connect(function(player, cellId)
		if phaseOf() ~= MatchState.PHASE.Live then
			return
		end
		if teamFor(player) ~= MatchState.TEAM.Defenders then
			return
		end
		if not nearExterior(player, cellId) then
			return
		end
		if JailState.resetBreakout(cellId) then
			updateCellAttributes(cellId)
		end
	end)

	requestRescue.OnServerEvent:Connect(function(player, cellId)
		if phaseOf() ~= MatchState.PHASE.Live then
			return
		end
		if teamFor(player) ~= MatchState.TEAM.Attackers then
			return
		end
		if JailState.isJailed(player) then
			return
		end
		if not nearExterior(player, cellId) then
			return
		end
		local root = rootPartFor(player)
		JailState.startChannel(cellId, "rescue", player, root and root.Position or nil)
		updateCellAttributes(cellId)
	end)

	matchDebug.OnServerEvent:Connect(function(player, command, cellId)
		if script:GetAttribute("DebugMode") ~= true then
			return
		end
		if command == "jail" then
			local target = cellId or JailState.cellIds()[1]
			jailPlayer(player, target)
		elseif command == "release" then
			local myCell = JailState.cellForPlayer(player)
			if myCell then
				releasePlayer(player, myCell)
			end
		elseif command == "resetBreakout" then
			if JailState.resetBreakout(cellId) then
				updateCellAttributes(cellId)
			end
		end
	end)
end

local function wireMatchEvents()
	local events = ServerScriptService.MatchManager.MatchManager:WaitForChild("Events", 30)
	local phaseChanged = events:WaitForChild("PhaseChanged", 30)
	phaseChanged.Event:Connect(function(phase)
		if phase == MatchState.PHASE.Live then
			JailState.resetRound()
			for _, cellId in ipairs(JailState.cellIds()) do
				updateCellAttributes(cellId)
			end
		end
	end)
end

local function jailHeartbeat(dt)
	for _, cellId in ipairs(JailState.cellIds()) do
		local info = JailState.channelInfo(cellId)
		if not info then
			continue
		end
		if not validateChannel(cellId, info) then
			JailState.cancelChannel(cellId)
			updateCellAttributes(cellId)
			continue
		end
		local result = JailState.stepChannel(cellId, dt)
		if result and result.complete then
			completeJailChannel(cellId, result.kind, result.player)
		elseif result == nil then
			updateCellAttributes(cellId)
		else
			updateCellAttributes(cellId)
		end
	end
	for _, player in ipairs(Players:GetPlayers()) do
		if JailState.isJailed(player) then
			local character = player.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.WalkSpeed = 0
				humanoid.JumpPower = 0
			end
		end
	end
end

Players.PlayerRemoving:Connect(function(player)
	JailState.releasePlayer(player)
	JailState.cancelChannelFor(player)
	for _, cellId in ipairs(JailState.cellIds()) do
		updateCellAttributes(cellId)
	end
end)

buildCells()
wireRemotes()
wireMatchEvents()

RunService.Heartbeat:Connect(jailHeartbeat)