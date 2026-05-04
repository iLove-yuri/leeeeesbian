repeat wait() until game:IsLoaded()
local CoreGui = cloneref(game:GetService("CoreGui"))
local HttpService = cloneref(game:GetService("HttpService"))
local Lighting = cloneref(game:GetService("Lighting"))
local Players = cloneref(game:GetService("Players"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local Workspace = cloneref(game:GetService("Workspace"))
local plr = Players.LocalPlayer
local list = {
	["5130394318"] = {id = "1b1251046fd4407c1d8f7e90cb337aeb", keyless = false }, --- bizarre lineage
	["7359962123"] = {id = "606ff7b9ea1d1c897761b2f0c218f3d9", keyless = false }, --- aac
	["1709917610"] = {id = "1a8a31e1f73770905420267556ed741d", keyless = false }, -- regretevator
	["9186719164"] = {id = "2e85411f515c33094f504d7c6b198a35", keyless = true }, --- sailor piece
	["9792947201"] = {id = "d8e39dd7c8bfa5015a2c48dc361d656f", keyless = false }, --- slime rng
	["4658598196"] = {id = "a3cefccb299c6afcd29ba88768212ea2", keyless = false } --- aotr
}
local executor_name = getexecutorname():match("^%s*(.-)%s*$")
local game_id = tostring(game.GameId)
local game_config = list[game_id]
if not game_config then
	plr:Kick("This game is not supported.")
	return
end
local script_id = game_config.id
local is_key_less = game_config.keyless

if CoreGui:FindFirstChild("iLoveyuri") then
    CoreGui.iLoveyuri:Destroy()
end
local config = {
    KeyFile = "yuri/savedkey.txt",
    Title = "Yuri",
    LinkvertiseURL = "https://ads.luarmor.net/get_key?for=Yuri-ODPllbErcWEJ",
    WorkinkURL = "https://ads.luarmor.net/get_key?for=Lesbian-pCiCBJScuyDv",
    DiscordURL = "https://discord.gg/b6kxdDtqd"
}
local luarmor_api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
luarmor_api.script_id = script_id
if is_key_less then
    pcall(function()
        luarmor_api.load_script()
    end)
    return
end
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local theme = {
    BG = Color3.fromRGB(10, 10, 10),
    Panel = Color3.fromRGB(18, 18, 18),
    Border = Color3.fromRGB(45, 45, 45),
    Text = Color3.fromRGB(200, 200, 200),
    Dim = Color3.fromRGB(80, 80, 80),
    Accent = Color3.fromRGB(220, 220, 220),
    Button = Color3.fromRGB(28, 28, 28),
    ButtonHover = Color3.fromRGB(42, 42, 42),
    Success = Color3.fromRGB(60, 255, 60),
    Error = Color3.fromRGB(255, 60, 60)
}
local screenWidth = workspace.CurrentCamera.ViewportSize.X
local screenHeight = workspace.CurrentCamera.ViewportSize.Y
local W = math.clamp(screenWidth * 0.7, 400, 700)
local H = math.clamp(screenHeight * 0.5, 250, 400)
local HEADER_H = IsMobile and 54 or 60
local PAD = 12
local FONT = Enum.Font.Code
local FONT_SIZE = IsMobile and 13 or 14
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "iLoveyuri"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui
local wrapper = Instance.new("Frame")
wrapper.BackgroundTransparency = 1
wrapper.Size = UDim2.fromOffset(W, H)
wrapper.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
wrapper.Parent = screenGui
local root = Instance.new("Frame")
root.Size = UDim2.fromScale(1, 1)
root.BackgroundColor3 = theme.BG
root.BorderSizePixel = 0
root.ClipsDescendants = true
root.Parent = wrapper
local rootCorner = Instance.new("UICorner", root)
rootCorner.CornerRadius = UDim.new(0, 6)
local rootStroke = Instance.new("UIStroke", root)
rootStroke.Color = theme.Border
rootStroke.Thickness = 1
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, HEADER_H)
header.BackgroundColor3 = theme.Panel
header.BorderSizePixel = 0
header.Parent = root
local headerStroke = Instance.new("UIStroke", header)
headerStroke.Color = theme.Border
headerStroke.Thickness = 1
headerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
local titleLabel = Instance.new("TextLabel")
titleLabel.Text = config.Title
titleLabel.Font = FONT
titleLabel.TextSize = IsMobile and 18 or 24
titleLabel.TextColor3 = theme.Accent
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.fromOffset(PAD, 0)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Text = "• KEY SYSTEM •"
subtitleLabel.Font = FONT
subtitleLabel.TextSize = 9
subtitleLabel.TextColor3 = theme.Dim
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Size = UDim2.fromOffset(100, 14)
subtitleLabel.Position = UDim2.fromOffset(PAD, 8)
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subtitleLabel.Parent = header
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "×"
closeBtn.Font = FONT
closeBtn.TextSize = 18
closeBtn.TextColor3 = theme.Dim
closeBtn.BackgroundColor3 = theme.Button
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Size = UDim2.fromOffset(IsMobile and 32 or 28, IsMobile and 32 or 28)
closeBtn.Position = UDim2.new(1, -(PAD + (IsMobile and 32 or 28)), 0.5, -(IsMobile and 16 or 14))
closeBtn.Parent = header
local closeBtnCorner = Instance.new("UICorner", closeBtn)
closeBtnCorner.CornerRadius = UDim.new(0, 4)
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -PAD*2, 1, -HEADER_H - PAD*2)
content.Position = UDim2.fromOffset(PAD, HEADER_H + PAD)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = theme.Border
content.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
content.CanvasSize = UDim2.fromOffset(0, 0) 
content.Parent = root
local contentPadding = Instance.new("UIPadding", content)
contentPadding.PaddingTop = UDim.new(0, 5)
contentPadding.PaddingBottom = UDim.new(0, 10)
contentPadding.PaddingLeft = UDim.new(0, 2)
contentPadding.PaddingRight = UDim.new(0, 2)
local contentLayout = Instance.new("UIListLayout", content)
contentLayout.FillDirection = Enum.FillDirection.Vertical
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Padding = UDim.new(0, 10)
local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "Enter your key to continue"
statusLabel.Font = FONT
statusLabel.TextSize = FONT_SIZE
statusLabel.TextColor3 = theme.Text
statusLabel.BackgroundTransparency = 1
statusLabel.Size = UDim2.new(1, -10, 0, 20)
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.LayoutOrder = 1
statusLabel.Parent = content
local keyContainer = Instance.new("Frame")
keyContainer.Size = UDim2.new(1, -10, 0, 40)
keyContainer.BackgroundColor3 = theme.Panel
keyContainer.BorderSizePixel = 0
keyContainer.LayoutOrder = 2
keyContainer.Parent = content
local keyContainerCorner = Instance.new("UICorner", keyContainer)
keyContainerCorner.CornerRadius = UDim.new(0, 4)
local keyContainerStroke = Instance.new("UIStroke", keyContainer)
keyContainerStroke.Color = theme.Border
keyContainerStroke.Thickness = 1
local keyTextBox = Instance.new("TextBox")
keyTextBox.PlaceholderText = "Paste your key here..."
keyTextBox.Text = ""
keyTextBox.Font = FONT
keyTextBox.TextSize = FONT_SIZE - 1
keyTextBox.TextColor3 = theme.Text
keyTextBox.PlaceholderColor3 = theme.Dim
keyTextBox.BackgroundTransparency = 1
keyTextBox.Size = UDim2.new(1, -20, 1, 0)
keyTextBox.Position = UDim2.fromOffset(10, 0)
keyTextBox.ClearTextOnFocus = false
keyTextBox.TextXAlignment = Enum.TextXAlignment.Left
keyTextBox.Parent = keyContainer
local buttonsContainer = Instance.new("Frame")
buttonsContainer.Size = UDim2.new(1, -10, 0, 120)
buttonsContainer.BackgroundTransparency = 1
buttonsContainer.LayoutOrder = 3
buttonsContainer.Parent = content
local buttonLayout = Instance.new("UIListLayout", buttonsContainer)
buttonLayout.FillDirection = Enum.FillDirection.Vertical
buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
buttonLayout.Padding = UDim.new(0, 10)
contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    content.CanvasSize = UDim2.fromOffset(0, contentLayout.AbsoluteContentSize.Y + 10)
end)
local function createButton(text, color)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Font = FONT
    btn.TextSize = FONT_SIZE
    btn.TextColor3 = theme.Text
    btn.BackgroundColor3 = color or theme.Button
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Parent = buttonsContainer
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 4)
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = theme.Border
    btnStroke.Thickness = 1
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = theme.ButtonHover
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = color or theme.Button
        }):Play()
    end)
    return btn
end
local checkKeyBtn = createButton("Check Key", theme.Button)
local getLinkBtn = createButton("Get Key (Linkvertise)", theme.Button)
local getWorkinkBtn = createButton("Get Key (Work.ink)", theme.Button)
local discordBtn = createButton("Discord Support", theme.Button)
local function notify(text, color)
    statusLabel.Text = text
    statusLabel.TextColor3 = color or theme.Text
    statusLabel.TextTransparency = 0.6
    TweenService:Create(statusLabel, TweenInfo.new(0.3), {
        TextTransparency = 0
    }):Play()
end
local dragging = false
local dragStart
local startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = wrapper.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or
       input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            TweenService:Create(wrapper, TweenInfo.new(0.08), {
                Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            }):Play()
        end
    end
end)
local function validateKey(key)
    local cleanedKey = key:gsub("%s", "")
    if #cleanedKey ~= 32 then
        notify("Invalid key format (must be 32 characters)", theme.Error)
        return false
    end
    notify("Validating key...", theme.Accent)
    local success, result = pcall(function()
        return luarmor_api.check_key(cleanedKey)
    end)
    if not success then
        notify("Network error. Check your connection.", theme.Error)
        return false
    end
    if result.code == "KEY_VALID" then
        if not isfolder("yuri") then
            makefolder("yuri")
        end
        writefile(config.KeyFile, cleanedKey)
        script_key = cleanedKey
        notify("✓ Key valid! Loading script...", theme.Success)
        wait(1)
        screenGui:Destroy()
        pcall(function()
            luarmor_api.load_script()
        end)
        return true
    else
        notify("Invalid or expired key", theme.Error)
        return false
    end
end
getLinkBtn.MouseButton1Click:Connect(function()
    setclipboard(config.LinkvertiseURL)
    notify("✓ Linkvertise link copied to clipboard", theme.Success)
end)
getWorkinkBtn.MouseButton1Click:Connect(function()
    setclipboard(config.WorkinkURL)
    notify("✓ Work.ink link copied to clipboard", theme.Success)
end)
checkKeyBtn.MouseButton1Click:Connect(function()
    local key = keyTextBox.Text
    if key == "" then
        notify("Please enter a key", theme.Error)
        return
    end
    validateKey(key)
end)
discordBtn.MouseButton1Click:Connect(function()
    setclipboard(config.DiscordURL)
    notify("✓ Discord link copied to clipboard", theme.Success)
end)
keyTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and keyTextBox.Text ~= "" then
        validateKey(keyTextBox.Text)
    end
end)
closeBtn.MouseButton1Click:Connect(function()
    notify("Closing...", theme.Error)
    wait(0.5)
    screenGui:Destroy()
end)
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = theme.ButtonHover,
        TextColor3 = theme.Error
    }):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = theme.Button,
        TextColor3 = theme.Dim
    }):Play()
end)
task.spawn(function()
    if isfile(config.KeyFile) then
        local savedKey = readfile(config.KeyFile)
        notify("Checking saved key...", theme.Accent)
        wait(0.5)
        if validateKey(savedKey) then
            return
        else
            delfile(config.KeyFile)
            notify("Saved key expired. Get a new one.", theme.Error)
        end
    end
end)
queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
Players.LocalPlayer.OnTeleport:Connect(function(State)
	if _G.autoExec and queueteleport then
		TeleportCheck = true
		queueteleport([[
			loadstring(game:HttpGet('https://raw.githubusercontent.com/iLove-yuri/leeeeesbian/refs/heads/main/homumado.lua'))()
		]])
	end
end)
root.Size = UDim2.fromOffset(0, 0)
TweenService:Create(root, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
    Size = UDim2.fromOffset(W, H)
}):Play()
