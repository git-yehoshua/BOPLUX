local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local function playCue(payload)
	if not payload or not payload.Position then
		return
	end
	local sound = Instance.new("Sound")
	sound.SoundId = payload.SoundId or "rbxasset://sounds/electronicpingshort.wav"
	sound.Volume = 1
	sound.RollOffMaxDistance = 100
	sound.RollOffMode = Enum.RollOffMode.InverseTapered
	sound.DopplerMode = Enum.DopplerMode.Off
	sound.EmitterSize = 1

	local attachment = Instance.new("Part")
	attachment.Name = "SoundAttachment"
	attachment.Size = Vector3.new(0.5, 0.5, 0.5)
	attachment.Position = payload.Position
	attachment.Anchored = true
	attachment.CanCollide = false
	attachment.Transparency = 1
	attachment.Parent = Workspace

	sound.Parent = attachment
	sound:Play()

	task.delay(5, function()
		if sound.Parent then
			sound:Destroy()
		end
		if attachment.Parent then
			attachment:Destroy()
		end
	end)
end

local function wire()
	local breakoutWarning = ReplicatedStorage:FindFirstChild("PlayBreakoutWarning")
	if breakoutWarning then
		breakoutWarning.OnClientEvent:Connect(playCue)
	end
	local impostorTell = ReplicatedStorage:FindFirstChild("PlayImpostorTell")
	if impostorTell then
		impostorTell.OnClientEvent:Connect(playCue)
	end
end

wire()