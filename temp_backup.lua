local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local ObjectiveConfig = require(script.Parent.ObjectiveConfig)
local ObjectiveState = require(script.Parent.ObjectiveState)
local MatchState = require(ServerScriptService.MatchManager.MatchState)
local PlayerStateModule = require(ServerScriptService.PlayerState.PlayerStateModule)

local SITE_LAYOUT = {
	{
		id = "A",
		center = Vector3.new(40, 4, -40),
	},
	{
		id = "B",
		center = Vector3.new(-40, 4, 40),
	},
}

local sitesModel
local siteMarkers = {}

local objectiveEvents = Instance.new("Folder")
objectiveEvents.Name = "ObjectiveEvents"
objectiveEvents.Parent = script

local plantCompleted = Instance.new("BindableEvent")
plantCompleted.Name = "PlantCompleted"
plantCompleted.Parent = objectiveEvents

local defuseCompleted = Instance.new("BindableEvent")
defuseCompleted.Name = "DefuseCompleted"
defuseCompleted.Parent = objectiveEvents

local detonated = Instance.new("BindableEvent")
detonated.Name = "Detonated"
detonated.Parent = objectiveEvents

local outcomeFiredThisTick = false

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

local function rootPartFor(player)
	local character = player.Character
	if not character then
		return nil
	end
	return character:FindFirstChild("HumanoidRootPart")
end

local function fireOutcome(winner, reason)
	if outcomeFiredThisTick then
		return
	end
	outcomeFiredThisTick = true
	local events = ServerScriptService.MatchManager.MatchManager:WaitForChild("Events", 10)
	local outcome = events:WaitForChild("RoundOutcomeReported", 10)
	outcome:Fire(winner, reason)
end

local function updateSiteAttributes(siteId)
	local interior = siteMarkers[siteId]
	if not interior then
		return
	end
	interior:SetAttribute("Planted", ObjectiveState.isPlanted(siteId))
	local info = ObjectiveState.channelInfo(siteId)
	if info then
		if info.kind == "plant" then
			interior:SetAttribute("ChannelKind", "plant")
			interior:SetAttribute("PlantProgress", info.progress)
			interior:SetAttribute("DefuseProgress", 0)
		else
			interior:SetAttribute("ChannelKind", "defuse")
			interior:SetAttribute("PlantProgress", 0)
			interior:SetAttribute("DefuseProgress", info.progress)
		end
	else
		interior:SetAttribute("ChannelKind", nil)
		interior:SetAttribute("PlantProgress", 0)
		interior:SetAttribute("DefuseProgress", 0)
	end
	interior:SetAttribute("DetonationRemaining", ObjectiveState.detonationRemainingOf(siteId))
end

local function buildSites()
	sitesModel = Instance.new("Folder")
	sitesModel.Name = "Sites"
	sitesModel.Parent = Workspace

	local plantScale = script:GetAttribute("DebugPlantScale") or 1
	local defuseScale = script:GetAttribute("DebugDefuseScale") or 1
	local detonationScale = script:GetAttribute("DebugDetonationScale") or 1

	local siteColor = Color3.fromRGB(90, 170, 220)

	for _, layout in ipairs(SITE_LAYOUT) do
		local id = layout.id
		local center = layout.center

		local model = Instance.new("Model")
		model.Name = "Site_" .. id
		model.Parent = sitesModel

		local pad = Instance.new("Part")
		pad.Name = "Pad"
		pad.Anchored = true
		pad.CanCollide = true
		pad.Size = Vector3.new(6, 0.5, 6)
		pad.CFrame = CFrame.new(center)
		pad.Color = siteColor
		pad.Material = Enum.Material.Slate
		pad.Parent = model

		local post = Instance.new("Part")
		post.Name = "Beacon"
		post.Anchored = true
		post.CanCollide = true
		post.Size = Vector3.new(0.5, 1.5, 0.5)
		post.CFrame = CFrame.new(center + Vector3.new(0, 1.25, 0))
		post.Color = siteColor
		post.Material = Enum.Material.SmoothPlastic
		post.Parent = model

		local interior = Instance.new("Part")
		interior.Name = "Interior"
		interior.Anchored = true
		interior.CanCollide = false
		interior.Transparency = 1
		interior.Size = Vector3.new(4, 4, 4)
		interior.CFrame = CFrame.new(center)
		interior:SetAttribute("SiteId", id)
		interior:SetAttribute("Planted", false)
		interior:SetAttribute("ChannelKind", nil)
		interior:SetAttribute("PlantProgress", 0)
		interior:SetAttribute("DefuseProgress", 0)
		interior:SetAttribute("DetonationRemaining", 0)
		interior.Parent = model

		siteMarkers[id] = interior
		ObjectiveState.registerSite(id, center, ObjectiveConfig.PlantSeconds * plantScale, ObjectiveConfig.DefuseSeconds * defuseScale, ObjectiveConfig.DetonationSeconds * detonationScale)
	end
end

local function validateChannel(siteId, info)
	if phaseOf() ~= MatchState.PHASE.Live then
		return false
	end
	local player = info.player
	if not player.Parent then
		return false
	end
	if PlayerStateModule.isJailed(player) then
		return false
	end
	if info.kind == "defuse" and not ObjectiveState.isPlanted(siteId) then
		return false
	end
	local center = ObjectiveState.siteCenter(siteId)
	local root = rootPartFor(player)
	if not center or not root then
		return false
	end
	if (Vector3.new(root.Position.X, 0, root.Position.Z) - Vector3.new(center.X, 0, center.Z)).Magnitude > ObjectiveConfig.SiteRange then
		return false
	end
	if info.startPos and (root.Position - info.startPos).Magnitude > ObjectiveConfig.MoveCancelRange then
		return false
	end
	return true
end

local function onChannelComplete(siteId, kind, player)
	if kind == "plant" then
		if ObjectiveState.markPlanted(siteId, player) then
			local state = MatchState.liveState()
			if state then
				MatchState.supersedeRoundTimer(state)
			end
			plantCompleted:Fire(player, siteId)
		end
	elseif kind == "defuse" then
		defuseCompleted:Fire(player, siteId)
		fireOutcome(MatchState.TEAM.Defenders, "defused")
	end
	updateSiteAttributes(siteId)
end

local function wireRemotes()
	local matchSystems = ReplicatedStorage:FindFirstChild("MatchSystems")
	if not matchSystems then
		matchSystems = Instance.new("Folder")
		matchSystems.Name = "MatchSystems"
		matchSystems.Parent = ReplicatedStorage
	end

	local requestPlantHold = Instance.new("RemoteEvent")
	requestPlantHold.Name = "RequestPlantHold"
	requestPlantHold.Parent = matchSystems

	local requestPlantRelease = Instance.new("RemoteEvent")
	requestPlantRelease.Name = "RequestPlantRelease"
	requestPlantRelease.Parent = matchSystems

	local requestDefuseHold = Instance.new("RemoteEvent")
	requestDefuseHold.Name = "RequestDefuseHold"
	requestDefuseHold.Parent = matchSystems

	local requestDefuseRelease = Instance.new("RemoteEvent")
	requestDefuseRelease.Name = "RequestDefuseRelease"
	requestDefuseRelease.Parent = matchSystems

	local matchDebug = Instance.new("RemoteEvent")
	matchDebug.Name = "ObjectiveDebug"
	matchDebug.Parent = matchSystems

	requestPlantHold.OnServerEvent:Connect(function(player, siteId)
		if phaseOf() ~= MatchState.PHASE.Live then
			return
		end
		if teamFor(player) ~= MatchState.TEAM.Attackers then
			return
		end
		if PlayerStateModule.isJailed(player) then
			return
		end
		if not siteId or not ObjectiveState.hasSite(siteId) then
			return
		end
		if ObjectiveState.plantedSite() then
			return
		end
		local root = rootPartFor(player)
		if not root then
			return
		end
		local center = ObjectiveState.siteCenter(siteId)
		if (Vector3.new(root.Position.X, 0, root.Position.Z) - Vector3.new(center.X, 0, center.Z)).Magnitude > ObjectiveConfig.SiteRange then
			return
		end
		ObjectiveState.startChannel(siteId, "plant", player, root.Position)
		updateSiteAttributes(siteId)
	end)

	requestPlantRelease.OnServerEvent:Connect(function(player)
		if ObjectiveState.cancelChannelFor(player) then
			for _, siteId in ipairs(ObjectiveState.siteIds()) do
				updateSiteAttributes(siteId)
			end
		end
	end)

	requestDefuseHold.OnServerEvent:Connect(function(player, siteId)
		if phaseOf() ~= MatchState.PHASE.Live then
			return
		end
		if teamFor(player) ~= MatchState.TEAM.Defenders then
			return
		end
		if PlayerStateModule.isJailed(player) then
			return
		end
		if not siteId or not ObjectiveState.hasSite(siteId) then
			return
		end
		if not ObjectiveState.isPlanted(siteId) then
			return
		end
		local root = rootPartFor(player)
		if not root then
			return
		end
		local center = ObjectiveState.siteCenter(siteId)
		if (Vector3.new(root.Position.X, 0, root.Position.Z) - Vector3.new(center.X, 0, center.Z)).Magnitude > ObjectiveConfig.SiteRange then
			return
		end
		ObjectiveState.startChannel(siteId, "defuse", player, root.Position)
		updateSiteAttributes(siteId)
	end)

	requestDefuseRelease.OnServerEvent:Connect(function(player)
		if ObjectiveState.cancelChannelFor(player) then
			for _, siteId in ipairs(ObjectiveState.siteIds()) do
				updateSiteAttributes(siteId)
			end
		end
	end)

	matchDebug.OnServerEvent:Connect(function(player, command, siteId)
		if script:GetAttribute("DebugMode") ~= true then
			return
		end
		if command == "plant" then
			local id = siteId or ObjectiveState.siteIds()[1]
			if phaseOf() == MatchState.PHASE.Live and ObjectiveState.hasSite(id) and not ObjectiveState.isPlanted(id) then
				if ObjectiveState.markPlanted(id, player) then
					local state = MatchState.liveState()
					if state then
						MatchState.supersedeRoundTimer(state)
					end
					plantCompleted:Fire(player, id)
				end
			end
		elseif command == "defuse" then
			local id = siteId or ObjectiveState.siteIds()[1]
			if phaseOf() == MatchState.PHASE.Live and ObjectiveState.hasSite(id) and ObjectiveState.isPlanted(id) and not PlayerStateModule.isJailed(player) then
				local root = rootPartFor(player)
				if root then
					ObjectiveState.startChannel(id, "defuse", player, root.Position)
				end
			end
		elseif command == "reset" then
			ObjectiveState.resetRound()
		end
		for _, sid in ipairs(ObjectiveState.siteIds()) do
			updateSiteAttributes(sid)
		end
	end)
end

local function wireMatchEvents()
	local events = ServerScriptService.MatchManager.MatchManager:WaitForChild("Events", 30)
	local phaseChanged = events:WaitForChild("PhaseChanged", 30)
	phaseChanged.Event:Connect(function(phase)
		if phase == MatchState.PHASE.Live then
			ObjectiveState.resetRound()
			for _, siteId in ipairs(ObjectiveState.siteIds()) do
				updateSiteAttributes(siteId)
			end
		end
	end)
end

local function objectiveHeartbeat(dt)
	outcomeFiredThisTick = false
	if phaseOf() ~= MatchState.PHASE.Live then
		return
	end
	for _, siteId in ipairs(ObjectiveState.siteIds()) do
		local info = ObjectiveState.channelInfo(siteId)
		if info then
			if not validateChannel(siteId, info) then
				ObjectiveState.cancelChannel(siteId)
				updateSiteAttributes(siteId)
				continue
			end
			local result = ObjectiveState.stepChannel(siteId, dt)
			if result and result.complete then
				onChannelComplete(siteId, result.kind, result.player)
			else
				updateSiteAttributes(siteId)
			end
		end
	end
	local planted = ObjectiveState.plantedSite()
	if planted then
		if ObjectiveState.stepDetonation(dt) then
			detonated:Fire(planted.id)
			fireOutcome(MatchState.TEAM.Attackers, "detonation")
		end
		updateSiteAttributes(planted.id)
	end
end

Players.PlayerRemoving:Connect(function(player)
	ObjectiveState.cancelChannelFor(player)
	for _, siteId in ipairs(ObjectiveState.siteIds()) do
		updateSiteAttributes(siteId)
	end
end)

buildSites()
wireRemotes()
wireMatchEvents()

RunService.Heartbeat:Connect(objectiveHeartbeat)