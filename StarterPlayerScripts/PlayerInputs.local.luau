-- PlayerInputs: client input bindings for gameplay remotes (the game previously had
-- zero client input bindings — servers validated requests nobody could send).
-- Binds: LMB capture | RMB jail-reset | E rescue/defuse (hold) | F breakout (hold) |
-- Shift sprint. Every fire is a request; the server validates team, range, and state
-- and rejects invalid ones silently.
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local matchSystems = ReplicatedStorage:WaitForChild("MatchSystems", 30)
if not matchSystems then
	warn("[PlayerInputs] MatchSystems not found")
	return
end

local requestCapture = matchSystems:WaitForChild("RequestCapture", 10)
local requestJailReset = matchSystems:WaitForChild("RequestJailReset", 10)
local requestRescue = matchSystems:WaitForChild("RequestRescue", 10)
local requestPlantHold = matchSystems:WaitForChild("RequestPlantHold", 10)
local requestPlantRelease = matchSystems:WaitForChild("RequestPlantRelease", 10)
local requestDefuseHold = matchSystems:WaitForChild("RequestDefuseHold", 10)
local requestDefuseRelease = matchSystems:WaitForChild("RequestDefuseRelease", 10)
local requestBreakoutHold = matchSystems:WaitForChild("RequestBreakoutHold", 10)
local requestBreakoutRelease = matchSystems:WaitForChild("RequestBreakoutRelease", 10)
local requestSprint = matchSystems:WaitForChild("RequestSprint", 10)
local requestSabotage = matchSystems:FindFirstChild("RequestSabotage")

local E = Enum.KeyCode.E
local F = Enum.KeyCode.F

local function nearestMarkerId(folderName)
	-- nearest Jail/Site interior id; server re-validates exact range/team/state
	local myChar = player.Character
	local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
	if not myRoot then return nil end
	local folder = Workspace:FindFirstChild(folderName)
	if not folder then return nil end
	local best, bestDist = nil, math.huge
	for _, model in ipairs(folder:GetChildren()) do
		local interior = model:FindFirstChild("Interior")
		if interior then
			local d = (interior.Position - myRoot.Position).Magnitude
			if d < bestDist then
				bestDist = d
				best = interior:GetAttribute("SiteId") or interior:GetAttribute("CellId")
			end
		end
	end
	return best
end

local function nearestTargetPlayer()
	local myChar = player.Character
	local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
	if not myRoot then return nil end
	local best, bestDist = nil, math.huge
	for _, other in ipairs(Players:GetPlayers()) do
		if other ~= player then
			local root = other.Character and other.Character:FindFirstChild("HumanoidRootPart")
			if root then
				local d = (root.Position - myRoot.Position).Magnitude
				if d < bestDist then
					bestDist = d
					best = other
				end
			end
		end
	end
	return best
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local target = nearestTargetPlayer()
		if target then
			requestCapture:FireServer(target)
		end
		local siteId = nearestMarkerId("Sites")
		if siteId then
			requestPlantHold:FireServer(siteId)
		end
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		local cellId = nearestMarkerId("Jails")
		if cellId then
			requestJailReset:FireServer(cellId)
		end
	elseif input.KeyCode == E then
		-- Attacker near a jail: rescue (3s channel, completes while stationary).
		-- Defender near a planted site: defuse hold. Server rejects the invalid one.
		local jailId = nearestMarkerId("Jails")
		if jailId then
			requestRescue:FireServer(jailId)
		end
		local siteId = nearestMarkerId("Sites")
		if siteId then
			requestDefuseHold:FireServer(siteId)
		end
	elseif input.KeyCode == F then
		-- Jailed player: breakout hold. Impostor near a target: sabotage. Server rejects invalid.
		local jailId = nearestMarkerId("Jails")
		if jailId then
			requestBreakoutHold:FireServer(jailId)
		end
		if requestSabotage then
			requestSabotage:FireServer()
		end
	elseif input.KeyCode == Enum.KeyCode.LeftShift then
		requestSprint:FireServer(true)
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		requestPlantRelease:FireServer()
	elseif input.KeyCode == E then
		requestDefuseRelease:FireServer()
	elseif input.KeyCode == F then
		requestBreakoutRelease:FireServer()
	elseif input.KeyCode == Enum.KeyCode.LeftShift then
		requestSprint:FireServer(false)
	end
end)

print("[PlayerInputs] Bound: LMB capture/plant-hold | RMB jail-reset | E rescue/defuse-hold | F breakout-hold/sabotage | Shift sprint")
