local StarterGui = game:GetService("StarterGui")

-- Custom HUD covers health + backpack; PlayerList and Chat stay default by design.
local ATTEMPTS = 5

local function disableCoreGuis(attempt)
	local ok, err = pcall(function()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
		-- Owner decision 2026-09-06: disable default chat entirely (no clean way to suppress
		-- the chat-translation system notice; custom chat may replace this later).
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
		-- Also disable the TextChatService UI shell (window + input bar + bubbles) — it can
		-- still mount a visible frame at top-left even with the Chat CoreGui off.
		local TextChatService = game:GetService("TextChatService")
		local chatWindow = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
		if chatWindow then chatWindow.Enabled = false end
		local chatInput = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
		if chatInput then chatInput.Enabled = false end
		local bubble = TextChatService:FindFirstChildOfClass("BubbleChatConfiguration")
		if bubble then bubble.Enabled = false end
	end)
	if ok then
		print("[BOPLUX_HUD] CoreGui: Health+Backpack+Chat disabled; PlayerList left default")
	elseif attempt < ATTEMPTS then
		task.delay(1, disableCoreGuis, attempt + 1)
	else
		warn("[BOPLUX_HUD] SetCoreGuiEnabled failed after retries: " .. tostring(err))
	end
end

disableCoreGuis(1)
