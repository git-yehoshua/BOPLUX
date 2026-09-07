-- PassEvidenceCollector: mirrors main-VM game state into shared instance state so
-- verification probes (which run in isolated VMs) can read live module state during
-- the multi-player verification pass. Passive: never mutates gameplay state.
-- Camping fill is read from the CampingMeterFill attribute the camping meter
-- runner already publishes on each jail Interior (HUD Phase 1 surface).
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local MatchState = require(ServerScriptService.MatchManager.MatchState)
local JailState = require(ServerScriptService.JailSystem.JailState)
local ObjectiveState = require(ServerScriptService.ObjectiveSystem.ObjectiveState)
local Workspace = game:GetService("Workspace")

local lastTell = "none"

local evidenceValue = Instance.new("StringValue")
evidenceValue.Name = "PassEvidence"
evidenceValue.Value = "booting"
evidenceValue.Parent = script

local lastTellValue = Instance.new("StringValue")
lastTellValue.Name = "LastTell"
lastTellValue.Value = lastTell
lastTellValue.Parent = script

local audioRunner = ServerScriptService:FindFirstChild("AudioSystem")
if audioRunner then
	local runAudio = audioRunner:FindFirstChild("RunAudioSystem")
	local audioEvents = runAudio and runAudio:FindFirstChild("AudioEvents")
	local tellRequested = audioEvents and audioEvents:FindFirstChild("ImpostorTellRequested")
	if tellRequested then
		tellRequested.Event:Connect(function(worldPosition)
			lastTell = string.format("t=%.1f pos=%s", os.clock(), tostring(worldPosition))
			lastTellValue.Value = lastTell
		end)
	end
end

local function posOf(player)
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	return root and string.format("(%.1f,%.1f,%.1f)", root.Position.X, root.Position.Y, root.Position.Z) or "no-char"
end

local function campingFillFor(cellId)
	local jails = Workspace:FindFirstChild("Jails")
	if not jails then return "n/a" end
	local cell = jails:FindFirstChild("Cell_" .. cellId)
	local interior = cell and cell:FindFirstChild("Interior")
	local fill = interior and interior:GetAttribute("CampingMeterFill")
	return fill and string.format("%.2f", fill) or "n/a"
end

local function buildSnapshot()
	local parts = {}
	local live = MatchState.liveState()
	if live then
		table.insert(parts, string.format("phase=%s round=%s", tostring(MatchState.phaseOf(live)), tostring(MatchState.roundOf(live))))
	else
		table.insert(parts, "phase=idle")
	end

	for _, player in ipairs(Players:GetPlayers()) do
		local team = live and MatchState.teamFor(live, player) or "?"
		table.insert(parts, string.format("P:%s team=%s jailed=%s pos=%s", player.Name, tostring(team), tostring(JailState.isJailed(player)), posOf(player)))
	end

	for _, cellId in ipairs(JailState.cellIds()) do
		local info = JailState.channelInfo(cellId)
		table.insert(parts, string.format(
			"Jail%s occupants=%d channel=%s progress=%s campFill=%s",
			cellId,
			JailState.occupantCount(cellId),
			tostring(info and info.kind or "none"),
			info and string.format("%.2f", info.progress) or "-",
			campingFillFor(cellId)
		))
	end

	for _, siteId in ipairs(ObjectiveState.siteIds()) do
		local info = ObjectiveState.channelInfo(siteId)
		table.insert(parts, string.format(
			"Site%s planted=%s channel=%s det=%s",
			siteId,
			tostring(ObjectiveState.isPlanted(siteId)),
			tostring(info and info.kind or "none"),
			string.format("%.1f", ObjectiveState.detonationRemainingOf(siteId))
		))
	end

	return table.concat(parts, " | ")
end

RunService.Heartbeat:Connect(function()
	evidenceValue.Value = buildSnapshot()
end)

-- Console stream: the multi-player test spawns server/client windows the MCP bridge
-- cannot attach to; a periodic one-line print is the evidence channel for those windows.
local lastStream = 0
RunService.Heartbeat:Connect(function()
	if os.clock() - lastStream >= 5 then
		lastStream = os.clock()
		print("[PassEvidence] " .. buildSnapshot())
	end
end)

print("[PassEvidenceCollector] Running - evidence mirrors to script.PassEvidence")
