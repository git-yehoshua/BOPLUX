local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local JailCampingMeter = require(ServerScriptService.JailCampingMeter.JailCampingMeter)
local JailCampingMeterConfig = require(ServerScriptService.JailCampingMeter.JailCampingMeterConfig)
local JailState = require(ServerScriptService.JailSystem.JailState)
local MatchState = require(ServerScriptService.MatchManager.MatchState)
local PlayerState = require(ServerScriptService.PlayerState.PlayerStateModule)
local ImpostorState = require(ServerScriptService.ImpostorSystem.ImpostorState)

local state = JailCampingMeter.new()
local campingDefenders = {}

local function initJails()
	for _, cellId in ipairs(JailState.cellIds()) do
		if not state.jails[cellId] then
			JailCampingMeter.newJail(state, cellId)
		end
	end
end

local function getJailExterior(cellId)
	return JailState.exteriorFor(cellId)
end

local function getCharPosition(player)
	local char = player.Character
	if not char then return nil end
	local root = char:FindFirstChild("HumanoidRootPart")
	return root and root.Position
end

local function isImpostor(player)
	return ImpostorState.current and ImpostorState.current.userId == player.UserId
end

-- A camper is a DEFENDER (finding #6: the meter previously accepted ANY non-impostor
-- player - including the jailed Attackers standing INSIDE the cell, who could then
-- trigger their own self-rescue and bypass the 45s breakout entirely).
local function isCamper(player)
	if isImpostor(player) then
		return false
	end
	if JailState.isJailed(player) then
		return false
	end
	local live = MatchState.liveState()
	local team = live and MatchState.teamFor(live, player)
	return team == MatchState.TEAM.Defenders
end

local function dist3(a, b)
	if not a or not b then return math.huge end
	local dx, dy, dz = a.X - b.X, a.Y - b.Y, a.Z - b.Z
	return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function getMockJailState()
	return {
		cellIds = JailState.cellIds,
		channelInfo = JailState.channelInfo,
		releasePlayer = function(player)
			JailState.releasePlayer(player)
		end,
	}
end

local function setMeterAttribute(cellId, fill)
	local jailsFolder = Workspace:FindFirstChild("Jails")
	if not jailsFolder then return end
	-- JailState cell ids are "A"/"B"; map models are named "Cell_A"/"Cell_B"
	local cell = jailsFolder:FindFirstChild("Cell_" .. cellId)
	if not cell then return end
	local interior = cell:FindFirstChild("Interior")
	if interior then
		interior:SetAttribute("CampingMeterFill", fill)
	end
end

local function onHeartbeat()
	local now = os.clock()
	initJails()

	for _, cellId in ipairs(JailState.cellIds()) do
		if JailState.occupantCount(cellId) == 0 then
			if campingDefenders[cellId] then
				campingDefenders[cellId] = nil
				JailCampingMeter.update(state, nil, cellId, now)
				setMeterAttribute(cellId, 0)
			end
		else
			local ext = getJailExterior(cellId)
			if ext then
				local closestDefender = nil
				local closestDist = math.huge
				for _, player in ipairs(Players:GetPlayers()) do
					if isCamper(player) then
						local pos = getCharPosition(player)
						if pos then
							local d = dist3(pos, ext)
							if d <= JailCampingMeterConfig.ProximityRadius and d < closestDist then
								closestDefender = player.UserId
								closestDist = d
							end
						end
					end
				end
				if closestDefender then
					campingDefenders[cellId] = closestDefender
					JailCampingMeter.update(state, closestDefender, cellId, now)
					setMeterAttribute(cellId, JailCampingMeter.getMeter(state, cellId, now))
					if JailCampingMeter.isFull(state, cellId, now) then
						JailCampingMeter.selfRescue(state, cellId, getMockJailState(), PlayerState)
					end
				else
					campingDefenders[cellId] = nil
					JailCampingMeter.update(state, nil, cellId, now)
					setMeterAttribute(cellId, 0)
				end
			end
		end
	end
end

initJails()
RunService.Heartbeat:Connect(onHeartbeat)
Players.PlayerAdded:Connect(function() task.defer(initJails) end)

print("[JailCampingMeter] Running — radius=" .. JailCampingMeterConfig.ProximityRadius .. "m grace=" .. JailCampingMeterConfig.GracePeriod .. "s fill=" .. JailCampingMeterConfig.FillTime .. "s")
