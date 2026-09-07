-- Test Bot Script for Jail System
-- Spawns two test characters with Humanoids and tests capture/jail mechanics

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Load jail system from ServerScriptService
local jailDir = game:GetService("ServerScriptService"):WaitForChild("JailSystem")
local JailConfig = require(jailDir:WaitForChild("JailConfig"))
local JailState = require(jailDir:WaitForChild("JailState"))

-- Create Attacker bot with capture ability
local function createAttackerBot()
	local botName = "TestAttacker"
	local character = Instance.new("Model")
	character.Name = botName
	
	-- Create HumanoidRootPart
	local hrp = Instance.new("Part")
	hrp.Name = "HumanoidRootPart"
	hrp.Anchored = false
	hrp.CanCollide = true
	hrp.Size = Vector3.new(2, 2, 1)
	hrp.Position = Vector3.new(20, 5, 18)
	hrp.Parent = character
	
	-- Create Humanoid
	local humanoid = Instance.new("Humanoid")
	humanoid.Name = "Humanoid"
	humanoid.Health = 100
	humanoid.MaxHealth = 100
	humanoid.WalkSpeed = 16
	humanoid.JumpPower = 50
	humanoid.Parent = character
	
	character:PivotTo(CFrame.new(hrp.Position))
	character.Parent = Workspace
	
	print(string.format("[%s] Bot spawned at %.1f, %.1f, %.1f", botName, hrp.Position.x, hrp.Position.y, hrp.Position.z))
	
	-- Attempt capture at Jail A (within 1.5m)
	local function attemptCapture()
		local currentRoot = character:FindFirstChild("HumanoidRootPart")
		if not currentRoot then return end
		
		local targetCenter = Vector3.new(24, 8, 20)
		local distanceToJail = (currentRoot.Position - targetCenter).Magnitude
		
		print(string.format("[%s] Attempting capture at Jail A - Distance: %.2f (range: %.1f)", botName, distanceToJail, JailConfig.CaptureRange))
		
		if distanceToJail <= JailConfig.CaptureRange then
			print(string.format("[%s] Within capture range at Jail A! Attempting to jail...", botName))
			
			local matchSystems = ReplicatedStorage:FindFirstChild("MatchSystems")
			if matchSystems then
				local requestCapture = matchSystems:FindFirstChild("RequestCapture")
				if requestCapture then
					local player = Players:GetPlayerFromCharacter(character)
					if player then
						requestCapture:FireServer(player, nil)
						print(string.format("[%s] Fired RequestCapture for player: %s", botName, player.Name))
					else
						print(string.format("[%s] No player found, attempting direct jail", botName))
						JailState.jailPlayer(character, "A")
					end
				end
			else
				print(string.format("[%s] No MatchSystems, attempting direct jail", botName))
				JailState.jailPlayer(character, "A")
			end
		else
			print(string.format("[%s] Moving towards Jail A (%.1f studs away)", botName, distanceToJail))
			humanoid:MoveTo(targetCenter)
			task.wait(3)
			local newRoot = character:FindFirstChild("HumanoidRootPart")
			if newRoot then
				local newDistance = (newRoot.Position - targetCenter).Magnitude
				print(string.format("[%s] After movement - Distance: %.1f studs", botName, newDistance))
			end
		end
	end
	
	-- Print status every 3 seconds
	local function printStatus()
		local lastPrint = tick()
		while character.Parent do
			RunService.Heartbeat:Wait()
			local currentTick = tick()
			if currentTick - lastPrint >= 3 then
				lastPrint = currentTick
				local root = character:FindFirstChild("HumanoidRootPart")
				if root then
					local target = Vector3.new(24, 8, 20)
					local distance = (root.Position - target).Magnitude
					print(string.format("[%s] Status: %.1f studs from Jail A, Health: %.0f/100", botName, distance, humanoid.Health))
				end
			end
		end
	end
	
	coroutine.wrap(printStatus)()
	task.delay(10, function()
		print(string.format("[%s] Test complete - destroying character after 10 seconds", botName))
		character:Destroy()
	end)
	
	task.wait(0.5)
	attemptCapture()
	
	return character
end

-- Create Defender bot with jail exterior reset ability
local function createDefenderBot()
	local botName = "TestDefender"
	local character = Instance.new("Model")
	character.Name = botName
	
	local hrp = Instance.new("Part")
	hrp.Name = "HumanoidRootPart"
	hrp.Anchored = false
	hrp.CanCollide = true
	hrp.Size = Vector3.new(2, 2, 1)
	hrp.Position = Vector3.new(28, 5, 20)
	hrp.Parent = character
	
	local humanoid = Instance.new("Humanoid")
	humanoid.Name = "Humanoid"
	humanoid.Health = 100
	humanoid.MaxHealth = 100
	humanoid.WalkSpeed = 16
	humanoid.JumpPower = 50
	humanoid.Parent = character
	
	character:PivotTo(CFrame.new(hrp.Position))
	character.Parent = Workspace
	
	print(string.format("[%s] Bot spawned at %.1f, %.1f, %.1f", botName, hrp.Position.x, hrp.Position.y, hrp.Position.z))
	
	-- Attempt jail exterior reset
	local function attemptJailReset()
		local currentRoot = character:FindFirstChild("HumanoidRootPart")
		if not currentRoot then return end
		
		local exteriorPos = Vector3.new(24 + 4.5, 8, 20)
		local distanceToExterior = (currentRoot.Position - exteriorPos).Magnitude
		
		print(string.format("[%s] Checking jail exterior reset - Distance: %.2f (range: %.1f)", botName, distanceToExterior, JailConfig.ExteriorRange))
		
		if distanceToExterior <= JailConfig.ExteriorRange then
			print(string.format("[%s] At Jail A exterior! Attempting reset...", botName))
			
			local matchSystems = ReplicatedStorage:FindFirstChild("MatchSystems")
			if matchSystems then
				local requestJailReset = matchSystems:FindFirstChild("RequestJailReset")
				if requestJailReset then
					local player = Players:GetPlayerFromCharacter(character)
					if player then
						requestJailReset:FireServer(player, "A")
						print(string.format("[%s] Fired RequestJailReset for Cell A!", botName))
					end
				end
			end
		else
			print(string.format("[%s] Moving towards Jail A exterior (%.1f studs away)", botName, distanceToExterior))
			humanoid:MoveTo(exteriorPos)
		end
	end
	
	local function printStatus()
		local lastPrint = tick()
		while character.Parent do
			RunService.Heartbeat:Wait()
			local currentTick = tick()
			if currentTick - lastPrint >= 3 then
				lastPrint = currentTick
				local root = character:FindFirstChild("HumanoidRootPart")
				if root then
					local exterior = Vector3.new(24 + 4.5, 8, 20)
					local distToExt = (root.Position - exterior).Magnitude
					print(string.format("[%s] Status: %.1f studs from Jail A exterior, Health: %.0f/100", botName, distToExt, humanoid.Health))
				end
			end
		end
	end
	
	coroutine.wrap(printStatus)()
	task.delay(10, function()
		print(string.format("[%s] Test complete - destroying character after 10 seconds", botName))
		character:Destroy()
	end)
	
	task.wait(0.5)
	attemptJailReset()
	
	return character
end

-- Main
print("=== Spawning Test Bots ===")
local attacker = createAttackerBot()
local defender = createDefenderBot()
print("=== Test Complete ===")