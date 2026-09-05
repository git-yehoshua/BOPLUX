local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ImpostorClientGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local label = Instance.new("TextLabel")
label.Name = "StatusLabel"
label.Size = UDim2.new(0, 520, 0, 36)
label.Position = UDim2.new(0.5, -260, 0, 24)
label.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 20
label.Font = Enum.Font.SourceSansBold
label.Text = ""
label.Parent = screenGui

local function say(text)
	label.BackgroundTransparency = 0.35
	label.Text = text
	print(text)
	task.delay(6, function()
		if label.Text == text then
			label.Text = ""
			label.BackgroundTransparency = 1
		end
	end)
end

local matchSystems = ReplicatedStorage:WaitForChild("MatchSystems", 30)
if matchSystems then
	local warning = matchSystems:WaitForChild("ImpostorWarning", 10)
	if warning then
		warning.OnClientEvent:Connect(function(payload)
			if payload and payload.text then
				say("[Warning] " .. payload.text)
			end
		end)
	end

	local role = matchSystems:WaitForChild("ImpostorRole", 10)
	if role then
		role.OnClientEvent:Connect(function(payload)
			if payload and payload.objective then
				say("[Secret Objective] " .. tostring(payload.objective.text))
			end
		end)
	end

	local reveal = matchSystems:WaitForChild("ImpostorReveal", 10)
	if reveal then
		reveal.OnClientEvent:Connect(function(payload)
			if not payload then
				return
			end
			if not payload.userId then
				say("[Round Over] No Impostor was active this round.")
			else
				local outcome = payload.impostorWon and " - the Impostor won!" or " - the Impostor lost."
				say("[Round Over] " .. tostring(payload.displayName) .. " was the Impostor" .. outcome)
			end
		end)
	end
end