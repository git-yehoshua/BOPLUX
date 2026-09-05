local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local JailState = require(ServerScriptService.JailSystem.JailState)
local MatchState = require(ServerScriptService.MatchManager.MatchState)
local ObjectiveState = require(ServerScriptService.ObjectiveSystem.ObjectiveState)
local SabotageConfig = require(script.Parent.SabotageConfig)
local SabotageState = require(script.Parent.SabotageState)

local state = SabotageState.new()
local requestSabotage

local function phaseOf()
	local live = MatchState.liveState()
	if not live then
		return nil
	end
	return MatchState.phaseOf(live)
end

local function teamFor(player)
	local live = MatchState.liveState()
	if not live then
		return nil
	end
	return MatchState.teamFor(live, player)
end

local function rootPartFor(player)
	local character = player.Character
	if not character then
		return nil
	end
	return character:FindFirstChild("HumanoidRootPart")
end

local function impostorUserId()
	local runner = ServerScriptService:FindFirstChild("ImpostorSystem")
	if not runner then
		return nil
	end
	runner = runner:FindFirstChild("RunImpostorSystem")
	if not runner then
		return nil
	end
	return runner:GetAttribute("CurrentImpostorUserId")
end

local function impostorTeam()
	local runner = ServerScriptService:FindFirstChild("ImpostorSystem")
	if not runner then
		return nil
	end
	runner = runner:FindFirstChild("RunImpostorSystem")
	if not runner then
		return nil
	end
	return runner:GetAttribute("CurrentImpostorTeam")
end

local function fireTell(worldPosition)
	local audioRunner = ServerScriptService:FindFirstChild("AudioSystem")
	if not audioRunner then
		return
	end
	audioRunner = audioRunner:FindFirstChild("RunAudioSystem")
	if not audioRunner then
		return
	end
	local audioEvents = audioRunner:FindFirstChild("AudioEvents")
	if not audioEvents then
		return
	end
	local tellRequested = audioEvents:FindFirstChild("ImpostorTellRequested")
	if not tellRequested then
		return
	end
	tellRequested:Fire(worldPosition, SabotageConfig.TellRadius)
end

local function collectJailExteriors()
	local exteriors = {}
	local jails = Workspace:FindFirstChild("Jails")
	if not jails then
		return exteriors
	end
	for _, cell in ipairs(jails:GetChildren()) do
		local exterior = cell:FindFirstChild("Exterior")
		if exterior then
			local cellId = cell.Name:gsub("^Cell_", "")
			table.insert(exteriors, {
				id = cellId,
				position = exterior.Position,
			})
		end
	end
	return exteriors
end

local function collectSiteCenters()
	local centers = {}
	local sites = Workspace:FindFirstChild("Sites")
	if not sites then
		return centers
	end
	for _, site in ipairs(sites:GetChildren()) do
		local interior = site:FindFirstChild("Interior")
		if interior then
			local siteId = interior:GetAttribute("SiteId")
			if siteId then
				table.insert(centers, {
					id = tostring(siteId),
					position = interior.Position,
				})
			end
		end
	end
	return centers
end

local function hasActiveBreakout(cellId)
	local info = JailState.channelInfo(cellId)
	return info and info.kind == "breakout"
end

local function hasActiveChannelAtSite(siteId)
	local info = ObjectiveState.channelInfo(siteId)
	return info ~= nil
end

local function isTeammateChannelAtSite(siteId, myTeam)
	local info = ObjectiveState.channelInfo(siteId)
	if not info then
		return false
	end
	local channelTeam = teamFor(info.player)
	return channelTeam == myTeam
end

local function executeSabotage(player, context)
	local root = rootPartFor(player)
	if not root then
		return false
	end
	local position = root.Position

	if context.kind == "jail" then
		if not hasActiveBreakout(context.id) then
			return false
		end
		if JailState.resetBreakout(context.id) then
			fireTell(position)
			SabotageState.recordCooldown(state, os.clock(), SabotageConfig.SabotageCooldown)
			return true
		end
		return false
	elseif context.kind == "site" then
		local myTeam = impostorTeam()
		if not isTeammateChannelAtSite(context.id, myTeam) then
			return false
		end
		if ObjectiveState.cancelChannel(context.id) then
			fireTell(position)
			SabotageState.recordCooldown(state, os.clock(), SabotageConfig.SabotageCooldown)
			return true
		end
		return false
	end

	return false
end

local function handleRequest(player)
	if phaseOf() ~= MatchState.PHASE.Live then
		return
	end

	if impostorUserId() ~= player.UserId then
		return
	end

	if not SabotageState.validateCooldown(state, os.clock()) then
		return
	end

	local root = rootPartFor(player)
	if not root then
		return
	end

	local context = SabotageState.determineContext(
		root.Position,
		collectJailExteriors(),
		collectSiteCenters(),
		SabotageConfig.SabotageRange
	)

	if not context then
		return
	end

	executeSabotage(player, context)
end

local function handleDebug(player, command, arg)
	if script:GetAttribute("DebugMode") ~= true then
		return
	end
	if command == "execute" then
		if impostorUserId() ~= player.UserId then
			return
		end
		local root = rootPartFor(player)
		if not root then
			return
		end
		local context = SabotageState.determineContext(
			root.Position,
			collectJailExteriors(),
			collectSiteCenters(),
			SabotageConfig.SabotageRange
		)
		if context then
			executeSabotage(player, context)
		end
	elseif command == "resetCooldown" then
		SabotageState.resetRound(state)
	elseif command == "setCooldown" then
		SabotageState.recordCooldown(state, os.clock(), arg or SabotageConfig.SabotageCooldown)
	end
end

local function wireRemotes()
	local matchSystems = ReplicatedStorage:FindFirstChild("MatchSystems")
	if not matchSystems then
		matchSystems = Instance.new("Folder")
		matchSystems.Name = "MatchSystems"
		matchSystems.Parent = ReplicatedStorage
	end

	requestSabotage = Instance.new("RemoteEvent")
	requestSabotage.Name = "RequestSabotage"
	requestSabotage.Parent = matchSystems

	requestSabotage.OnServerEvent:Connect(handleRequest)

	local sabotageDebug = Instance.new("RemoteEvent")
	sabotageDebug.Name = "SabotageDebug"
	sabotageDebug.Parent = matchSystems

	sabotageDebug.OnServerEvent:Connect(handleDebug)
end

local function wireMatchEvents()
	local events = ServerScriptService.MatchManager.MatchManager:WaitForChild("Events", 30)
	local phaseChanged = events:WaitForChild("PhaseChanged", 30)
	phaseChanged.Event:Connect(function(phase)
		if phase == MatchState.PHASE.Live then
			SabotageState.resetRound(state)
		end
	end)
end

wireRemotes()
wireMatchEvents()
