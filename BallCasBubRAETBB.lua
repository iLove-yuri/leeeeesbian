if game.GameId == 10277874067 then
if getgenv().ayasemiyatongekissazumirisa then
warn("yuri")
return
end
function missing(t, f, fallback)
if type(f) == t then return f end
return fallback
end
cloneref = missing("function", cloneref, function(...) return ... end)
getgc = missing("function", getgc or get_gc_objects)
getconnections = missing("function", getconnections or get_signal_cons)
Services = setmetatable({}, {
__index = function(self, name)
local success, cache = pcall(function()
return cloneref(game:GetService(name))
end)
if success then
rawset(self, name, cache)
return cache
else
error("Invalid Service: " .. tostring(name))
end
end
})
local Players = Services.Players
local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local PGui = Plr:WaitForChild("PlayerGui")
local Lighting = game:GetService('Lighting');
local RS = Services.ReplicatedStorage
local RunService = Services.RunService
local HttpService = Services.HttpService
local GuiService = Services.GuiService
local TeleportService = Services.TeleportService
local Marketplace = Services.MarketplaceService
local UIS = Services.UserInputService
local VirtualUser = Services.VirtualUser
local v, Asset = pcall(function()
return Marketplace:GetProductInfo(game.PlaceId)
end)
local assetName = "game name"
if v and Asset then
assetName = Asset.Name
end
local Support = {
Webhook = (typeof(request) == "function" or typeof(http_request) == "function"),
Clipboard = (typeof(setclipboard) == "function"),
FileIO = (typeof(writefile) == "function" and typeof(isfile) == "function"),
QueueOnTeleport = (typeof(queue_on_teleport) == "function"),
Connections = (typeof(getconnections) == "function"),
FPS = (typeof(setfpscap) == "function"),
Proximity = (typeof(fireproximityprompt) == "function"),
}
local executorName = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local LimitedExecutors = {"xeno", "solara",}
local isLimitedExecutor = false
for _, name in ipairs(LimitedExecutors) do
if string.find(executorName, name) then
isLimitedExecutor = true
break
end
end
local function notyuri()
end
local repo = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
getgenv().ayasemiyatongekissazumirisa = true
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true 
Library.ShowCustomCursor = true 
Library.NotifySide = "Left"
local function AddInfo(Window)
local InfoTab = Window:AddTab("Info")
local InfoLeft = InfoTab:AddLeftGroupbox("Information")
local statusText = isLimitedExecutor and "<font color='#FFA500'>Semi-Working</font>" or "<font color='#00FF00'>Working</font>"
local extraNote = isLimitedExecutor
and "<b>NOTE:</b> May experiencing bugs for some features!"
or "All features should works properly!"
InfoLeft:AddLabel("<b>Executor:</b> " .. executorDisplayName .. "\n<b>Status:</b> " .. statusText .. "\n" .. extraNote, true)
end
local eh_success, err = pcall(function()
local Script_Start_Time = os.time()
local function GetSessionTime()
local seconds = os.time() - Script_Start_Time
local hours = math.floor(seconds / 3600)
local mins = math.floor((seconds % 3600) / 60)
return string.format("%dh %02dm", hours, mins)
end
local function GetObject(parent, pathString)
local current = parent
for _, name in ipairs(pathString:split(".")) do
if not current then return nil end
current = current:FindFirstChild(name)
end
return current
end
local function GetSafeModule(parent, name)
local obj = parent:FindFirstChild(name)
if obj and obj:IsA("ModuleScript") then
local success, result = pcall(require, obj)
if success then return result end
end
return nil
end
local function SafeConnect(key, getSignalFn, handler)
local ok, signal = pcall(getSignalFn)
if not ok or not signal then
return
end
Connections[key] = signal:Connect(handler)
end
local function SafeInvoke(remote, ...)
local args = {...}
local result = nil
task.spawn(function()
local success, res = pcall(function()
return remote:InvokeServer(unpack(args))
end)
result = res
end)
local start = tick()
repeat task.wait() until result ~= nil or (tick() - start) > 2 
return result
end
local function fire_event(signal, ...)
if firesignal then
return firesignal(signal, ...)
elseif getconnections then
for _, connection in ipairs(getconnections(signal)) do
if connection.Function then
task.spawn(connection.Function, ...)
end
end
else
warn("Your executor does not support firesignal or getconnections.")
end
end
local Remotes = {
}
local Modules = {
}
local Flags = {}
local Shared = {
}
local Tables = {
}
local Connections = {
Player_General = nil,
Knockback = {},
Reconnect = nil,
}
local function Cleanup(tbl)
for key, value in pairs(tbl) do
if typeof(value) == "RBXScriptConnection" then
value:Disconnect()
tbl[key] = nil
elseif typeof(value) == 'thread' then
task.cancel(value)
tbl[key] = nil
elseif type(value) == 'table' then
Cleanup(value)
end
end
end
function Thread(featurePath, featureFunc, isEnabled, ...)
local pathParts = featurePath:split(".")
local currentTable = Flags 
for i = 1, #pathParts - 1 do
local part = pathParts[i]
if not currentTable[part] then currentTable[part] = {} end
currentTable = currentTable[part]
end
local flagKey = pathParts[#pathParts]
local activeThread = currentTable[flagKey]
if isEnabled then
if not activeThread or coroutine.status(activeThread) == "dead" then
local newThread = task.spawn(featureFunc, ...)
currentTable[flagKey] = newThread
end
else
if activeThread and typeof(activeThread) == 'thread' then
task.cancel(activeThread)
currentTable[flagKey] = nil
end
end
end
local function SafeLoop(name, func)
return function()
local success, err = pcall(func)
if not success then
Library:Notify("Error in ["..name.."]: "..tostring(err), 10)
warn("Error in ["..name.."]: "..tostring(err))
end
end
end
local function CommaFormat(n)
local s = tostring(n)
return s:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end
local function Abbreviate(n)
local abbrev = {{1e12, "T"}, {1e9, "B"}, {1e6, "M"}, {1e3, "K"}}
for _, v in ipairs(abbrev) do
if n >= v[1] then return string.format("%.1f%s", n / v[1], v[2]) end
end
return tostring(n)
end
function AddSliderToggle(Config)
local Toggle = Config.Group:AddToggle(Config.Id, {
Text = Config.Text,
Default = Config.DefaultToggle or false
})
local Slider = Config.Group:AddSlider(Config.Id .. "Value", {
Text = Config.Text,
Default = Config.Default,
Min = Config.Min,
Max = Config.Max,
Rounding = Config.Rounding or 0,
Compact = true,
Visible = false
})
Toggle:OnChanged(function()
Slider:SetVisible(Toggle.Value)
end)
return Toggle, Slider
end
local function GetCharacter()
local c = Plr.Character
return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
end
local function FuncTPW()
while true do
local delta = RunService.Heartbeat:Wait()
local char = GetCharacter()
local hum = char and char:FindFirstChildOfClass("Humanoid")
if char and hum and hum.Health > 0 then
if hum.MoveDirection.Magnitude > 0 then
local speed = Options.TPWValue.Value
char:TranslateBy(hum.MoveDirection * speed * delta * 10)
end
end
end
end
local function FuncNoclip()
while Toggles.Noclip.Value do
RunService.Stepped:Wait()
local char = GetCharacter()
if char then
for _, part in pairs(char:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then
part.CanCollide = false
end
end
end
end
end
local function Func_AntiKnockback()
if type(Connections.Knockback) == "table" then
for _, conn in pairs(Connections.Knockback) do
if conn then conn:Disconnect() end
end
table.clear(Connections.Knockback)
else
Connections.Knockback = {}
end
local function ApplyAntiKB(character)
if not character then return end
local root = character:WaitForChild("HumanoidRootPart", 10)
if root then
local conn = root.ChildAdded:Connect(function(child)
if not Toggles.AntiKnockback.Value then return end
if child:IsA("BodyVelocity") and child.MaxForce == Vector3.new(40000, 40000, 40000) then
child:Destroy()
end
end)
table.insert(Connections.Knockback, conn)
end
end
if Plr.Character then
ApplyAntiKB(Plr.Character)
end
local charAddedConn = Plr.CharacterAdded:Connect(function(newChar)
ApplyAntiKB(newChar)
end)
table.insert(Connections.Knockback, charAddedConn)
repeat task.wait(1) until not Toggles.AntiKnockback.Value
for _, conn in pairs(Connections.Knockback) do
if conn then conn:Disconnect() end
end
table.clear(Connections.Knockback)
end
local function Func_AutoReconnect()
if Connections.Reconnect then Connections.Reconnect:Disconnect() end
Connections.Reconnect = GuiService.ErrorMessageChanged:Connect(function()
if not Toggles.AutoReconnect.Value then return end
task.delay(2, function()
pcall(function()
local promptOverlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
if promptOverlay then
local errorPrompt = promptOverlay.promptOverlay:FindFirstChild("ErrorPrompt")
if errorPrompt and errorPrompt.Visible then
local secondaryTimer = 5
task.wait(secondaryTimer)
TeleportService:Teleport(game.PlaceId, Plr)
end
end
end)
end)
end)
end
local function Func_NoGameplayPaused()
while Toggles.NoGameplayPaused.Value do
local success, err = pcall(function()
local pauseGui = game:GetService("CoreGui").RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
if pauseGui then
pauseGui:Destroy()
end
end)
task.wait(1)
end
end
local function ApplyFPSBoost(state)
if not state then return end
pcall(function()
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 1
for _, v in pairs(Lighting:GetChildren()) do
if v:IsA("PostProcessEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
v.Enabled = false
end
end
task.spawn(function()
for i, v in pairs(workspace:GetDescendants()) do
if Toggles.FPSBoost and not Toggles.FPSBoost.Value then break end
pcall(function()
if v:IsA("BasePart") then
v.Material = Enum.Material.SmoothPlastic
v.CastShadow = false
elseif v:IsA("Decal") or v:IsA("Texture") then
v:Destroy()
elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
v.Enabled = false
end
end)
if i % 500 == 0 then task.wait() end
end
end)
end)
end
function gsc(guiObject)
if not guiObject then return false end
local success = false
pcall(function()
if Services.GuiService and Services.VirtualInputManager then
Services.GuiService.SelectedObject = guiObject
task.wait(0.05)
local keys = {Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter, Enum.KeyCode.ButtonA}
for _, key in ipairs(keys) do
Services.VirtualInputManager:SendKeyEvent(true, key, false, game); task.wait(0.03)
Services.VirtualInputManager:SendKeyEvent(false, key, false, game); task.wait(0.03)
end
Services.GuiService.SelectedObject = nil
success = true
end
end)
return success
end
local function FireCD(target)
if not fireclickdetector then
return
end
if not target or not target:IsA("ClickDetector") then
return
end
fireclickdetector(target)
end
local function FirePP(target, teleport)
if not fireproximityprompt then return end
if not target or not target:IsA("ProximityPrompt") then return end
local prevDist = target.MaxActivationDistance
if teleport then
local char = GetCharacter()
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local part = target.Parent
local isModel = false
if part then
if part:IsA("Model") then
isModel = true
elseif not part:IsA("BasePart") then
part = target:FindFirstAncestorWhichIsA("BasePart")
if not part then
part = target:FindFirstAncestorWhichIsA("Model")
if part then
isModel = true
end
end
end
end
if hrp and part then
local partPos = isModel and part:GetPivot().Position or part.Position
local dist = (hrp.Position - partPos).Magnitude
if dist > prevDist then
local partCFrame = isModel and part:GetPivot() or part.CFrame
hrp.CFrame = partCFrame * CFrame.new(0, 3, 0)
task.wait(0.175)
end
end
end
fireproximityprompt(target)
end
local function FireTI(target)
if not firetouchinterest then
return
end
local root = Char and Char:FindFirstChild("HumanoidRootPart")
if not root then
return
end
local part
if target:IsA("BasePart") then
part = target
else
part = target:FindFirstAncestorWhichIsA("BasePart")
end
if not part then
return
end
part.CFrame = root.CFrame
task.spawn(function()
firetouchinterest(part, root, 1)
task.wait()
firetouchinterest(part, root, 0)
end)
end
local Remotes = {
RollEvent = GetObject(RS, "RollEvent"),
DropBallEvent = GetObject(RS, "DropBallEvent"),
BallLandedEvent = GetObject(RS, "BallLandedEvent"),
UpdateSettingsEvent = GetObject(RS, "UpdateSettingsEvent"),
PurchaseUpgradeEvent = GetObject(RS, "PurchaseUpgradeEvent"),
RebirthEvent = GetObject(RS, "RebirthEvent"),
BuyZoneEvent = GetObject(RS, "BuyZoneEvent"),
EquipZoneEvent = GetObject(RS, "EquipZoneEvent"),
EquipBallEvent = GetObject(RS, "EquipBallEvent"),
UnequipBallEvent = GetObject(RS, "UnequipBallEvent"),
EquipBestEvent = GetObject(RS, "EquipBestEvent"),
AutoEquipEvent = GetObject(RS, "AutoEquipEvent"),
UsePotionFunc = GetObject(RS, "UsePotionFunc"),
UseJackpotFunc = GetObject(RS, "UseJackpotFunc"),
ClaimQuestRewardFunc = GetObject(RS, "ClaimQuestRewardFunc"),
ClaimDailyRewardFunc = GetObject(RS, "ClaimDailyRewardFunc"),
ClaimIndexRewardFunc = GetObject(RS, "ClaimIndexRewardFunc"),
RedeemCodeFunc = GetObject(RS, "RedeemCodeFunc"),
ShootBallFunc = GetObject(RS, "ShootBallFunc"),
ShootTargetFunc = GetObject(RS, "ShootTargetFunc"),
SetLuckEvent = GetObject(RS, "SetLuckEvent"),
GetPlayerStatsFunc = GetObject(RS, "GetPlayerStatsFunc"),
GetUpgradeTreeFunc = GetObject(RS, "GetUpgradeTreeFunc"),
GetQuestsDataFunc = GetObject(RS, "GetQuestsDataFunc"),
GetIndexDataFunc = GetObject(RS, "GetIndexDataFunc"),
GetDailyRewardStateFunc = GetObject(RS, "GetDailyRewardStateFunc"),
}
local GameData = {
UpgradeDefs = GetSafeModule(RS, "UpgradeDefs"),
ZoneDefs = GetSafeModule(RS, "ZoneDefs"),
BallIndex = GetSafeModule(RS, "BallIndex"),
}
local function SafeInvoke(remote, ...)
if not remote then return nil end
local args = { ... }
local result = nil
local done = false
task.spawn(function()
local ok, res = pcall(function() return remote:InvokeServer(table.unpack(args)) end)
result = ok and res or nil
done = true
end)
local start = tick()
while not done and (tick() - start) < 5 do task.wait() end
return result
end
local function GetPlayerStats()
return SafeInvoke(Remotes.GetPlayerStatsFunc)
end
local function GetUpgradeTree()
return SafeInvoke(Remotes.GetUpgradeTreeFunc)
end
local function GetQuestsData()
return SafeInvoke(Remotes.GetQuestsDataFunc)
end
local function GetIndexData()
return SafeInvoke(Remotes.GetIndexDataFunc)
end
local PotionTypes = { "Luck", "RollSpeed", "DropSpeed" }
local function Func_AutoRoll()
while Toggles.BG_AutoRoll.Value do
if Remotes.RollEvent then
pcall(function() Remotes.RollEvent:FireServer() end)
end
task.wait(.1)
end
end
local function Func_AutoDrop()
while Toggles.BG_AutoDrop.Value do
if Remotes.DropBallEvent then
Remotes.BallLandedEvent:FireServer(999999999999999999999)
end
task.wait()
end
end
local function Func_AutoRebirth()
while Toggles.BG_AutoRebirth.Value do
if Remotes.RebirthEvent then
local ok, res = pcall(function() return Remotes.RebirthEvent:InvokeServer() end)
if ok and res then
notyuri("[AutoRebirth] rebirthed successfully")
end
end
task.wait(.1)
end
end
local function Func_AutoBuyUpgrades()
while Toggles.BG_AutoBuyUpgrades.Value do
local tree = GetUpgradeTree()
local ud = GameData.UpgradeDefs
if tree and ud and ud.Upgrades and Remotes.PurchaseUpgradeEvent then
for _, upg in ipairs(ud.Upgrades) do
if not Toggles.BG_AutoBuyUpgrades.Value then break end
if upg.id and upg.id ~= "start" and not tree[upg.id] then
local canBuy = true
if upg.requires and not tree[upg.requires] then
canBuy = false
end
if canBuy then
pcall(function() Remotes.PurchaseUpgradeEvent:FireServer(upg.id) end)
notyuri("[AutoBuyUpgrades] bought", upg.id)
task.wait(0.1)
end
end
end
end
task.wait(.1)
end
end
local function Func_AutoEquipBest()
while Toggles.BG_AutoEquipBest.Value do
if Remotes.EquipBestEvent then
pcall(function() Remotes.EquipBestEvent:FireServer() end)
end
task.wait(.1)
end
end
local function Func_AutoBuyZones()
while Toggles.BG_AutoBuyZones.Value do
local stats = GetPlayerStats()
local zd = GameData.ZoneDefs
if stats and zd and zd.Zones and Remotes.BuyZoneEvent then
local unlocked = stats.UnlockedZones or {}
for _, zone in ipairs(zd.Zones) do
if not Toggles.BG_AutoBuyZones.Value then break end
local isUnlocked = unlocked[tostring(zone.Id)] or unlocked[zone.Id]
if not isUnlocked then
local ok, res = pcall(function() return Remotes.BuyZoneEvent:InvokeServer(zone.Id) end)
if ok and res then
notyuri("[AutoBuyZones] bought zone", zone.Name)
task.wait(0.5)
end
end
end
end
task.wait(.1)
end
end
local function Func_AutoUsePotion()
while Toggles.BG_AutoUsePotion.Value do
local potionType = Options.BG_PotionType and Options.BG_PotionType.Value or "Luck"
if Remotes.UsePotionFunc then
local ok, res = pcall(function() return Remotes.UsePotionFunc:InvokeServer(potionType) end)
if ok and res and res.success then
notyuri("[AutoUsePotion] used", potionType, "remaining:", res.remaining or 0)
end
end
task.wait(.1)
end
end
local function Func_AutoUseJackpot()
while Toggles.BG_AutoUseJackpot.Value do
if Remotes.UseJackpotFunc then
local ok, res = pcall(function() return Remotes.UseJackpotFunc:InvokeServer() end)
if ok and res then
notyuri("[AutoUseJackpot] jackpot used")
end
end
task.wait(.1)
end
end
local function Func_AutoClaimQuests()
while Toggles.BG_AutoClaimQuests.Value do
local quests = GetQuestsData()
if quests and Remotes.ClaimQuestRewardFunc then
for _, cat in ipairs({ "Rolls", "Rarity" }) do
if quests[cat] then
for i, q in ipairs(quests[cat]) do
if not Toggles.BG_AutoClaimQuests.Value then break end
if q and not q.claimed and q.progress and q.required and q.progress >= q.required then
pcall(function() Remotes.ClaimQuestRewardFunc:InvokeServer(cat, i) end)
notyuri("[AutoClaimQuests] claimed", cat, i)
task.wait(0.5)
end
end
end
end
if quests.DailyClaimed == false then
pcall(function() Remotes.ClaimQuestRewardFunc:InvokeServer("Daily", 1) end)
notyuri("[AutoClaimQuests] claimed daily")
end
end
task.wait(.1)
end
end
local function Func_AutoClaimDaily()
while Toggles.BG_AutoClaimDaily.Value do
if Remotes.ClaimDailyRewardFunc then
local ok, res = pcall(function() return Remotes.ClaimDailyRewardFunc:InvokeServer() end)
if ok and res then
notyuri("[AutoClaimDaily] claimed daily reward")
end
end
task.wait()
end
end
local function Func_AutoClaimIndex()
while Toggles.BG_AutoClaimIndex.Value do
local idxData = GetIndexData()
if idxData and Remotes.ClaimIndexRewardFunc then
for i = 1, 100 do
if not Toggles.BG_AutoClaimIndex.Value then break end
local ok, res = pcall(function() return Remotes.ClaimIndexRewardFunc:InvokeServer(i) end)
if not ok or not res then break end
notyuri("[AutoClaimIndex] claimed index", i)
task.wait(0.1)
end
end
task.wait()
end
end
local function Func_AutoShoot()
while Toggles.BG_AutoShoot.Value do
if Remotes.ShootBallFunc then
pcall(function() Remotes.ShootBallFunc:InvokeServer("1", true) end)
end
task.wait(.1)
end
end
local Window = Library:CreateWindow({
Title = "Yuri",
Center = true,
AutoShow = true,
Resizable = true,
ShowCustomCursor = false,
UnlockMouseWhileOpen = false,
NotifySide = "Left",
TabPadding = 8,
MenuFadeTime = 0.2
})
AddInfo(Window)
local Tabs = {
Main = Window:AddTab("Main"),
Player = Window:AddTab("Player"),
Config = Window:AddTab("Config"),
}
local TB = {
Main = {
Left = {
Autofarm = Tabs.Main:AddLeftTabbox(),
},
Right = {
Autofarm = Tabs.Main:AddRightTabbox(),
},
},
}
local TB_Tabs = {
Autofarm = {
T1 = TB.Main.Left.Autofarm:AddTab("Autofarm"),
},
Autofarm2 = {
T1 = TB.Main.Right.Autofarm:AddTab("Config"),
},
}
local GB = {
Player = {
Left = {
General = Tabs.Player:AddLeftGroupbox("General"),
Server  = Tabs.Player:AddLeftGroupbox("Server"),
},
Right = {
Game = Tabs.Player:AddRightGroupbox("Game"),
},
},
}
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 250 })
local TPW_T, TPW_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "JP", Text = "JumpPower", Default = 50, Min = 0, Max = 500 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "HH", Text = "HipHeight", Default = 2, Min = 0, Max = 10, Rounding = 1 })
GB.Player.Left.General:AddToggle("Noclip", { Text = "Noclip" })
GB.Player.Left.General:AddToggle("AntiKnockback", {
Text = "Anti Knockback",
Default = false,
})
GB.Player.Left.General:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering" })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1})
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
local FPS_T, FPS_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
GB.Player.Left.General:AddToggle("FPSBoost", { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK", {
Text = "Anti AFK",
Default = true,
Disabled = not Support.Connections,
})
GB.Player.Left.Server:AddToggle("AntiKick", { Text = "Anti Kick (Client)" })
GB.Player.Left.Server:AddToggle("AutoReconnect", { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused"})
GB.Player.Left.Server:AddButton({ Text = "Serverhop", Func = function()
local Servers = game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100')
end})
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function() Services.TeleportService:Teleport(game.PlaceId, Plr) end })
GB.Player.Left.Server:AddToggle("AutoServerhop", { Text = "Auto Serverhop" })
GB.Player.Left.Server:AddSlider("AutoHopMins", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
GB.Player.Right.Game:AddToggle("InstantPP", { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog", { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
Toggles.AntiKnockback:OnChanged(function(state)
Thread("AntiKnockback", Func_AntiKnockback, state)
end)
Toggles.TPW:OnChanged(function(v)
TPW_S:SetVisible(TPW_T.Value)
Thread("TPW", FuncTPW, v)
end)
Toggles.Noclip:OnChanged(function(v)
Thread("Noclip", FuncNoclip, v)
end)
Connections.Player_General = RunService.Stepped:Connect(function()
local Hum = Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")
if Hum then
if Toggles.WS.Value then Hum.WalkSpeed = Options.WSValue.Value end
if Toggles.JP.Value then Hum.JumpPower = Options.JPValue.Value Hum.UseJumpPower = true end
if Toggles.HH.Value then Hum.HipHeight = Options.HHValue.Value end
end
workspace.Gravity = Toggles.Grav.Value and Options.GravValue.Value or 192
if Toggles.FOV.Value then workspace.CurrentCamera.FieldOfView = Options.FOVValue.Value end
if Toggles.Zoom.Value then Plr.CameraMaxZoomDistance = Options.ZoomValue.Value end
end)
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoRoll", {
Text = "Auto Roll",
Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoDrop", {
Text = "Auto Drop",
Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoRebirth", {
Text = "Auto Rebirth",
Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoUsePotion", {
Text = "Auto Use Potion",
Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoUseJackpot", {
Text = "Auto Use Jackpot",
Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoClaimQuests", {
Text = "Auto Claim Quests",
Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoClaimDaily", {
Text = "Auto Claim Daily",
Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoClaimIndex", {
Text = "Auto Claim Index",
Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoBuyUpgrades", {
Text = "Auto Upgrades",
Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoEquipBest", {
Text = "Auto Equip Ball",
Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoBuyZones", {
Text = "Auto Zones",
Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("BG_AutoShoot", {
Text = "Auto Shoot Balls",
Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("BG_PotionType", {
Text = "Potion Type",
Values = PotionTypes,
Default = "Luck",
})
Toggles.BG_AutoRoll:OnChanged(function(v) Thread("BG_AutoRoll", Func_AutoRoll, v) end)
Toggles.BG_AutoDrop:OnChanged(function(v) Thread("BG_AutoDrop", Func_AutoDrop, v) end)
Toggles.BG_AutoRebirth:OnChanged(function(v) Thread("BG_AutoRebirth", Func_AutoRebirth, v) end)
Toggles.BG_AutoBuyUpgrades:OnChanged(function(v) Thread("BG_AutoBuyUpgrades", Func_AutoBuyUpgrades, v) end)
Toggles.BG_AutoEquipBest:OnChanged(function(v) Thread("BG_AutoEquipBest", Func_AutoEquipBest, v) end)
Toggles.BG_AutoBuyZones:OnChanged(function(v) Thread("BG_AutoBuyZones", Func_AutoBuyZones, v) end)
Toggles.BG_AutoUsePotion:OnChanged(function(v) Thread("BG_AutoUsePotion", Func_AutoUsePotion, v) end)
Toggles.BG_AutoUseJackpot:OnChanged(function(v) Thread("BG_AutoUseJackpot", Func_AutoUseJackpot, v) end)
Toggles.BG_AutoClaimQuests:OnChanged(function(v) Thread("BG_AutoClaimQuests", Func_AutoClaimQuests, v) end)
Toggles.BG_AutoClaimDaily:OnChanged(function(v) Thread("BG_AutoClaimDaily", Func_AutoClaimDaily, v) end)
Toggles.BG_AutoClaimIndex:OnChanged(function(v) Thread("BG_AutoClaimIndex", Func_AutoClaimIndex, v) end)
Toggles.BG_AutoShoot:OnChanged(function(v) Thread("BG_AutoShoot", Func_AutoShoot, v) end)
task.spawn(function()
while task.wait() do
if Toggles.Fullbright.Value then
Lighting.Brightness = 2
Lighting.ClockTime = 14
Lighting.GlobalShadows = false
elseif Toggles.OverrideTime.Value then
Lighting.ClockTime = Options.OverrideTimeValue.Value
end
if Toggles.NoFog.Value then Lighting.FogEnd = 9e9 end
if Library.Unloaded then break end
end
end)
Options.LimitFPSValue:OnChanged(function()
if FPS_T.Value then
setfpscap(FPS_S.Value)
end
end)
Toggles.LimitFPS:OnChanged(function(v)
FPS_S:SetVisible(FPS_T.Value)
if not v then
setfpscap(999)
end
end)
Toggles.Disable3DRender:OnChanged(function(v) RunService:Set3dRenderingEnabled(not v) end)
Toggles.FPSBoost:OnChanged(function(state)
ApplyFPSBoost(state)
end)
Toggles.AutoReconnect:OnChanged(function(state)
if state then Func_AutoReconnect() end
end)
Toggles.NoGameplayPaused:OnChanged(function(state)
Thread("NoGameplayPaused", SafeLoop("Anti-Pause", Func_NoGameplayPaused), state)
end)
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
if Toggles.InstantPP and Toggles.InstantPP.Value then
prompt.HoldDuration = 0
end
end)
local function RunAntiAFK()
local GC = getconnections or get_signal_cons
if GC then
for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
if v["Disable"] then
v["Disable"](v)
elseif v["Disconnect"] then
v["Disconnect"](v)
end
end
else
local VirtualUser = cloneref(game:GetService("VirtualUser"))
Players.LocalPlayer.Idled:Connect(function()
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end)
end
end
Toggles.AntiAFK:OnChanged(function(state)
if state then RunAntiAFK() end
end)
if Toggles.AntiAFK.Value then RunAntiAFK() end
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("AutoShowUI", {
Text = "Auto Show UI",
Default = true,
})
MenuGroup:AddToggle("KeybindMenuOpen", {
Default = Library.KeybindFrame.Visible,
Text = "Open Keybind Menu",
Callback = function(value)
Library.KeybindFrame.Visible = value
end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
Text = "Custom Cursor",
Default = false,
Callback = function(Value)
Library.ShowCustomCursor = Value
end,
})
MenuGroup:AddDropdown("NotificationSide", {
Values = { "Left", "Right" },
Default = "Right",
Text = "Notification Side",
Callback = function(Value)
Library:SetNotifySide(Value)
end,
})
MenuGroup:AddDropdown("DPIDropdown", {
Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
Default = "100%",
Text = "DPI Scale",
Callback = function(Value)
Value = Value:gsub("%%", "")
local DPI = tonumber(Value)
Library:SetDPIScale(DPI)
end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
:AddKeyPicker("MenuKeybind", { Default = "U", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function()
getgenv().ayasemiyatongekissazumirisa = false
Cleanup(Connections)
Cleanup(Flags)
Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/BallGame")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
SaveManager:LoadAutoloadConfig()
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
Library:SetDPIScale(100)
end
Library:Notify("Script loaded.", 2)
Library:Notify("Yuri!", 5)
end)
if not eh_success then
Library:Notify("ERROR: " .. tostring(err), 4)
notyuri("ERROR: " .. tostring(err))
end
elseif game.GameId == 8978470369 then
if getgenv().ayasemiyatongekissazumirisa then
warn("yuri")
return
end
function missing(t, f, fallback)
if type(f) == t then return f end
return fallback
end
cloneref = missing("function", cloneref, function(...) return ... end)
getgc = missing("function", getgc or get_gc_objects)
getconnections = missing("function", getconnections or get_signal_cons)
Services = setmetatable({}, {
__index = function(self, name)
local success, cache = pcall(function()
return cloneref(game:GetService(name))
end)
if success then
rawset(self, name, cache)
return cache
else
error("Invalid Service: " .. tostring(name))
end
end
})
local Players = Services.Players
local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local PGui = Plr:WaitForChild("PlayerGui")
local Lighting = game:GetService('Lighting');
local RS = Services.ReplicatedStorage
local RunService = Services.RunService
local HttpService = Services.HttpService
local GuiService = Services.GuiService
local TeleportService = Services.TeleportService
local Marketplace = Services.MarketplaceService
local UIS = Services.UserInputService
local VirtualUser = Services.VirtualUser
local v, Asset = pcall(function()
return Marketplace:GetProductInfo(game.PlaceId)
end)
local assetName = "game name"
if v and Asset then
assetName = Asset.Name
end
local Support = {
Webhook = (typeof(request) == "function" or typeof(http_request) == "function"),
Clipboard = (typeof(setclipboard) == "function"),
FileIO = (typeof(writefile) == "function" and typeof(isfile) == "function"),
QueueOnTeleport = (typeof(queue_on_teleport) == "function"),
Connections = (typeof(getconnections) == "function"),
FPS = (typeof(setfpscap) == "function"),
Proximity = (typeof(fireproximityprompt) == "function"),
}
local executorName = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local LimitedExecutors = {"xeno", "solara",}
local isLimitedExecutor = false
for _, name in ipairs(LimitedExecutors) do
if string.find(executorName, name) then
isLimitedExecutor = true
break
end
end
local function notyuri()
end
local repo = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
getgenv().ayasemiyatongekissazumirisa = true
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true 
Library.ShowCustomCursor = true 
Library.NotifySide = "Left"
local function AddInfo(Window)
local InfoTab = Window:AddTab("Info")
local InfoLeft = InfoTab:AddLeftGroupbox("Information")
local statusText = isLimitedExecutor and "<font color='#FFA500'>Semi-Working</font>" or "<font color='#00FF00'>Working</font>"
local extraNote = isLimitedExecutor
and "<b>NOTE:</b> May experiencing bugs for some features!"
or "All features should works properly!"
InfoLeft:AddLabel("<b>Executor:</b> " .. executorDisplayName .. "\n<b>Status:</b> " .. statusText .. "\n" .. extraNote, true)
local InfoRight = InfoTab:AddRightGroupbox("Others")
InfoRight:AddButton({
Text = "Join Discord Server",
Func = function()
local inviteCode = "q8QX76jyz"
local inviteLink = "https://discord.gg/" .. inviteCode
local success = false
if request then
success = pcall(function()
request({
Url = "http://127.0.0.1:6463/rpc?v=1",
Method = "POST",
Headers = {
["Content-Type"] = "application/json",
["Origin"] = "https://discord.com"
},
Body = HttpService:JSONEncode({
cmd = "INVITE_BROWSER",
args = { code = inviteCode },
nonce = HttpService:GenerateGUID(false)
})
})
end)
end
if not success and setclipboard then
setclipboard(inviteLink)
end
end,
})
end
local eh_success, err = pcall(function()
local Script_Start_Time = os.time()
local function GetSessionTime()
local seconds = os.time() - Script_Start_Time
local hours = math.floor(seconds / 3600)
local mins = math.floor((seconds % 3600) / 60)
return string.format("%dh %02dm", hours, mins)
end
local function GetObject(parent, pathString)
local current = parent
for _, name in ipairs(pathString:split(".")) do
if not current then return nil end
current = current:FindFirstChild(name)
end
return current
end
local function GetSafeModule(parent, name)
local obj = parent:FindFirstChild(name)
if obj and obj:IsA("ModuleScript") then
local success, result = pcall(require, obj)
if success then return result end
end
return nil
end
local function SafeConnect(key, getSignalFn, handler)
local ok, signal = pcall(getSignalFn)
if not ok or not signal then
return
end
Connections[key] = signal:Connect(handler)
end
local function SafeInvoke(remote, ...)
local args = {...}
local result = nil
task.spawn(function()
local success, res = pcall(function()
return remote:InvokeServer(unpack(args))
end)
result = res
end)
local start = tick()
repeat task.wait() until result ~= nil or (tick() - start) > 2 
return result
end
local function fire_event(signal, ...)
if firesignal then
return firesignal(signal, ...)
elseif getconnections then
for _, connection in ipairs(getconnections(signal)) do
if connection.Function then
task.spawn(connection.Function, ...)
end
end
else
warn("Your executor does not support firesignal or getconnections.")
end
end
local RemotesFolder = RS:WaitForChild("Events"):WaitForChild("Remotes")
local Remotes = {
Mine                = RemotesFolder:WaitForChild("Mine"),
ToggleWave          = RemotesFolder:WaitForChild("ToggleWave"),
Purchase            = RemotesFolder:WaitForChild("Purchase"),
Button              = RemotesFolder:WaitForChild("Button"),
Shop                = RemotesFolder:WaitForChild("Shop"),
DailyDealsChanged   = RemotesFolder:WaitForChild("DailyDealsChanged"),
ChampionEvent       = RemotesFolder:WaitForChild("ChampionEvent"),
SetBuildSlot        = RemotesFolder:WaitForChild("SetBuildSlot"),
BuildOpRequest      = RemotesFolder:WaitForChild("BuildOpRequest"),
Upgrade             = RemotesFolder:WaitForChild("Upgrade"),
Claim               = RemotesFolder:WaitForChild("Claim"),
GetRewardState      = RemotesFolder:WaitForChild("GetRewardState"),
BuyProduct          = RemotesFolder:WaitForChild("BuyProduct"),
UpgradeStore_Get    = RemotesFolder:WaitForChild("UpgradeStore_Get"),
UpgradeStore_Buy    = RemotesFolder:WaitForChild("UpgradeStore_Buy"),
GetMerchantSnapshot = RemotesFolder:WaitForChild("GetMerchantSnapshot"),
MerchantPurchaseCash= RemotesFolder:WaitForChild("MerchantPurchaseCash"),
FreeRevive          = RemotesFolder:WaitForChild("FreeRevive"),
ClearPlot           = RemotesFolder:WaitForChild("ClearPlot"),
GetDailyDealsSnapshot = RemotesFolder:WaitForChild("GetDailyDealsSnapshot"),
DailyDealClaim      = RemotesFolder:WaitForChild("DailyDealClaim"),
GetWeaponState      = RemotesFolder:WaitForChild("GetWeaponState"),
EquipWeapon         = RemotesFolder:WaitForChild("EquipWeapon"),
GetToolState        = RemotesFolder:WaitForChild("GetToolState"),
PurchaseTool        = RemotesFolder:WaitForChild("PurchaseTool"),
QuarryUpgrade_Get   = RemotesFolder:WaitForChild("QuarryUpgrade_Get"),
QuarryUpgrade_Buy   = RemotesFolder:WaitForChild("QuarryUpgrade_Buy"),
Place               = RemotesFolder:WaitForChild("Place"),
Delete              = RemotesFolder:WaitForChild("Delete"),
GetBuildContext     = RemotesFolder:WaitForChild("GetBuildContext"),
GetBuildInventory   = RemotesFolder:WaitForChild("GetBuildInventory"),
}
local Modules = {
Stats       = GetSafeModule(RS:WaitForChild("Modules"), "Stats"),
SwordStats  = GetSafeModule(RS:WaitForChild("Modules"), "SwordStats"),
ShopCatalog = GetSafeModule(RS:WaitForChild("Modules"), "ShopCatalog"),
PlayerData  = GetSafeModule(RS:WaitForChild("Modules"), "PlayerData"),
}
local Flags = {}
local Shared = {
}
local Tables = {
}
local Connections = {
Player_General = nil,
Knockback = {},
Reconnect = nil,
}
local function Cleanup(tbl)
for key, value in pairs(tbl) do
if typeof(value) == "RBXScriptConnection" then
value:Disconnect()
tbl[key] = nil
elseif typeof(value) == 'thread' then
task.cancel(value)
tbl[key] = nil
elseif type(value) == 'table' then
Cleanup(value)
end
end
end
function Thread(featurePath, featureFunc, isEnabled, ...)
local pathParts = featurePath:split(".")
local currentTable = Flags 
for i = 1, #pathParts - 1 do
local part = pathParts[i]
if not currentTable[part] then currentTable[part] = {} end
currentTable = currentTable[part]
end
local flagKey = pathParts[#pathParts]
local activeThread = currentTable[flagKey]
if isEnabled then
if not activeThread or coroutine.status(activeThread) == "dead" then
local newThread = task.spawn(featureFunc, ...)
currentTable[flagKey] = newThread
end
else
if activeThread and typeof(activeThread) == 'thread' then
task.cancel(activeThread)
currentTable[flagKey] = nil
end
end
end
local function SafeLoop(name, func)
return function()
local success, err = pcall(func)
if not success then
Library:Notify("Error in ["..name.."]: "..tostring(err), 10)
warn("Error in ["..name.."]: "..tostring(err))
end
end
end
local function CommaFormat(n)
local s = tostring(n)
return s:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end
local function Abbreviate(n)
local abbrev = {{1e12, "T"}, {1e9, "B"}, {1e6, "M"}, {1e3, "K"}}
for _, v in ipairs(abbrev) do
if n >= v[1] then return string.format("%.1f%s", n / v[1], v[2]) end
end
return tostring(n)
end
function AddSliderToggle(Config)
local Toggle = Config.Group:AddToggle(Config.Id, {
Text = Config.Text,
Default = Config.DefaultToggle or false
})
local Slider = Config.Group:AddSlider(Config.Id .. "Value", {
Text = Config.Text,
Default = Config.Default,
Min = Config.Min,
Max = Config.Max,
Rounding = Config.Rounding or 0,
Compact = true,
Visible = false
})
Toggle:OnChanged(function()
Slider:SetVisible(Toggle.Value)
end)
return Toggle, Slider
end
local function GetCharacter()
local c = Plr.Character
return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
end
local function FuncTPW()
while true do
local delta = RunService.Heartbeat:Wait()
local char = GetCharacter()
local hum = char and char:FindFirstChildOfClass("Humanoid")
if char and hum and hum.Health > 0 then
if hum.MoveDirection.Magnitude > 0 then
local speed = Options.TPWValue.Value
char:TranslateBy(hum.MoveDirection * speed * delta * 10)
end
end
end
end
local function FuncNoclip()
while Toggles.Noclip.Value do
RunService.Stepped:Wait()
local char = GetCharacter()
if char then
for _, part in pairs(char:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then
part.CanCollide = false
end
end
end
end
end
local function Func_AntiKnockback()
if type(Connections.Knockback) == "table" then
for _, conn in pairs(Connections.Knockback) do
if conn then conn:Disconnect() end
end
table.clear(Connections.Knockback)
else
Connections.Knockback = {}
end
local function ApplyAntiKB(character)
if not character then return end
local root = character:WaitForChild("HumanoidRootPart", 10)
if root then
local conn = root.ChildAdded:Connect(function(child)
if not Toggles.AntiKnockback.Value then return end
if child:IsA("BodyVelocity") and child.MaxForce == Vector3.new(40000, 40000, 40000) then
child:Destroy()
end
end)
table.insert(Connections.Knockback, conn)
end
end
if Plr.Character then
ApplyAntiKB(Plr.Character)
end
local charAddedConn = Plr.CharacterAdded:Connect(function(newChar)
ApplyAntiKB(newChar)
end)
table.insert(Connections.Knockback, charAddedConn)
repeat task.wait(1) until not Toggles.AntiKnockback.Value
for _, conn in pairs(Connections.Knockback) do
if conn then conn:Disconnect() end
end
table.clear(Connections.Knockback)
end
local function Func_AutoReconnect()
if Connections.Reconnect then Connections.Reconnect:Disconnect() end
Connections.Reconnect = GuiService.ErrorMessageChanged:Connect(function()
if not Toggles.AutoReconnect.Value then return end
task.delay(2, function()
pcall(function()
local promptOverlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
if promptOverlay then
local errorPrompt = promptOverlay.promptOverlay:FindFirstChild("ErrorPrompt")
if errorPrompt and errorPrompt.Visible then
local secondaryTimer = 5
task.wait(secondaryTimer)
TeleportService:Teleport(game.PlaceId, Plr)
end
end
end)
end)
end)
end
local function Func_NoGameplayPaused()
while Toggles.NoGameplayPaused.Value do
local success, err = pcall(function()
local pauseGui = game:GetService("CoreGui").RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
if pauseGui then
pauseGui:Destroy()
end
end)
task.wait(1)
end
end
local function ApplyFPSBoost(state)
if not state then return end
pcall(function()
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 1
for _, v in pairs(Lighting:GetChildren()) do
if v:IsA("PostProcessEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
v.Enabled = false
end
end
task.spawn(function()
for i, v in pairs(workspace:GetDescendants()) do
if Toggles.FPSBoost and not Toggles.FPSBoost.Value then break end
pcall(function()
if v:IsA("BasePart") then
v.Material = Enum.Material.SmoothPlastic
v.CastShadow = false
elseif v:IsA("Decal") or v:IsA("Texture") then
v:Destroy()
elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
v.Enabled = false
end
end)
if i % 500 == 0 then task.wait() end
end
end)
end)
end
function gsc(guiObject)
if not guiObject then return false end
local success = false
pcall(function()
if Services.GuiService and Services.VirtualInputManager then
Services.GuiService.SelectedObject = guiObject
task.wait(0.05)
local keys = {Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter, Enum.KeyCode.ButtonA}
for _, key in ipairs(keys) do
Services.VirtualInputManager:SendKeyEvent(true, key, false, game); task.wait(0.03)
Services.VirtualInputManager:SendKeyEvent(false, key, false, game); task.wait(0.03)
end
Services.GuiService.SelectedObject = nil
success = true
end
end)
return success
end
local function FireCD(target)
if not fireclickdetector then
return
end
if not target or not target:IsA("ClickDetector") then
return
end
fireclickdetector(target)
end
local function FirePP(target, teleport)
if not fireproximityprompt then return end
if not target or not target:IsA("ProximityPrompt") then return end
local prevDist = target.MaxActivationDistance
if teleport then
local char = GetCharacter()
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local part = target.Parent
local isModel = false
if part then
if part:IsA("Model") then
isModel = true
elseif not part:IsA("BasePart") then
part = target:FindFirstAncestorWhichIsA("BasePart")
if not part then
part = target:FindFirstAncestorWhichIsA("Model")
if part then
isModel = true
end
end
end
end
if hrp and part then
local partPos = isModel and part:GetPivot().Position or part.Position
local dist = (hrp.Position - partPos).Magnitude
if dist > prevDist then
local partCFrame = isModel and part:GetPivot() or part.CFrame
hrp.CFrame = partCFrame * CFrame.new(0, 3, 0)
task.wait(0.175)
end
end
end
fireproximityprompt(target)
end
local function FireTI(target)
if not firetouchinterest then
return
end
local root = Char and Char:FindFirstChild("HumanoidRootPart")
if not root then
return
end
local part
if target:IsA("BasePart") then
part = target
else
part = target:FindFirstAncestorWhichIsA("BasePart")
end
if not part then
return
end
part.CFrame = root.CFrame
task.spawn(function()
firetouchinterest(part, root, 1)
task.wait()
firetouchinterest(part, root, 0)
end)
end
local function GetCash()
local ls = Plr:FindFirstChild("leaderstats")
local v = ls and ls:FindFirstChild("$")
return v and v.Value or 0
end
local function GetTokens()
local v = Plr:FindFirstChild("Tokens")
return v and v.Value or 0
end
local function GetWaveNumber()
local v = Plr:FindFirstChild("WaveVal")
return v and v.Value or 0
end
local function IsWaveRunning()
local wv = Plr:FindFirstChild("WaveVal")
if not wv then return false end
local prog = wv:FindFirstChild("Progress")
local mx = wv:FindFirstChild("Max")
if not prog or not mx then return false end
return prog.Value > 0 and mx.Value > 0
end
local function GetPlotBase()
local plotOV = Plr:FindFirstChild("Plot")
if not plotOV then return nil end
local v = plotOV.Value
if typeof(v) == "Instance" then return v end
return nil
end
local function GetPlotItemHolder()
local base = GetPlotBase()
if not base then return nil end
return base:FindFirstChild("ItemHolder")
end
local function Func_AutoUpgrade()
while Toggles.AutoUpgrade.Value do
local selected = Options.AutoUpgradeMode and Options.AutoUpgradeMode.Value or {}
local doTowers  = selected["Placed Towers"]
local doQuarry  = selected["Quarry"]
local doCastle  = selected["Stats"]
if doTowers then
local holder = GetPlotItemHolder()
local stats = Modules.Stats
if holder and stats then
for _, model in ipairs(holder:GetChildren()) do
if not Toggles.AutoUpgrade.Value then break end
if model:IsA("Model") then
local sok, info = pcall(stats.Get, model.Name)
if sok and info and info.Type == "Tower" and info.Next and info.Upgrade then
if GetCash() >= info.Upgrade then
pcall(function() Remotes.Upgrade:InvokeServer(model) end)
task.wait(0.3)
end
end
end
end
end
end
if doQuarry then
local ok, snap = pcall(function() return Remotes.QuarryUpgrade_Get:InvokeServer() end)
if ok and snap and snap.quarry and snap.quarry.nextCost then
local cost = snap.quarry.nextCost.amount or math.huge
if GetCash() >= cost then
pcall(function() Remotes.QuarryUpgrade_Buy:InvokeServer() end)
end
end
end
if doCastle then
local castleSelected = Options.AutoUpgradeCastleStats and Options.AutoUpgradeCastleStats.Value or {}
local ok, snap = pcall(function() return Remotes.UpgradeStore_Get:InvokeServer() end)
if ok and snap and snap.upgrades then
for name, info in pairs(snap.upgrades) do
if not Toggles.AutoUpgrade.Value then break end
if not castleSelected[name] then continue end
if info.nextCost and info.level < info.maxLevel then
if GetCash() >= info.nextCost.amount then
pcall(function() Remotes.UpgradeStore_Buy:InvokeServer(name) end)
task.wait(0.3)
end
end
end
end
end
task.wait(3)
end
end
local function Func_AutoClaimRewards()
while Toggles.AutoClaimRewards.Value do
local ok, state = pcall(function() return Remotes.GetRewardState:InvokeServer() end)
if ok and state then
local highest = state.highestWave or 0
local claimed = state.pass or {}
for w = 5, highest, 5 do
if not claimed[w] then
pcall(function() Remotes.Claim:InvokeServer({ type = "wave", tier = "normal", wave = w }) end)
task.wait(0.2)
end
end
if state.ownsPremiumPass then
local pClaimed = state.premium or {}
for w = 5, highest, 5 do
if not pClaimed[w] then
pcall(function() Remotes.Claim:InvokeServer({ type = "wave", tier = "premium", wave = w }) end)
task.wait(0.2)
end
end
end
pcall(function() Remotes.Claim:InvokeServer({ type = "playtimeAll" }) end)
task.wait(0.2)
if state.group and state.group.isInGroup and not state.group.claimed then
pcall(function() Remotes.Claim:InvokeServer({ type = "group" }) end)
end
end
task.wait(30)
end
end
local function Func_AutoDailyDeals()
while Toggles.AutoDailyDeals.Value do
local tierMode = Options.DealOption and Options.DealOption.Value or "Tier1"
local ok, snap = pcall(function() return Remotes.GetDailyDealsSnapshot:InvokeServer() end)
if ok and snap and snap.tiers then
for tierKey, info in pairs(snap.tiers) do
if not Toggles.AutoDailyDeals.Value then break end
local alreadyBought = info.cashBought and info.cashBought > 0
if alreadyBought then continue end
if tierKey == "Tier1" then
if tierMode == "Tier1" or tierMode == "All Tiers" then
pcall(function() Remotes.DailyDealClaim:InvokeServer(tierKey) end)
end
else
local buyCash = (tierMode == tierKey) or tierMode == "All Tiers"
if buyCash and info.cashPrice and GetCash() >= info.cashPrice then
pcall(function() Remotes.DailyDealClaim:InvokeServer(tierKey) end)
end
end
end
end
task.wait(2)
end
end
local function Func_AutoMerchant()
while Toggles.AutoMerchant.Value do
local ok, snap = pcall(function() return Remotes.GetMerchantSnapshot:InvokeServer() end)
if ok and snap and snap.items then
local selectedItems = Options.AutoMerchantItems and Options.AutoMerchantItems.Value or {}
local buyAll = not next(selectedItems) or selectedItems["Any"]
for _, item in ipairs(snap.items) do
if not Toggles.AutoMerchant.Value then break end
if not buyAll and not selectedItems[item.name] then continue end
if not item.owned and item.cashStockRemaining and item.cashStockRemaining > 0 then
local affordable = false
if item.currency == "Tokens" then
affordable = GetTokens() >= (item.price or math.huge)
else
affordable = GetCash() >= (item.price or math.huge)
end
if affordable then
for _ = 1, item.cashStockRemaining do
if not Toggles.AutoMerchant.Value then break end
local bok, res = pcall(function() return Remotes.MerchantPurchaseCash:InvokeServer(item.name) end)
if not (bok and res and res.ok) then break end
task.wait(0.2)
end
end
end
end
end
task.wait(45)
end
end
local function BuyShopList(list, selectedItems, stats, swordStats)
for _, item in ipairs(list) do
if not selectedItems[item.DisplayName] then continue end
local id = item.Id
if not id then continue end
local price = nil
local wsok, wstats = pcall(swordStats.Get, id)
if wsok and wstats and wstats.Price then
price = wstats.Price
else
local sok, tstats = pcall(stats.Get, id)
if sok and tstats and tstats.Price then price = tstats.Price end
end
if price and price > 0 and GetCash() >= price then
local count = tonumber(Options.AutoBuyShopCount and Options.AutoBuyShopCount.Value) or 1
pcall(function() Remotes.Purchase:FireServer(id, count) end)
task.wait(0.15)
end
end
end
local function Func_AutoBuyShop()
while Toggles.AutoBuyShop.Value do
local catalog = Modules.ShopCatalog
local stats = Modules.Stats
local swordStats = Modules.SwordStats
if catalog and stats and swordStats then
if catalog.GetRegularList then
BuyShopList(catalog.GetRegularList(), Options.AutoBuyShopItems.Value, stats, swordStats)
end
if Toggles.AutoBuyShopDecorations.Value and catalog.GetDecorationList then
BuyShopList(catalog.GetDecorationList(), Options.AutoBuyShopDecoItems.Value, stats, swordStats)
end
if Toggles.AutoBuyShopWeapons.Value and catalog.GetBlacksmithList then
BuyShopList(catalog.GetBlacksmithList(), Options.AutoBuyShopWeaponItems.Value, stats, swordStats)
end
end
task.wait(5)
end
end
local Window = Library:CreateWindow({
Title = "Yuri",
Center = true,
AutoShow = true,
Resizable = true,
ShowCustomCursor = false,
UnlockMouseWhileOpen = false,
NotifySide = "Left",
TabPadding = 8,
MenuFadeTime = 0.2
})
AddInfo(Window)
local Tabs = {
Main = Window:AddTab("Main"),
Build = Window:AddTab("Build"),
Player = Window:AddTab("Player"),
Config = Window:AddTab("Config"),
}
local A1 = Tabs.Build:AddLeftGroupbox("Build")
local A2 = Tabs.Build:AddRightGroupbox("Material")
local TB = {
Main = {
Left = {
Autofarm = Tabs.Main:AddLeftTabbox(),
},
Right = {
Autofarm = Tabs.Main:AddRightTabbox(),
},
},
}
local TB_Tabs = {
Autofarm = {
T1 = TB.Main.Left.Autofarm:AddTab("Autofarm"),
},
Autofarm2 = {
T1 = TB.Main.Right.Autofarm:AddTab("Config"),
},
}
local GB = {
Player = {
Left = {
General = Tabs.Player:AddLeftGroupbox("General"),
Server  = Tabs.Player:AddLeftGroupbox("Server"),
},
Right = {
Game = Tabs.Player:AddRightGroupbox("Game"),
},
},
}
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 250 })
local TPW_T, TPW_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "JP", Text = "JumpPower", Default = 50, Min = 0, Max = 500 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "HH", Text = "HipHeight", Default = 2, Min = 0, Max = 10, Rounding = 1 })
GB.Player.Left.General:AddToggle("Noclip", { Text = "Noclip" })
GB.Player.Left.General:AddToggle("AntiKnockback", {
Text = "Anti Knockback",
Default = false,
})
GB.Player.Left.General:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering" })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1})
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
local FPS_T, FPS_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
GB.Player.Left.General:AddToggle("FPSBoost", { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK", {
Text = "Anti AFK",
Default = true,
Disabled = not Support.Connections,
})
GB.Player.Left.Server:AddToggle("AntiKick", { Text = "Anti Kick (Client)" })
GB.Player.Left.Server:AddToggle("AutoReconnect", { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused"})
GB.Player.Left.Server:AddButton({ Text = "Serverhop", Func = function()
local Servers = game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100')
end})
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function() Services.TeleportService:Teleport(game.PlaceId, Plr) end })
GB.Player.Left.Server:AddToggle("AutoServerhop", { Text = "Auto Serverhop" })
GB.Player.Left.Server:AddSlider("AutoHopMins", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
GB.Player.Right.Game:AddToggle("InstantPP", { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog", { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("AutoUpgradeMode", {
Text = "Upgrade List",
Values = { "Placed Towers", "Quarry", "Stats" },
Default = {},
Multi = true,
Searchable = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("AutoUpgradeCastleStats", {
Text = "Stats",
Values = { "MaxUnits", "FlagDistance", "FlagHealth", "FlagRegen" },
Default = {},
Multi = true,
Searchable = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoClaimRewards", { Text = "Auto Claim Rewards", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoDailyDeals", { Text = "Auto Daily Deals", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("DealOption", {
Text = "Daily Deals List",
Values = { "Tier1", "Tier2", "Tier3", "All Tiers" },
Default = "Tier1",
})
TB_Tabs.Autofarm.T1:AddToggle("AutoMerchant", { Text = "Auto Merchant Buy", Default = false })
do
local merchantItemNames = {}
local allStats = Modules.Stats and Modules.Stats.All and Modules.Stats.All()
if allStats then
for key, data in pairs(allStats) do
if data.Price then
merchantItemNames[#merchantItemNames + 1] = key
end
end
table.sort(merchantItemNames)
table.insert(merchantItemNames, 1, "Any")
end
TB_Tabs.Autofarm2.T1:AddDropdown("AutoMerchantItems", {
Text = "Merchant Items to Buy",
Values = merchantItemNames,
Default = {},
Multi = true,
Searchable = true,
})
end
do
local catalog = Modules.ShopCatalog
local function getDisplayNames(listFn)
local names = {}
if catalog and catalog[listFn] then
for _, item in ipairs(catalog[listFn](catalog)) do
names[#names + 1] = item.DisplayName
end
end
return names
end
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyShop", { Text = "Auto Buy Units", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("AutoBuyShopItems", {
Text = "Units to Buy",
Values = getDisplayNames("GetRegularList"),
Default = {},
Multi = true,
Searchable = true
})
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyShopDecorations", { Text = "Auto Buy Decorations", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("AutoBuyShopDecoItems", {
Text = "Decorations to Buy",
Values = getDisplayNames("GetDecorationList"),
Default = {},
Multi = true,
Searchable = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyShopWeapons", { Text = "Auto Buy Weapons", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("AutoBuyShopWeaponItems", {
Text = "Weapons to Buy",
Values = getDisplayNames("GetBlacksmithList"),
Default = {},
Multi = true,
Searchable = true,
})
end
TB_Tabs.Autofarm2.T1:AddInput("AutoBuyShopCount", {
Text = "Buy Count",
Default = "1",
Placeholder = "Amount per item",
Callback = function(Value)
end,
})
Toggles.AntiKnockback:OnChanged(function(state)
Thread("AntiKnockback", Func_AntiKnockback, state)
end)
Toggles.TPW:OnChanged(function(v)
TPW_S:SetVisible(TPW_T.Value)
Thread("TPW", FuncTPW, v)
end)
Toggles.Noclip:OnChanged(function(v)
Thread("Noclip", FuncNoclip, v)
end)
Toggles.AutoUpgrade:OnChanged(function(v)
Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), v)
end)
Toggles.AutoClaimRewards:OnChanged(function(v)
Thread("AutoClaimRewards", SafeLoop("AutoClaimRewards", Func_AutoClaimRewards), v)
end)
Toggles.AutoDailyDeals:OnChanged(function(v)
Thread("AutoDailyDeals", SafeLoop("AutoDailyDeals", Func_AutoDailyDeals), v)
end)
Toggles.AutoMerchant:OnChanged(function(v)
Thread("AutoMerchant", SafeLoop("AutoMerchant", Func_AutoMerchant), v)
end)
Toggles.AutoBuyShop:OnChanged(function(v)
Thread("AutoBuyShop", SafeLoop("AutoBuyShop", Func_AutoBuyShop), v)
end)
Connections.Player_General = RunService.Stepped:Connect(function()
local Hum = Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")
if Hum then
if Toggles.WS.Value then Hum.WalkSpeed = Options.WSValue.Value end
if Toggles.JP.Value then Hum.JumpPower = Options.JPValue.Value Hum.UseJumpPower = true end
if Toggles.HH.Value then Hum.HipHeight = Options.HHValue.Value end
end
workspace.Gravity = Toggles.Grav.Value and Options.GravValue.Value or 192
if Toggles.FOV.Value then workspace.CurrentCamera.FieldOfView = Options.FOVValue.Value end
if Toggles.Zoom.Value then Plr.CameraMaxZoomDistance = Options.ZoomValue.Value end
end)
task.spawn(function()
while task.wait() do
if Toggles.Fullbright.Value then
Lighting.Brightness = 2
Lighting.ClockTime = 14
Lighting.GlobalShadows = false
elseif Toggles.OverrideTime.Value then
Lighting.ClockTime = Options.OverrideTimeValue.Value
end
if Toggles.NoFog.Value then Lighting.FogEnd = 9e9 end
if Library.Unloaded then break end
end
end)
Options.LimitFPSValue:OnChanged(function()
if FPS_T.Value then
setfpscap(FPS_S.Value)
end
end)
Toggles.LimitFPS:OnChanged(function(v)
FPS_S:SetVisible(FPS_T.Value)
if not v then
setfpscap(999)
end
end)
Toggles.Disable3DRender:OnChanged(function(v) RunService:Set3dRenderingEnabled(not v) end)
Toggles.FPSBoost:OnChanged(function(state)
ApplyFPSBoost(state)
end)
Toggles.AutoReconnect:OnChanged(function(state)
if state then Func_AutoReconnect() end
end)
Toggles.NoGameplayPaused:OnChanged(function(state)
Thread("NoGameplayPaused", SafeLoop("Anti-Pause", Func_NoGameplayPaused), state)
end)
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
if Toggles.InstantPP and Toggles.InstantPP.Value then
prompt.HoldDuration = 0
end
end)
local function RunAntiAFK()
local GC = getconnections or get_signal_cons
if GC then
for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
if v["Disable"] then
v["Disable"](v)
elseif v["Disconnect"] then
v["Disconnect"](v)
end
end
else
local VirtualUser = cloneref(game:GetService("VirtualUser"))
Players.LocalPlayer.Idled:Connect(function()
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end)
end
end
Toggles.AntiAFK:OnChanged(function(state)
if state then RunAntiAFK() end
end)
if Toggles.AntiAFK.Value then RunAntiAFK() end
local _cachedV16 = nil
local function getPlacementHandler()
if _cachedV16 and type(_cachedV16) == "table" and type(_cachedV16.GetAvailableItemCount) == "function" then
return _cachedV16
end
local dbgGetUpvals = (debug and (debug.getupvalues or debug.getupvals)) or getupvalues or getupvals
local islclosureFn = islclosure or is_l_closure or function() return true end
if not (getgc and dbgGetUpvals) then return nil end
local targetScript = Plr:FindFirstChild("PlayerGui")
and Plr.PlayerGui:FindFirstChild("Build")
and Plr.PlayerGui.Build:FindFirstChild("InventoryHandler")
if not targetScript then
notyuri("[AutoBuild] InventoryHandler script not found")
return nil
end
local ok, gc = pcall(getgc, false)
if not ok or type(gc) ~= "table" then return nil end
for _, fn in ipairs(gc) do
if type(fn) ~= "function" then continue end
if not islclosureFn(fn) then continue end
local ok2, env = pcall(getfenv, fn)
if not ok2 or type(env) ~= "table" then continue end
if rawget(env, "script") ~= targetScript then continue end
local ok3, uvs = pcall(dbgGetUpvals, fn)
if not ok3 or type(uvs) ~= "table" then continue end
for _, uv in ipairs(uvs) do
if type(uv) == "table" and type(uv.GetAvailableItemCount) == "function" then
_cachedV16 = uv
notyuri("[AutoBuild] PlacementHandler (v16) extracted via upvalue")
return _cachedV16
end
end
end
notyuri("[AutoBuild] Could not find PlacementHandler upvalue, falling back to snapshot count")
return nil
end
local function getAvailableCount(itemName, fallbackCount)
local v16 = getPlacementHandler()
if v16 then
local ok, result = pcall(function() return v16:GetAvailableItemCount(itemName) end)
if ok and tonumber(result) then
return math.max(0, math.floor(tonumber(result)))
end
end
return fallbackCount or 0
end
local function DoPlace(itemName, targetCF)
local ok, result = pcall(function()
return Remotes.Place:InvokeServer(itemName, targetCF)
end)
notyuri("[AutoBuild] Place remote result:", tostring(result), "type:", typeof(result))
return ok and (typeof(result) == "Instance" or result == true)
end
local KNOWN_MELEE = {"legionary", "paladin", "ironrevenant", "shieldgolem"}
local function getItemRole(itemName, stat)
if not stat then return "other" end
local t = stat.Type or ""
if t == "WoodStructure" or t == "StoneStructure" or t:find("Structure") then
return "structure"
end
if t == "Decoration" or t == "Prop" then
return "decoration"
end
if t == "Tower" or t == "Champion" then
local lname = itemName:lower()
for _, m in ipairs(KNOWN_MELEE) do
if lname:find(m, 1, true) then return "melee" end
end
local range = tonumber(stat.Range) or 999
if range < 80 then return "melee" end
return "ranged"
end
return "other"
end
local function getScore(role, stat)
if not stat then return 0 end
local dmg = tonumber(stat.Damage) or 0
local spd = tonumber(stat.Speed) or 1
local rng = tonumber(stat.Range) or 0
local hp  = tonumber(stat.Health) or 0
local dps = spd > 0 and dmg / spd or 0
if role == "structure" then return hp end
if role == "melee"     then return dmg end
if role == "ranged"    then return dps * rng end
return 0
end
local _rayParams = RaycastParams.new()
_rayParams.FilterType = Enum.RaycastFilterType.Exclude
_rayParams.FilterDescendantsInstances = { Plr.Character }
local function Ground(worldX, worldZ, fallbackY)
local origin = Vector3.new(worldX, fallbackY + 500, worldZ)
local result = workspace:Raycast(origin, Vector3.new(0, -1000, 0), _rayParams)
if result then
return result.Position.Y + 3
end
return fallbackY
end
local function makeSlots(plotCF, plotSize, flagWorldPos, spawnWorldPos)
local plotCenter = plotCF.Position
local fallbackY  = plotCF.Position.Y
local toSpawnRaw = Vector3.new(spawnWorldPos.X - flagWorldPos.X, 0, spawnWorldPos.Z - flagWorldPos.Z)
local toSpawn    = toSpawnRaw.Unit  
local sideways   = Vector3.new(-toSpawn.Z, 0, toSpawn.X)  
local flagOffset = (flagWorldPos - plotCenter)
local flagFwd    = flagOffset:Dot(toSpawn)
local flagSide   = flagOffset:Dot(sideways)
local hw         = tonumber(Options.AutoBuildPlaceDistance and Options.AutoBuildPlaceDistance.Value) or 20
local hd         = math.max(15, plotSize.Z / 2 - 3)
local facingCF   = CFrame.lookAlong(Vector3.new(), toSpawn)
local slots      = { structure = {}, melee = {}, ranged = {}, decoration = {}, other = {} }
local wSpc = 2
local uSpc = 3
local wCols = math.floor(hw * 2 / wSpc)
local uCols = math.floor(hw * 2 / uSpc)
local function makeSlotCF(fwdDist, sideDist)
local worldPos = plotCenter + toSpawn * (flagFwd + fwdDist) + sideways * (flagSide + sideDist)
local y = Ground(worldPos.X, worldPos.Z, fallbackY)
return CFrame.new(worldPos.X, y, worldPos.Z) * facingCF
end
local structFwdBase = 26
for row = 0, 1 do
for col = 0, wCols do
local side = -hw + col * wSpc
local fwd  = structFwdBase + row * wSpc
slots.structure[#slots.structure + 1] = makeSlotCF(fwd, side)
end
end
local meleeFwdBase = structFwdBase + 2 * wSpc + 6
for row = 0, 2 do
for col = 0, uCols do
local side = -hw + col * uSpc
local fwd  = meleeFwdBase + row * uSpc
slots.melee[#slots.melee + 1] = makeSlotCF(fwd, side)
end
end
local rangedFwdBase = meleeFwdBase + 3 * uSpc + 4
for row = 0, 8 do
for col = 0, uCols do
local side = -hw + col * uSpc
local fwd  = rangedFwdBase + row * uSpc
if fwd <= hd then
slots.ranged[#slots.ranged + 1] = makeSlotCF(fwd, side)
end
end
end
notyuri("[AutoBuild] makeSlots hw:", hw, "hd:", hd, "wCols:", wCols, "uCols:", uCols, "structFwdBase:", structFwdBase)
for i = 0, 40 do
local side = -hw + (i % (uCols + 1)) * uSpc
local fwd  = rangedFwdBase + (8 + 1) * uSpc + math.floor(i / (uCols + 1)) * uSpc
if fwd <= hd then
slots.decoration[#slots.decoration + 1] = makeSlotCF(fwd, side)
slots.other[#slots.other + 1]            = makeSlotCF(fwd + uSpc, side + 2)
end
end
return slots
end
local BUILD_SAVE_FOLDER = "Yuri/CastleDefender/Build"
local RefreshBuildSourcesDropdown
local function CFrameToTable(cf)
local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cf:GetComponents()
return { x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 }
end
local function TableToCFrame(t)
if type(t) ~= "table" or #t < 12 then return CFrame.new() end
return CFrame.new(
t[1], t[2], t[3], t[4], t[5], t[6],
t[7], t[8], t[9], t[10], t[11], t[12]
)
end
local function GetPlotPivot(plotBase)
local base = plotBase or GetPlotBase()
if not base then return nil end
if base:IsA("Model") then return base:GetPivot() end
if base:IsA("BasePart") then return base.CFrame end
return nil
end
local function GetAllPlots()
local plots = workspace:FindFirstChild("Plots")
if not plots then return {} end
local out = {}
local ourBase = GetPlotBase()
for _, base in ipairs(plots:GetChildren()) do
if base:IsA("Model") then
local ownerName = "Unknown"
pcall(function()
local board = base:FindFirstChild("Board")
local frame = board and board:FindFirstChild("Frame")
local sg = frame and frame:FindFirstChild("SurfaceGui")
local occ = sg and sg:FindFirstChild("Occupied")
if occ and occ.Visible then
local un = occ:FindFirstChild("Username")
if un and un:IsA("TextLabel") and un.Text ~= "" then
ownerName = un.Text
end
end
end)
table.insert(out, { base = base, ownerName = ownerName, isOurs = (base == ourBase) })
end
end
return out
end
local function GetPlacedBlocksFromPlot(plotBase)
if not plotBase then return {} end
local holder = plotBase:FindFirstChild("ItemHolder")
if not holder then return {} end
local blocks = {}
for _, model in ipairs(holder:GetChildren()) do
if model:IsA("Model") then
local cf = model:GetPivot()
if cf then
table.insert(blocks, { name = model.Name, cf = cf })
end
end
end
return blocks
end
local function GetPlacedBlocks()
return GetPlacedBlocksFromPlot(GetPlotBase())
end
local function SerializeBlocks(blocks, plotBase)
local plotCF = GetPlotPivot(plotBase)
if not plotCF then return nil end
if #blocks == 0 then return nil end
local relative = plotCF:Inverse()
local data = { version = 1, count = #blocks, blocks = {} }
for _, b in ipairs(blocks) do
local relCF = relative * b.cf
table.insert(data.blocks, {
name = b.name,
cf = CFrameToTable(relCF),
})
end
return HttpService:JSONEncode(data)
end
local function CopyBuildToJSON(plotBase)
local blocks = GetPlacedBlocksFromPlot(plotBase)
if #blocks == 0 then
Library:Notify("No placed blocks found to copy.", 4)
return nil
end
local json = SerializeBlocks(blocks, plotBase)
notyuri("[CopyBuild] serialized", #blocks, "blocks")
return json
end
local function GetBuildRequirements(data)
local reqs = {}
if type(data) ~= "table" or type(data.blocks) ~= "table" then return reqs end
for _, entry in ipairs(data.blocks) do
local n = entry.name
if n then reqs[n] = (reqs[n] or 0) + 1 end
end
return reqs
end
local function GetInventoryItems()
local invOk, inv = pcall(function() return Remotes.GetBuildInventory:InvokeServer() end)
if invOk and inv and inv.ok and type(inv.items) == "table" then
return inv.items
end
return {}
end
local function ComputeMissingMaterials(reqs, invItems)
local missing = {}
local parts = {}
local v16 = getPlacementHandler()
local baseReqs = {}
for itemName, need in pairs(reqs) do
local base = itemName:gsub("Lv%d+$", "")
baseReqs[base] = (baseReqs[base] or 0) + need
end
local baseInvCount = {}
for k, v in pairs(invItems) do
local base = k:gsub("Lv%d+$", "")
baseInvCount[base] = (baseInvCount[base] or 0) + (tonumber(v) or 0)
end
for base, need in pairs(baseReqs) do
local have = 0
if v16 then
local ok, allStats = pcall(function() return Modules.Stats.All() end)
if ok and type(allStats) == "table" then
for name in pairs(allStats) do
if name:gsub("Lv%d+$", "") == base then
local okA, cnt = pcall(function() return v16:GetAvailableItemCount(name) end)
if okA and tonumber(cnt) then have = have + tonumber(cnt) end
end
end
else
local okA, cnt = pcall(function() return v16:GetAvailableItemCount(base) end)
if okA and tonumber(cnt) then have = tonumber(cnt) end
end
else
have = baseInvCount[base] or 0
end
if have < need then
local short = need - have
missing[base] = short
table.insert(parts, base .. "(x" .. short .. ")")
end
end
table.sort(parts)
local display
if #parts == 0 then
display = "Ready"
else
display = "Missing: " .. table.concat(parts, ", ")
end
return missing, display
end
local function SaveBuildToFile(saveName)
if not saveName or saveName == "" then
Library:Notify("Enter a file name first.", 3)
return
end
if not Support.FileIO then
Library:Notify("File IO not supported by executor.", 4)
return
end
local json = CopyBuildToJSON(GetPlotBase())
if not json then return end
local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
pcall(function()
if makefolder then pcall(makefolder, BUILD_SAVE_FOLDER) end
writefile(path, json)
end)
local count = tonumber(json:match('"count":(%d+)')) or 0
Library:Notify(("Build saved to %s (%d blocks)"):format(saveName, count), 5)
notyuri("[CopyBuild] saved to", path)
RefreshBuildSourcesDropdown()
end
local function CopyBuildToClipboard()
local json = CopyBuildToJSON(GetPlotBase())
if not json then return end
if setclipboard then
pcall(setclipboard, json)
Library:Notify(("Build copied to clipboard (%d chars)."):format(#json), 5)
else
Library:Notify("Clipboard not supported by executor.", 4)
end
end
local function LoadBuildJSON(json)
if not json or json == "" then return nil end
local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
if not ok or type(data) ~= "table" or type(data.blocks) ~= "table" then
Library:Notify("Invalid build JSON.", 4)
return nil
end
return data
end
local function LoadBuildFromFile(saveName)
if not saveName or saveName == "" then return nil end
if not Support.FileIO then return nil end
local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
if not isfile(path) then return nil end
local ok, json = pcall(readfile, path)
if not ok or not json then return nil end
return LoadBuildJSON(json)
end
local function ListBuildFiles()
local files = {}
if not Support.FileIO or not isfolder then return files end
pcall(function()
if not isfolder(BUILD_SAVE_FOLDER) then return end
for _, name in ipairs(listfiles(BUILD_SAVE_FOLDER)) do
if name:sub(-5) == ".json" then
local short = name:match("([^/\\]+)%.json$")
if short then table.insert(files, short) end
end
end
end)
table.sort(files)
return files
end
local _buildSourcesLookup = {}
RefreshBuildSourcesDropdown = function()
if not Options.BuildSourceDropdown then return end
local plots = GetAllPlots()
local files = ListBuildFiles()
local values = {}
_buildSourcesLookup = {}
for _, p in ipairs(plots) do
local prefix = p.isOurs and "[My Plot] " or "[Plot] "
local display = prefix .. p.ownerName
table.insert(values, display)
_buildSourcesLookup[display] = { type = "plot", base = p.base, ownerName = p.ownerName }
end
for _, fname in ipairs(files) do
local display = "[File] " .. fname
table.insert(values, display)
_buildSourcesLookup[display] = { type = "file", name = fname }
end
Options.BuildSourceDropdown:SetValues(values)
notyuri("[CopyBuild] dropdown refreshed:", #values, "sources")
end
local function LoadSelectedBuildSource()
local sel = Options.BuildSourceDropdown and Options.BuildSourceDropdown.Value
if not sel or sel == "" then
Library:Notify("Select a base or file first.", 3)
return nil
end
local entry = _buildSourcesLookup[sel]
if not entry then
Library:Notify("Unknown source: " .. sel, 4)
return nil
end
if entry.type == "plot" then
local blocks = GetPlacedBlocksFromPlot(entry.base)
if #blocks == 0 then
Library:Notify("That plot has no placed blocks.", 4)
return nil
end
local json = SerializeBlocks(blocks, entry.base)
return LoadBuildJSON(json)
elseif entry.type == "file" then
return LoadBuildFromFile(entry.name)
end
return nil
end
local MatLabel = nil
local function UpdateMaterialLabel()
if not MatLabel then return end
local data = LoadSelectedBuildSource()
if not data then
MatLabel:SetText("No build selected.")
return
end
local reqs = GetBuildRequirements(data)
local invItems = GetInventoryItems()
local _, display = ComputeMissingMaterials(reqs, invItems)
MatLabel:SetText(display)
notyuri("[CopyBuild] material:", display)
end
local function ResolveBuildItemName(itemName, v16, invItems)
if v16 then
local ok, cnt = pcall(function() return v16:GetAvailableItemCount(itemName) end)
if ok and tonumber(cnt) and tonumber(cnt) > 0 then return itemName end
else
if (tonumber(invItems[itemName]) or 0) > 0 then return itemName end
end
local baseName = itemName:match("^(.-)Lv%d+$")
if not baseName then return nil end
local candidates = {}
if Modules.Stats then
local ok, allStats = pcall(function() return Modules.Stats.All() end)
if ok and type(allStats) == "table" then
for name in pairs(allStats) do
if name:match("^(.-)Lv%d+$") == baseName then
table.insert(candidates, name)
end
end
end
end
table.sort(candidates, function(a, b)
local la = tonumber(a:match("Lv(%d+)$")) or 0
local lb = tonumber(b:match("Lv(%d+)$")) or 0
return la > lb
end)
for _, candidate in ipairs(candidates) do
if v16 then
local ok, cnt = pcall(function() return v16:GetAvailableItemCount(candidate) end)
if ok and tonumber(cnt) and tonumber(cnt) > 0 then
notyuri("[LoadBuild] fallback", itemName, "->", candidate)
return candidate
end
else
if (tonumber(invItems[candidate]) or 0) > 0 then
notyuri("[LoadBuild] fallback", itemName, "->", candidate)
return candidate
end
end
end
return nil
end
local function RunBuildFromSelectedSource()
local data = LoadSelectedBuildSource()
if not data then return end
local plotCF = GetPlotPivot()
if not plotCF then
Library:Notify("No plot found", 4)
return
end
local holder = GetPlotItemHolder()
local ConfirmRad = 3
local MaxPending = 5
local Timeout = 0.5
local MaxRetries = 2
local pending = {}
local placed, skipped, confirmed = 0, 0, 0
notyuri("[LoadBuild] starting, blocks:", #data.blocks, "plotCF:", tostring(plotCF.Position))
local conn
if holder then
conn = holder.ChildAdded:Connect(function(child)
if not child:IsA("Model") then
notyuri("[LoadBuild] ChildAdded: ignored non-Model", child.ClassName, child.Name)
return
end
local pp = child:WaitForChild("Primary", 1)
if not pp then
pp = child:FindFirstChildWhichIsA("BasePart")
if pp then
notyuri("[LoadBuild] ChildAdded: no 'Primary', using BasePart", pp.Name, "pos:", tostring(pp.Position))
else
notyuri("[LoadBuild] ChildAdded: Model", child.Name, "has no Primary or BasePart, skipping")
return
end
end
local matched = false
for i, p in ipairs(pending) do
local dist = (pp.Position - p.Position).Magnitude
if dist < ConfirmRad then
table.remove(pending, i)
confirmed = confirmed + 1
matched = true
notyuri("[LoadBuild] confirmed:", child.Name, "dist:", string.format("%.2f", dist), "pending:", #pending, "total confirmed:", confirmed)
break
end
end
if not matched then
notyuri("[LoadBuild] ChildAdded: no pending match for", child.Name, "at", tostring(pp.Position), "pending size:", #pending)
end
end)
end
local invItems = GetInventoryItems()
for idx, entry in ipairs(data.blocks) do
if not Toggles.LoadBuild.Value then
notyuri("[LoadBuild] toggle off, stopping at block", idx)
break
end
local itemName = entry.name
local relCF = TableToCFrame(entry.cf)
local worldCF = plotCF * relCF
local v16 = getPlacementHandler()
local actualName = ResolveBuildItemName(itemName, v16, invItems)
if actualName then
notyuri("[LoadBuild] placing", actualName, "block", idx, "pos:", tostring(worldCF.Position))
table.insert(pending, { Position = worldCF.Position, itemName = actualName, cf = worldCF, retries = 0 })
DoPlace(actualName, worldCF)
placed = placed + 1
local t0 = tick()
while #pending > MaxPending do
if tick() - t0 > Timeout then
local oldest = table.remove(pending, 1)
if oldest.retries < MaxRetries then
oldest.retries = oldest.retries + 1
notyuri("[LoadBuild] throttle timeout, retrying", oldest.itemName, "attempt", oldest.retries, "/", MaxRetries)
DoPlace(oldest.itemName, oldest.cf)
table.insert(pending, oldest)
else
notyuri("[LoadBuild] throttle timeout, giving up on", oldest.itemName, "after", MaxRetries, "retries")
end
t0 = tick()
end
task.wait()
end
else
notyuri("[LoadBuild] skipping", itemName, "block", idx, "- not in inventory")
skipped = skipped + 1
end
end
notyuri("[LoadBuild] main loop done. placed:", placed, "skipped:", skipped, "confirmed:", confirmed, "pending:", #pending)
local t0 = tick()
while #pending > 0 do
if tick() - t0 > Timeout then
local oldest = table.remove(pending, 1)
if oldest.retries < MaxRetries then
oldest.retries = oldest.retries + 1
notyuri("[LoadBuild] drain timeout, retrying", oldest.itemName, "attempt", oldest.retries, "/", MaxRetries)
DoPlace(oldest.itemName, oldest.cf)
table.insert(pending, oldest)
else
notyuri("[LoadBuild] drain timeout, giving up on", oldest.itemName, "after", MaxRetries, "retries")
end
t0 = tick()
end
task.wait()
end
if #pending == 0 then
notyuri("[LoadBuild] all confirmed ok")
end
pending = {}
if conn then conn:Disconnect() end
Toggles.LoadBuild:SetValue(false)
Library:Notify(("Build loaded: %d placed, %d skipped."):format(placed, skipped), 5)
UpdateMaterialLabel()
end
local function RunAutoBuild()
local ok, ctx = pcall(function()
return Remotes.GetBuildContext:InvokeServer("Place")
end)
if not ok or type(ctx) ~= "table" or ctx.ok ~= true then
notyuri("[AutoBuild] GetBuildContext failed:", tostring(ctx))
return
end
notyuri("[AutoBuild] ctx.ok:", tostring(ctx.ok), "canPlace:", tostring(ctx.canPlace), "plot:", tostring(ctx.plot))
if ctx.canPlace ~= true then
return
end
local plot = ctx.plot
if not plot or not plot.Size then
return
end
local ok2, inv = pcall(function()
return Remotes.GetBuildInventory:InvokeServer()
end)
notyuri("[AutoBuild] inv.ok:", tostring(inv and inv.ok), "items type:", type(inv and inv.items))
if not ok2 or type(inv) ~= "table" or inv.ok ~= true or type(inv.items) ~= "table" then
notyuri("[AutoBuild] GetBuildInventory failed:", tostring(inv))
return
end
local Stats = Modules.Stats
if not Stats then
return
end
local buildItemsFilter = Options.AutoBuildItems and Options.AutoBuildItems.Value or { Any = true }
local filterAny = buildItemsFilter["Any"]
local byRole = { structure = {}, melee = {}, ranged = {}, decoration = {}, other = {} }
for itemName, rawCount in pairs(inv.items) do
local cnt = tonumber(rawCount) or 0
if cnt <= 0 then continue end
if not filterAny and not buildItemsFilter[itemName] then continue end
local stat = Stats.Get(itemName)
if not stat then continue end
local role = getItemRole(itemName, stat)
byRole[role][#byRole[role] + 1] = {
name  = itemName,
count = cnt,
score = getScore(role, stat),
}
end
for _, list in pairs(byRole) do
table.sort(list, function(a, b) return a.score > b.score end)
end
local plotCF   = plot:GetPivot()
local plotSize = plot.Size
local base = ctx.base or plot.Parent
local flagWorldPos  = nil
local spawnWorldPos = nil
if base then
local flagModel = base:FindFirstChild("Flag")
local zoneModel = base:FindFirstChild("Zone")
local flagPrimary = flagModel and (flagModel:FindFirstChild("Primary") or flagModel:FindFirstChildWhichIsA("BasePart"))
local spawnPart   = zoneModel and (zoneModel:FindFirstChild("SpawnZone") or zoneModel:FindFirstChildWhichIsA("BasePart"))
if flagPrimary then
flagWorldPos = flagPrimary.Position
notyuri("[AutoBuild] flagWorldPos:", tostring(flagWorldPos))
else
notyuri("[AutoBuild] Flag Primary not found, using plot center as flag pos")
end
if spawnPart then
spawnWorldPos = spawnPart.Position
notyuri("[AutoBuild] spawnWorldPos:", tostring(spawnWorldPos))
else
notyuri("[AutoBuild] SpawnZone not found, using plot center offset as spawn pos")
end
end
if not flagWorldPos then
flagWorldPos = (plotCF * CFrame.new(0, 0, plotSize.Z / 2)).Position
end
if not spawnWorldPos then
spawnWorldPos = (plotCF * CFrame.new(0, 0, -plotSize.Z / 2)).Position
end
local slots = makeSlots(plotCF, plotSize, flagWorldPos, spawnWorldPos)
local roleOrder = {"structure", "melee", "ranged", "decoration", "other"}
local totalPlaced = 0
for _, role in ipairs(roleOrder) do
if (role == "decoration" or role == "other") then continue end
local slotIdx = 1
for _, item in ipairs(byRole[role]) do
local placed = 0
while placed < item.count do
if not Toggles.AutoBaseBuild.Value then
notyuri("[AutoBuild] Stopped by toggle")
return
end
if slotIdx > #slots[role] then
notyuri("[AutoBuild] Out of", role, "slots after", placed, "of", item.count, item.name)
break
end
local available = getAvailableCount(item.name, item.count - placed)
if available <= 0 then
notyuri("[AutoBuild] No more available:", item.name)
break
end
local cf = slots[role][slotIdx]
slotIdx = slotIdx + 1
notyuri("[AutoBuild] Attempting Place:", item.name, "slot", slotIdx - 1, "cf", tostring(cf))
local success = DoPlace(item.name, cf)
if success then
placed = placed + 1
totalPlaced = totalPlaced + 1
else
notyuri("[AutoBuild] Place failed for", item.name)
end
task.wait()
end
end
end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoBaseBuild", {
Text    = "Auto Base Build",
Default = false,
Callback = function(state)
if state then
local env = getfenv(1)
local t = task.spawn(RunAutoBuild)
Flags.AutoBaseBuild = t
env._autobuild_thread = t
else
if Flags.AutoBaseBuild and typeof(Flags.AutoBaseBuild) == "thread" then
task.cancel(Flags.AutoBaseBuild)
Flags.AutoBaseBuild = nil
end
getfenv(1)._autobuild_thread = nil
end
end,
})
do
local _cat = Modules.ShopCatalog
local _allIds = { "Any" }
if _cat then
for _, listFn in ipairs({ "GetRegularList" }) do
if _cat[listFn] then
for _, item in ipairs(_cat[listFn](_cat)) do
if item.Id then
_allIds[#_allIds + 1] = item.Id
end
end
end
end
end
table.sort(_allIds, function(a, b)
if a == "Any" then return true end
if b == "Any" then return false end
return a < b
end)
TB_Tabs.Autofarm2.T1:AddInput("AutoBuildPlaceDistance", {
Text = "Place Distance",
Default = "20",
Numeric = true,
Callback = function(Value) end,
})
TB_Tabs.Autofarm2.T1:AddDropdown("AutoBuildItems", {
Text       = "Build Items",
Values     = _allIds,
Default    = { "Any" },
Multi      = true,
Searchable = true,
})
end
A1:AddDropdown("BuildSourceDropdown", {
Text = "Select Buid to Load",
Values = {},
Default = "",
Multi = false,
Searchable = true,
Callback = function()
UpdateMaterialLabel()
end,
})
MatLabel = A2:AddLabel("No build selected.", true)
A1:AddButton({
Text = "Buy Missing Items",
Func = function()
local data = LoadSelectedBuildSource()
if not data then
Library:Notify("Select a build source first.", 3)
return
end
local reqs = GetBuildRequirements(data)
local invItems = GetInventoryItems()
local missing, display = ComputeMissingMaterials(reqs, invItems)
local anyMissing = false
for _ in pairs(missing) do anyMissing = true break end
if not anyMissing then
Library:Notify("No missing items.", 4)
return
end
local catalog = Modules.ShopCatalog
local baseToShopId = {}
if catalog then
for _, listFn in ipairs({ "GetRegularList", "GetDecorationList", "GetBlacksmithList" }) do
if catalog[listFn] then
for _, item in ipairs(catalog[listFn](catalog)) do
if item.Id then
baseToShopId[item.Id] = item.Id
local base = item.Id:match("^(.-)Lv%d+$")
if base then
baseToShopId[base] = item.Id
end
end
end
end
end
end
local stats = Modules.Stats
local swordStats = Modules.SwordStats
local bought, failed, skipped = 0, 0, 0
for itemName, shortage in pairs(missing) do
local shopId = baseToShopId[itemName]
if not shopId then
local base = itemName:match("^(.-)Lv%d+$")
if base then shopId = baseToShopId[base] end
end
if not shopId then
notyuri("[BuyMissing] No shop entry found for:", itemName)
skipped = skipped + 1
else
local price = nil
if swordStats then
local ok, ws = pcall(swordStats.Get, shopId)
if ok and ws and ws.Price then price = ws.Price end
end
if not price and stats then
local ok, st = pcall(stats.Get, shopId)
if ok and st and st.Price then price = st.Price end
end
if not price or price <= 0 then
notyuri("[BuyMissing] No price found for:", shopId)
skipped = skipped + 1
elseif GetCash() < price then
notyuri("[BuyMissing] Not enough cash for:", shopId, "need", price, "have", GetCash())
skipped = skipped + 1
else
local ok2 = pcall(function() Remotes.Purchase:FireServer(shopId, shortage) end)
if ok2 then
bought = bought + shortage
notyuri("[BuyMissing] bought", shortage, "x", shopId, "(for", itemName .. ")")
else
failed = failed + 1
notyuri("[BuyMissing] purchase failed for:", shopId)
end
task.wait(0.15)
end
end
end
Library:Notify(("Buy Missing: +%d items, %d skipped, %d failed"):format(bought, skipped, failed), 5)
UpdateMaterialLabel()
end,
})
A1:AddToggle("LoadBuild", {
Text = "Load Build",
Default = false,
Callback = function(state)
if state then
local t = task.spawn(function()
while Toggles.LoadBuild.Value do
RunBuildFromSelectedSource()
task.wait(5)
end
end)
Flags.LoadBuild = t
else
if Flags.LoadBuild and typeof(Flags.LoadBuild) == "thread" then
task.cancel(Flags.LoadBuild)
Flags.LoadBuild = nil
end
end
end,
})
A1:AddInput("BuildSaveName", {
Text = "File Name",
Default = "",
Placeholder = "yuriyuri",
Callback = function() end,
})
A1:AddButton({
Text = "Save Build",
Func = function()
SaveBuildToFile(Options.BuildSaveName and Options.BuildSaveName.Value or "")
end,
})
A1:AddButton({
Text = "Save Selected",
Func = function()
local saveName = Options.BuildSaveName and Options.BuildSaveName.Value or ""
if not saveName or saveName == "" then
Library:Notify("Enter a file name first.", 3)
return
end
if not Support.FileIO then
Library:Notify("File IO not supported by executor.", 4)
return
end
local data = LoadSelectedBuildSource()
if not data then return end
local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
if not ok or not json then
Library:Notify("Failed to encode build data.", 4)
return
end
local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
pcall(function()
if makefolder then pcall(makefolder, BUILD_SAVE_FOLDER) end
writefile(path, json)
end)
local count = type(data.blocks) == "table" and #data.blocks or 0
Library:Notify(("Selected build saved to %s (%d blocks)"):format(saveName, count), 5)
notyuri("[CopyBuild] selected saved to", path)
RefreshBuildSourcesDropdown()
end,
})
task.spawn(function()
task.wait(2)
RefreshBuildSourcesDropdown()
end)
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("AutoShowUI", {
Text = "Auto Show UI",
Default = true,
})
MenuGroup:AddToggle("KeybindMenuOpen", {
Default = Library.KeybindFrame.Visible,
Text = "Open Keybind Menu",
Callback = function(value)
Library.KeybindFrame.Visible = value
end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
Text = "Custom Cursor",
Default = false,
Callback = function(Value)
Library.ShowCustomCursor = Value
end,
})
MenuGroup:AddDropdown("NotificationSide", {
Values = { "Left", "Right" },
Default = "Right",
Text = "Notification Side",
Callback = function(Value)
Library:SetNotifySide(Value)
end,
})
MenuGroup:AddDropdown("DPIDropdown", {
Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
Default = "100%",
Text = "DPI Scale",
Callback = function(Value)
Value = Value:gsub("%%", "")
local DPI = tonumber(Value)
Library:SetDPIScale(DPI)
end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
:AddKeyPicker("MenuKeybind", { Default = "U", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function()
getgenv().ayasemiyatongekissazumirisa = false
Shared.Farm = false
Cleanup(Connections)
Cleanup(Flags)
Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/CastleDefender")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
SaveManager:LoadAutoloadConfig()
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
Library:SetDPIScale(100)
end
Library:Notify("Script loaded.", 2)
Library:Notify("Yuri!", 5)
end)
if not eh_success then
Library:Notify("ERROR: " .. tostring(err), 4)
notyuri("ERROR: " .. tostring(err))
end
elseif game.GameId == 9870850309 then
if getgenv().ayasemiyatongekissazumirisa then
warn("yuri")
return
end
function missing(t, f, fallback)
if type(f) == t then return f end
return fallback
end
cloneref = missing("function", cloneref, function(...) return ... end)
getgc = missing("function", getgc or get_gc_objects)
getconnections = missing("function", getconnections or get_signal_cons)
Services = setmetatable({}, {
__index = function(self, name)
local success, cache = pcall(function()
return cloneref(game:GetService(name))
end)
if success then
rawset(self, name, cache)
return cache
else
error("Invalid Service: " .. tostring(name))
end
end
})
local Players = Services.Players
local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local PGui = Plr:WaitForChild("PlayerGui")
local Lighting = game:GetService('Lighting');
local RS = Services.ReplicatedStorage
local RunService = Services.RunService
local HttpService = Services.HttpService
local GuiService = Services.GuiService
local TeleportService = Services.TeleportService
local Marketplace = Services.MarketplaceService
local UIS = Services.UserInputService
local VirtualUser = Services.VirtualUser
local v, Asset = pcall(function()
return Marketplace:GetProductInfo(game.PlaceId)
end)
local assetName = "game name"
if v and Asset then
assetName = Asset.Name
end
local Support = {
Webhook = (typeof(request) == "function" or typeof(http_request) == "function"),
Clipboard = (typeof(setclipboard) == "function"),
FileIO = (typeof(writefile) == "function" and typeof(isfile) == "function"),
QueueOnTeleport = (typeof(queue_on_teleport) == "function"),
Connections = (typeof(getconnections) == "function"),
FPS = (typeof(setfpscap) == "function"),
Proximity = (typeof(fireproximityprompt) == "function"),
}
local executorName = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local LimitedExecutors = {"xeno", "solara",}
local isLimitedExecutor = false
for _, name in ipairs(LimitedExecutors) do
if string.find(executorName, name) then
isLimitedExecutor = true
break
end
end
local function notyuri()
end
local repo = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
getgenv().ayasemiyatongekissazumirisa = true
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true 
Library.ShowCustomCursor = true 
Library.NotifySide = "Left"
local function AddInfo(Window)
local InfoTab = Window:AddTab("Info")
local InfoLeft = InfoTab:AddLeftGroupbox("Information")
local statusText = isLimitedExecutor and "<font color='#FFA500'>Semi-Working</font>" or "<font color='#00FF00'>Working</font>"
local extraNote = isLimitedExecutor
and "<b>NOTE:</b> May experiencing bugs for some features!"
or "All features should works properly!"
InfoLeft:AddLabel("<b>Executor:</b> " .. executorDisplayName .. "\n<b>Status:</b> " .. statusText .. "\n" .. extraNote, true)
local InfoRight = InfoTab:AddRightGroupbox("Others")
InfoRight:AddButton({
Text = "Join Discord Server",
Func = function()
local inviteCode = "q8QX76jyz"
local inviteLink = "https://discord.gg/" .. inviteCode
local success = false
if request then
success = pcall(function()
request({
Url = "http://127.0.0.1:6463/rpc?v=1",
Method = "POST",
Headers = {
["Content-Type"] = "application/json",
["Origin"] = "https://discord.com"
},
Body = HttpService:JSONEncode({
cmd = "INVITE_BROWSER",
args = { code = inviteCode },
nonce = HttpService:GenerateGUID(false)
})
})
end)
end
if not success and setclipboard then
setclipboard(inviteLink)
end
end,
})
end
local eh_success, err = pcall(function()
local Script_Start_Time = os.time()
local function GetSessionTime()
local seconds = os.time() - Script_Start_Time
local hours = math.floor(seconds / 3600)
local mins = math.floor((seconds % 3600) / 60)
return string.format("%dh %02dm", hours, mins)
end
local function GetObject(parent, pathString)
local current = parent
for _, name in ipairs(pathString:split(".")) do
if not current then return nil end
current = current:FindFirstChild(name)
end
return current
end
local function GetSafeModule(parent, name)
local obj = parent:FindFirstChild(name)
if obj and obj:IsA("ModuleScript") then
local success, result = pcall(require, obj)
if success then return result end
end
return nil
end
local function SafeConnect(key, getSignalFn, handler)
local ok, signal = pcall(getSignalFn)
if not ok or not signal then
return
end
Connections[key] = signal:Connect(handler)
end
local function SafeInvoke(remote, ...)
local args = {...}
local result = nil
task.spawn(function()
local success, res = pcall(function()
return remote:InvokeServer(unpack(args))
end)
result = res
end)
local start = tick()
repeat task.wait() until result ~= nil or (tick() - start) > 2 
return result
end
local function fire_event(signal, ...)
if firesignal then
return firesignal(signal, ...)
elseif getconnections then
for _, connection in ipairs(getconnections(signal)) do
if connection.Function then
task.spawn(connection.Function, ...)
end
end
else
warn("Your executor does not support firesignal or getconnections.")
end
end
local Packages = RS:FindFirstChild("Packages") or RS:WaitForChild("Packages", 10)
local Modules_RS = RS:FindFirstChild("Modules") or RS:WaitForChild("Modules", 10)
local DSClient = nil
local function GetDS()
if DSClient then return DSClient end
if not Packages then return nil end
local ok, ds = pcall(require, Packages:FindFirstChild("DataService") or Packages:WaitForChild("DataService", 10))
if ok and ds and ds.client then DSClient = ds.client return ds.client end
return nil
end
local NetworkerModule = nil
local function GetNetworkerModule()
if NetworkerModule then return NetworkerModule end
if not Packages then return nil end
local dsFolder = Packages:FindFirstChild("DataService") or Packages:WaitForChild("DataService", 10)
if not dsFolder then return nil end
local ok, nw = pcall(require, dsFolder:FindFirstChild("Networker") or dsFolder:WaitForChild("Networker", 10))
if ok and nw then NetworkerModule = nw return nw end
return nil
end
local function GetData(path)
local ds = GetDS()
if not ds then return nil end
local ok, val = pcall(function() return ds:get(path) end)
if ok then return val end
return nil
end
local function GetCurrency(name)
local val = GetData({ "Currency", name })
return val
end
local _networkerCache = {}
local function GetServiceNetworker(serviceName)
if _networkerCache[serviceName] then return _networkerCache[serviceName] end
local nw = GetNetworkerModule()
if not nw or not nw.client then return nil end
local ok, networker = pcall(function() return nw.client.new(serviceName) end)
if ok and networker then _networkerCache[serviceName] = networker return networker end
return nil
end
local function FireService(serviceName, action, ...)
local networker = GetServiceNetworker(serviceName)
if not networker then return false end
local args = {...}
return pcall(function() networker:fire(action, unpack(args)) end)
end
local PacketModule = nil
local function GetPacketModule()
if PacketModule then return PacketModule end
if not Packages then return nil end
local ok, pkt = pcall(require, Packages:FindFirstChild("Packet") or Packages:WaitForChild("Packet", 10))
if ok and pkt then PacketModule = pkt return pkt end
return nil
end
local NetModule = nil
local function GetNetModule()
if NetModule then return NetModule end
if not Packages then return nil end
local ok, net = pcall(require, Packages:FindFirstChild("Net") or Packages:WaitForChild("Net", 10))
if ok and net then NetModule = net return net end
return nil
end
local Remotes = {}
local Modules = {
DataService = GetDS(),
Networker = GetNetworkerModule(),
Packet = GetPacketModule(),
Net = GetNetModule(),
}
local _upgradeUtil = nil
local function GetUpgradeUtil()
if _upgradeUtil then return _upgradeUtil end
local sys = RS:FindFirstChild("Systems")
if not sys then return nil end
local upgradeSystem = sys:FindFirstChild("UpgradeSystem")
if not upgradeSystem then return nil end
local ok, util = pcall(require, upgradeSystem:FindFirstChild("UpgradeUtil"))
if ok and util then _upgradeUtil = util return util end
return nil
end
local _upgradeConfig = nil
local function GetUpgradeConfig()
if _upgradeConfig then return _upgradeConfig end
local sys = RS:FindFirstChild("Systems")
if not sys then return nil end
local upgradeSystem = sys:FindFirstChild("UpgradeSystem")
if not upgradeSystem then return nil end
local ok, cfg = pcall(require, upgradeSystem:FindFirstChild("UpgradeConfig"))
if ok and cfg then _upgradeConfig = cfg return cfg end
return nil
end
local _numberUtil = nil
local function GetNumberUtil()
if _numberUtil then return _numberUtil end
if not Modules_RS then return nil end
local ok, nu = pcall(require, Modules_RS:FindFirstChild("NumberUtil"))
if ok and nu then _numberUtil = nu return nu end
return nil
end
local _firePacket = nil
local function GetFirePacket()
if _firePacket then return _firePacket end
local pkt = GetPacketModule()
if not pkt then return nil end
local ok, fp = pcall(function() return pkt("AncientGunFire", { Hits = pkt.NumberU16 }) end)
if ok and fp then _firePacket = fp return fp end
return nil
end
local function Func_AutoShoot()
while Toggles.AutoShoot.Value do
local fp = GetFirePacket()
if fp then
pcall(function() fp:Fire({ Hits = 1 }) end)
end
task.wait(0.05)
end
end
local _bubbleDomeRemote = nil
local function GetBubbleDomeRemote()
if _bubbleDomeRemote then return _bubbleDomeRemote end
local ok, remote = pcall(function()
return RS
:WaitForChild("Packages", 10)
:WaitForChild("DataService", 10)
:WaitForChild("Networker", 10)
:WaitForChild("_remotes", 10)
:WaitForChild("BubbleDome", 10)
:WaitForChild("RemoteEvent", 10)
end)
if ok and remote then
_bubbleDomeRemote = remote
return remote
end
notyuri("[AutoBubble] Failed to find BubbleDome RemoteEvent")
return nil
end
local function Func_AutoBubble()
local remote = GetBubbleDomeRemote()
if not remote then return end
while Toggles.AutoBubble.Value do
local amount = tonumber((Options.BubbleAmountInput and Options.BubbleAmountInput.Value) or "0") or 0
pcall(function()
remote:FireServer("CollectBubbles", {
GoldBubble = 0/0,
SilverBubble = 0/0,
Bubble = 0/0,
})
end)
task.wait(0.1)
if amount and amount > 1 then
pcall(function()
remote:FireServer("CollectBubbles", {
GoldBubble = amount,
SilverBubble = amount,
Bubble = amount,
})
end)
task.wait(0.1)
end
task.wait()
end
end
local function Func_AutoRebirth()
while Toggles.AutoRebirth.Value do
FireService("RebirthService", "RequestRebirth", "Rebirth")
task.wait(1)
end
end
local function Func_AutoReincarnate()
while Toggles.AutoReincarnate.Value do
FireService("ReincarnationService", "RequestReincarnation")
task.wait(1)
end
end
local function Func_AutoReborn()
while Toggles.AutoReborn.Value do
FireService("ReincarnationService", "Reborn")
task.wait(1)
end
end
local function Func_AutoTier()
while Toggles.AutoTier.Value do
FireService("TierResetService", "RequestTierReset", "World2_Tier")
task.wait(1)
end
end
local _upgradeRemote = nil
local function GetUpgradeRemote()
if _upgradeRemote then return _upgradeRemote end
local ok, remote = pcall(function()
return RS
:WaitForChild("Packages", 10)
:WaitForChild("DataService", 10)
:WaitForChild("Networker", 10)
:WaitForChild("_remotes", 10)
:WaitForChild("UpgradeService", 10)
:WaitForChild("RemoteEvent", 10)
end)
if ok and remote then
_upgradeRemote = remote
return remote
end
notyuri("[AutoUpgrade] Failed to find UpgradeService RemoteEvent")
return nil
end
local function Func_AutoUpgrade()
while Toggles.AutoUpgrade.Value do
local remote = GetUpgradeRemote()
local config = GetUpgradeConfig()
local util = GetUpgradeUtil()
local ds = GetDS()
local nu = GetNumberUtil()
if remote and config and util and ds and nu then
for category, upgrades in pairs(config) do
for statId, upgradeData in pairs(upgrades) do
if not Toggles.AutoUpgrade.Value then break end
pcall(function()
local level = ds:get({ "Upgrades", category, statId }) or 0
if util.IsMaxed(category, statId, level) then return end
local currency = upgradeData.Currency
local rawBalance = currency == "Token"
and tostring(ds:get("Token") or 0)
or (ds:get({ "Currency", currency }) or "0")
local balance = nu.FromString(rawBalance):round()
local affordable = util.CalculateMaxAffordable(category, statId, level, balance, nil)
if affordable and affordable > 0 then
remote:FireServer("PurchaseUpgrade", category, statId, "Max")
end
end)
task.wait(0.1)
end
end
end
task.wait(.1)
end
end
local function FireTI(target)
if not firetouchinterest then
return
end
local root = Char and Char:FindFirstChild("HumanoidRootPart")
if not root then
return
end
local part
if target:IsA("BasePart") then
part = target
else
part = target:FindFirstAncestorWhichIsA("BasePart")
end
if not part then
return
end
task.spawn(function()
firetouchinterest(part, root, 1)
task.wait()
firetouchinterest(part, root, 0)
end)
end
local _upgradeTreeRemote = nil
local function GetUpgradeTreeRemote()
if _upgradeTreeRemote then return _upgradeTreeRemote end
local ok, remote = pcall(function()
return RS
:WaitForChild("Packages", 10)
:WaitForChild("DataService", 10)
:WaitForChild("Networker", 10)
:WaitForChild("_remotes", 10)
:WaitForChild("UpgradeTreeService", 10)
:WaitForChild("RemoteEvent", 10)
end)
if ok and remote then
_upgradeTreeRemote = remote
return remote
end
notyuri("[AutoTreeNode] Failed to find UpgradeTreeService RemoteEvent")
return nil
end
local function Func_AutoTreeNode()
local Worlds = workspace:FindFirstChild("Worlds")
while Toggles.AutoTreeNode.Value do
local remote = GetUpgradeTreeRemote()
if remote and Worlds then
for _, worldFolder in ipairs(Worlds:GetChildren()) do
local treesFolder = worldFolder:FindFirstChild("UpgradeTrees")
if treesFolder then
for _, treeGroup in ipairs(treesFolder:GetChildren()) do
local treeName = treeGroup.Name
for _, node in ipairs(treeGroup:GetChildren()) do
if not Toggles.AutoTreeNode.Value then break end
pcall(function()
remote:FireServer("PurchaseTreeNode", treeName, node.Name)
end)
task.wait(0.1)
end
end
end
end
end
task.wait()
end
end
local _pearlRemote = nil
local function GetPearlRemote()
if _pearlRemote then return _pearlRemote end
local ok, remote = pcall(function()
return RS
:WaitForChild("Packages", 10)
:WaitForChild("DataService", 10)
:WaitForChild("Networker", 10)
:WaitForChild("_remotes", 10)
:WaitForChild("PearlEarningService", 10)
:WaitForChild("RemoteEvent", 10)
end)
if ok and remote then
_pearlRemote = remote
return remote
end
notyuri("[AutoPearl] Failed to find PearlEarningService RemoteEvent")
return nil
end
local function Func_AutoPearl()
while Toggles.AutoPearl.Value do
local remote = GetPearlRemote()
if remote then
pcall(function()
remote:FireServer("HoverPearlCollected", "MainPearl")
end)
end
task.wait(0.1)
end
end
local function Func_AutoDepositGem()
while Toggles.AutoDepositGem.Value do
FireService("BenefitService", "DepositGemForge", nil, "Max")
task.wait(2)
end
end
local function Func_AutoPearlConversion()
while Toggles.AutoPearlConversion.Value do
FireService("PearlConversionService", "DepositPearlConversion", "Convert")
task.wait(2)
end
end
local function Func_AutoQuest()
while Toggles.AutoQuest.Value do
FireService("SparkleQuestService", "StartQuest")
task.wait(1)
FireService("SparkleQuestService", "SubmitQuest")
task.wait(5)
end
end
local function Func_AutoRefundQuest()
while Toggles.AutoRefundQuest.Value do
FireService("QuestPointRefundService", "RefundQuestPoint")
task.wait(5)
end
end
local function Func_SetShootingZone()
while Toggles.AutoShootingZone.Value do
local net = GetNetModule()
if net then
pcall(function() net:RemoteEvent("SetInShootingZone"):FireServer(true) end)
end
task.wait(5)
end
end
local Flags = {}
local Shared = {
}
local Tables = {
}
local Connections = {
Player_General = nil,
Knockback = {},
Reconnect = nil,
}
local function Cleanup(tbl)
for key, value in pairs(tbl) do
if typeof(value) == "RBXScriptConnection" then
value:Disconnect()
tbl[key] = nil
elseif typeof(value) == 'thread' then
task.cancel(value)
tbl[key] = nil
elseif type(value) == 'table' then
Cleanup(value)
end
end
end
function Thread(featurePath, featureFunc, isEnabled, ...)
local pathParts = featurePath:split(".")
local currentTable = Flags 
for i = 1, #pathParts - 1 do
local part = pathParts[i]
if not currentTable[part] then currentTable[part] = {} end
currentTable = currentTable[part]
end
local flagKey = pathParts[#pathParts]
local activeThread = currentTable[flagKey]
if isEnabled then
if not activeThread or coroutine.status(activeThread) == "dead" then
local newThread = task.spawn(featureFunc, ...)
currentTable[flagKey] = newThread
end
else
if activeThread and typeof(activeThread) == 'thread' then
task.cancel(activeThread)
currentTable[flagKey] = nil
end
end
end
local function SafeLoop(name, func)
return function()
local success, err = pcall(func)
if not success then
Library:Notify("Error in ["..name.."]: "..tostring(err), 10)
warn("Error in ["..name.."]: "..tostring(err))
end
end
end
local function CommaFormat(n)
local s = tostring(n)
return s:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end
local function Abbreviate(n)
local abbrev = {{1e12, "T"}, {1e9, "B"}, {1e6, "M"}, {1e3, "K"}}
for _, v in ipairs(abbrev) do
if n >= v[1] then return string.format("%.1f%s", n / v[1], v[2]) end
end
return tostring(n)
end
function AddSliderToggle(Config)
local Toggle = Config.Group:AddToggle(Config.Id, {
Text = Config.Text,
Default = Config.DefaultToggle or false
})
local Slider = Config.Group:AddSlider(Config.Id .. "Value", {
Text = Config.Text,
Default = Config.Default,
Min = Config.Min,
Max = Config.Max,
Rounding = Config.Rounding or 0,
Compact = true,
Visible = false
})
Toggle:OnChanged(function()
Slider:SetVisible(Toggle.Value)
end)
return Toggle, Slider
end
local function GetCharacter()
local c = Plr.Character
return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
end
local function FuncTPW()
while true do
local delta = RunService.Heartbeat:Wait()
local char = GetCharacter()
local hum = char and char:FindFirstChildOfClass("Humanoid")
if char and hum and hum.Health > 0 then
if hum.MoveDirection.Magnitude > 0 then
local speed = Options.TPWValue.Value
char:TranslateBy(hum.MoveDirection * speed * delta * 10)
end
end
end
end
local function FuncNoclip()
while Toggles.Noclip.Value do
RunService.Stepped:Wait()
local char = GetCharacter()
if char then
for _, part in pairs(char:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then
part.CanCollide = false
end
end
end
end
end
local function Func_AntiKnockback()
if type(Connections.Knockback) == "table" then
for _, conn in pairs(Connections.Knockback) do
if conn then conn:Disconnect() end
end
table.clear(Connections.Knockback)
else
Connections.Knockback = {}
end
local function ApplyAntiKB(character)
if not character then return end
local root = character:WaitForChild("HumanoidRootPart", 10)
if root then
local conn = root.ChildAdded:Connect(function(child)
if not Toggles.AntiKnockback.Value then return end
if child:IsA("BodyVelocity") and child.MaxForce == Vector3.new(40000, 40000, 40000) then
child:Destroy()
end
end)
table.insert(Connections.Knockback, conn)
end
end
if Plr.Character then
ApplyAntiKB(Plr.Character)
end
local charAddedConn = Plr.CharacterAdded:Connect(function(newChar)
ApplyAntiKB(newChar)
end)
table.insert(Connections.Knockback, charAddedConn)
repeat task.wait(1) until not Toggles.AntiKnockback.Value
for _, conn in pairs(Connections.Knockback) do
if conn then conn:Disconnect() end
end
table.clear(Connections.Knockback)
end
local function Func_AutoReconnect()
if Connections.Reconnect then Connections.Reconnect:Disconnect() end
Connections.Reconnect = GuiService.ErrorMessageChanged:Connect(function()
if not Toggles.AutoReconnect.Value then return end
task.delay(2, function()
pcall(function()
local promptOverlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
if promptOverlay then
local errorPrompt = promptOverlay.promptOverlay:FindFirstChild("ErrorPrompt")
if errorPrompt and errorPrompt.Visible then
local secondaryTimer = 5
task.wait(secondaryTimer)
TeleportService:Teleport(game.PlaceId, Plr)
end
end
end)
end)
end)
end
local function Func_NoGameplayPaused()
while Toggles.NoGameplayPaused.Value do
local success, err = pcall(function()
local pauseGui = game:GetService("CoreGui").RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
if pauseGui then
pauseGui:Destroy()
end
end)
task.wait(1)
end
end
local function ApplyFPSBoost(state)
if not state then return end
pcall(function()
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 1
for _, v in pairs(Lighting:GetChildren()) do
if v:IsA("PostProcessEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
v.Enabled = false
end
end
task.spawn(function()
for i, v in pairs(workspace:GetDescendants()) do
if Toggles.FPSBoost and not Toggles.FPSBoost.Value then break end
pcall(function()
if v:IsA("BasePart") then
v.Material = Enum.Material.SmoothPlastic
v.CastShadow = false
elseif v:IsA("Decal") or v:IsA("Texture") then
v:Destroy()
elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
v.Enabled = false
end
end)
if i % 500 == 0 then task.wait() end
end
end)
end)
end
function gsc(guiObject)
if not guiObject then return false end
local success = false
pcall(function()
if Services.GuiService and Services.VirtualInputManager then
Services.GuiService.SelectedObject = guiObject
task.wait(0.05)
local keys = {Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter, Enum.KeyCode.ButtonA}
for _, key in ipairs(keys) do
Services.VirtualInputManager:SendKeyEvent(true, key, false, game); task.wait(0.03)
Services.VirtualInputManager:SendKeyEvent(false, key, false, game); task.wait(0.03)
end
Services.GuiService.SelectedObject = nil
success = true
end
end)
return success
end
local function FireCD(target)
if not fireclickdetector then
return
end
if not target or not target:IsA("ClickDetector") then
return
end
fireclickdetector(target)
end
local function FirePP(target, teleport)
if not fireproximityprompt then return end
if not target or not target:IsA("ProximityPrompt") then return end
local prevDist = target.MaxActivationDistance
if teleport then
local char = GetCharacter()
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local part = target.Parent
local isModel = false
if part then
if part:IsA("Model") then
isModel = true
elseif not part:IsA("BasePart") then
part = target:FindFirstAncestorWhichIsA("BasePart")
if not part then
part = target:FindFirstAncestorWhichIsA("Model")
if part then
isModel = true
end
end
end
end
if hrp and part then
local partPos = isModel and part:GetPivot().Position or part.Position
local dist = (hrp.Position - partPos).Magnitude
if dist > prevDist then
local partCFrame = isModel and part:GetPivot() or part.CFrame
hrp.CFrame = partCFrame * CFrame.new(0, 3, 0)
task.wait(0.175)
end
end
end
fireproximityprompt(target)
end
local Window = Library:CreateWindow({
Title = "Yuri",
Center = true,
AutoShow = true,
Resizable = true,
ShowCustomCursor = false,
UnlockMouseWhileOpen = false,
NotifySide = "Left",
TabPadding = 8,
MenuFadeTime = 0.2
})
AddInfo(Window)
local Tabs = {
Main = Window:AddTab("Main"),
Player = Window:AddTab("Player"),
Config = Window:AddTab("Config"),
}
local TB = {
Main = {
Left = {
Autofarm = Tabs.Main:AddLeftTabbox(),
},
Right = {
Autofarm = Tabs.Main:AddRightTabbox(),
},
},
}
local TB_Tabs = {
Autofarm = {
T1 = TB.Main.Left.Autofarm:AddTab("Autofarm"),
},
Autofarm2 = {
T1 = TB.Main.Right.Autofarm:AddTab("Config"),
},
}
local GB = {
Player = {
Left = {
General = Tabs.Player:AddLeftGroupbox("General"),
Server  = Tabs.Player:AddLeftGroupbox("Server"),
},
Right = {
Game = Tabs.Player:AddRightGroupbox("Game"),
},
},
}
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 250 })
local TPW_T, TPW_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "JP", Text = "JumpPower", Default = 50, Min = 0, Max = 500 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "HH", Text = "HipHeight", Default = 2, Min = 0, Max = 10, Rounding = 1 })
GB.Player.Left.General:AddToggle("Noclip", { Text = "Noclip" })
GB.Player.Left.General:AddToggle("AntiKnockback", {
Text = "Anti Knockback",
Default = false,
})
GB.Player.Left.General:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering" })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1})
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
local FPS_T, FPS_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
GB.Player.Left.General:AddToggle("FPSBoost", { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK", {
Text = "Anti AFK",
Default = true,
Disabled = not Support.Connections,
})
GB.Player.Left.Server:AddToggle("AntiKick", { Text = "Anti Kick (Client)" })
GB.Player.Left.Server:AddToggle("AutoReconnect", { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused"})
GB.Player.Left.Server:AddButton({ Text = "Serverhop", Func = function()
local Servers = game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100')
end})
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function() Services.TeleportService:Teleport(game.PlaceId, Plr) end })
GB.Player.Left.Server:AddToggle("AutoServerhop", { Text = "Auto Serverhop" })
GB.Player.Left.Server:AddSlider("AutoHopMins", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
GB.Player.Right.Game:AddToggle("InstantPP", { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog", { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
TB_Tabs.Autofarm.T1:AddToggle("AutoBubble", { Text = "Auto Bubble", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("BubbleAmountInput", {
Default = "1",
Text = "Bubble Amount",
})
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTreeNode", { Text = "Auto Tree Node", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPearl", { Text = "Auto Pearl", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoDepositGem", { Text = "Auto Deposit Gem", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPearlConversion", { Text = "Auto Pearl Conversion", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoQuest", { Text = "Auto Quest", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoReincarnate", { Text = "Auto Reincarnate", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoReborn", { Text = "Auto Reborn", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTier", { Text = "Auto Tier Reset", Default = false })
Toggles.AntiKnockback:OnChanged(function(state)
Thread("AntiKnockback", Func_AntiKnockback, state)
end)
Toggles.TPW:OnChanged(function(v)
TPW_S:SetVisible(TPW_T.Value)
Thread("TPW", FuncTPW, v)
end)
Toggles.Noclip:OnChanged(function(v)
Thread("Noclip", FuncNoclip, v)
end)
Toggles.AutoBubble:OnChanged(function(v)
Thread("AutoBubble", SafeLoop("AutoBubble", Func_AutoBubble), v)
end)
Toggles.AutoUpgrade:OnChanged(function(v)
Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), v)
end)
Toggles.AutoTreeNode:OnChanged(function(v)
Thread("AutoTreeNode", SafeLoop("AutoTreeNode", Func_AutoTreeNode), v)
end)
Toggles.AutoPearl:OnChanged(function(v)
Thread("AutoPearl", SafeLoop("AutoPearl", Func_AutoPearl), v)
end)
Toggles.AutoDepositGem:OnChanged(function(v)
Thread("AutoDepositGem", SafeLoop("AutoDepositGem", Func_AutoDepositGem), v)
end)
Toggles.AutoPearlConversion:OnChanged(function(v)
Thread("AutoPearlConversion", SafeLoop("AutoPearlConversion", Func_AutoPearlConversion), v)
end)
Toggles.AutoQuest:OnChanged(function(v)
Thread("AutoQuest", SafeLoop("AutoQuest", Func_AutoQuest), v)
end)
Toggles.AutoRebirth:OnChanged(function(v)
Thread("AutoRebirth", SafeLoop("AutoRebirth", Func_AutoRebirth), v)
end)
Toggles.AutoReincarnate:OnChanged(function(v)
Thread("AutoReincarnate", SafeLoop("AutoReincarnate", Func_AutoReincarnate), v)
end)
Toggles.AutoReborn:OnChanged(function(v)
Thread("AutoReborn", SafeLoop("AutoReborn", Func_AutoReborn), v)
end)
Toggles.AutoTier:OnChanged(function(v)
Thread("AutoTier", SafeLoop("AutoTier", Func_AutoTier), v)
end)
Connections.Player_General = RunService.Stepped:Connect(function()
local Hum = Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")
if Hum then
if Toggles.WS.Value then Hum.WalkSpeed = Options.WSValue.Value end
if Toggles.JP.Value then Hum.JumpPower = Options.JPValue.Value Hum.UseJumpPower = true end
if Toggles.HH.Value then Hum.HipHeight = Options.HHValue.Value end
end
workspace.Gravity = Toggles.Grav.Value and Options.GravValue.Value or 192
if Toggles.FOV.Value then workspace.CurrentCamera.FieldOfView = Options.FOVValue.Value end
if Toggles.Zoom.Value then Plr.CameraMaxZoomDistance = Options.ZoomValue.Value end
end)
task.spawn(function()
while task.wait() do
if Toggles.Fullbright.Value then
Lighting.Brightness = 2
Lighting.ClockTime = 14
Lighting.GlobalShadows = false
elseif Toggles.OverrideTime.Value then
Lighting.ClockTime = Options.OverrideTimeValue.Value
end
if Toggles.NoFog.Value then Lighting.FogEnd = 9e9 end
if Library.Unloaded then break end
end
end)
Options.LimitFPSValue:OnChanged(function()
if FPS_T.Value then
setfpscap(FPS_S.Value)
end
end)
Toggles.LimitFPS:OnChanged(function(v)
FPS_S:SetVisible(FPS_T.Value)
if not v then
setfpscap(999)
end
end)
Toggles.Disable3DRender:OnChanged(function(v) RunService:Set3dRenderingEnabled(not v) end)
Toggles.FPSBoost:OnChanged(function(state)
ApplyFPSBoost(state)
end)
Toggles.AutoReconnect:OnChanged(function(state)
if state then Func_AutoReconnect() end
end)
Toggles.NoGameplayPaused:OnChanged(function(state)
Thread("NoGameplayPaused", SafeLoop("Anti-Pause", Func_NoGameplayPaused), state)
end)
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
if Toggles.InstantPP and Toggles.InstantPP.Value then
prompt.HoldDuration = 0
end
end)
local function RunAntiAFK()
local GC = getconnections or get_signal_cons
if GC then
for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
if v["Disable"] then
v["Disable"](v)
elseif v["Disconnect"] then
v["Disconnect"](v)
end
end
else
local VirtualUser = cloneref(game:GetService("VirtualUser"))
Players.LocalPlayer.Idled:Connect(function()
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end)
end
end
Toggles.AntiAFK:OnChanged(function(state)
if state then RunAntiAFK() end
end)
if Toggles.AntiAFK.Value then RunAntiAFK() end
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("AutoShowUI", {
Text = "Auto Show UI",
Default = true,
})
MenuGroup:AddToggle("KeybindMenuOpen", {
Default = Library.KeybindFrame.Visible,
Text = "Open Keybind Menu",
Callback = function(value)
Library.KeybindFrame.Visible = value
end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
Text = "Custom Cursor",
Default = false,
Callback = function(Value)
Library.ShowCustomCursor = Value
end,
})
MenuGroup:AddDropdown("NotificationSide", {
Values = { "Left", "Right" },
Default = "Right",
Text = "Notification Side",
Callback = function(Value)
Library:SetNotifySide(Value)
end,
})
MenuGroup:AddDropdown("DPIDropdown", {
Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
Default = "100%",
Text = "DPI Scale",
Callback = function(Value)
Value = Value:gsub("%%", "")
local DPI = tonumber(Value)
Library:SetDPIScale(DPI)
end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
:AddKeyPicker("MenuKeybind", { Default = "U", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function()
getgenv().ayasemiyatongekissazumirisa = false
Shared.Farm = false
Cleanup(Connections)
Cleanup(Flags)
Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/BubbleShooting")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
SaveManager:LoadAutoloadConfig()
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
Library:SetDPIScale(100)
end
Library:Notify("Script loaded.", 2)
Library:Notify("Yuri!", 5)
end)
if not eh_success then
Library:Notify("ERROR: " .. tostring(err), 4)
notyuri("ERROR: " .. tostring(err))
end
elseif game.GameId == 10258087043 then
if getgenv().ayasemiyatongekissazumirisa then
warn("yuri")
return
end
function missing(t, f, fallback)
if type(f) == t then return f end
return fallback
end
cloneref = missing("function", cloneref, function(...) return ... end)
getgc = missing("function", getgc or get_gc_objects)
getconnections = missing("function", getconnections or get_signal_cons)
Services = setmetatable({}, {
__index = function(self, name)
local success, cache = pcall(function()
return cloneref(game:GetService(name))
end)
if success then
rawset(self, name, cache)
return cache
else
error("Invalid Service: " .. tostring(name))
end
end
})
local Players = Services.Players
local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local PGui = Plr:WaitForChild("PlayerGui")
local Lighting = game:GetService('Lighting');
local RS = Services.ReplicatedStorage
local RunService = Services.RunService
local HttpService = Services.HttpService
local GuiService = Services.GuiService
local TeleportService = Services.TeleportService
local Marketplace = Services.MarketplaceService
local UIS = Services.UserInputService
local VirtualUser = Services.VirtualUser
local v, Asset = pcall(function()
return Marketplace:GetProductInfo(game.PlaceId)
end)
local assetName = "game name"
if v and Asset then
assetName = Asset.Name
end
local Support = {
Webhook = (typeof(request) == "function" or typeof(http_request) == "function"),
Clipboard = (typeof(setclipboard) == "function"),
FileIO = (typeof(writefile) == "function" and typeof(isfile) == "function"),
QueueOnTeleport = (typeof(queue_on_teleport) == "function"),
Connections = (typeof(getconnections) == "function"),
FPS = (typeof(setfpscap) == "function"),
Proximity = (typeof(fireproximityprompt) == "function"),
}
local executorName = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local LimitedExecutors = {"xeno", "solara",}
local isLimitedExecutor = false
for _, name in ipairs(LimitedExecutors) do
if string.find(executorName, name) then
isLimitedExecutor = true
break
end
end
local function notyuri()
end
local repo = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
getgenv().ayasemiyatongekissazumirisa = true
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true 
Library.ShowCustomCursor = true 
Library.NotifySide = "Left"
local function AddInfo(Window)
local InfoTab = Window:AddTab("Info")
local InfoLeft = InfoTab:AddLeftGroupbox("Information")
local statusText = isLimitedExecutor and "<font color='#FFA500'>Semi-Working</font>" or "<font color='#00FF00'>Working</font>"
local extraNote = isLimitedExecutor
and "<b>NOTE:</b> May experiencing bugs for some features!"
or "All features should works properly!"
InfoLeft:AddLabel("<b>Executor:</b> " .. executorDisplayName .. "\n<b>Status:</b> " .. statusText .. "\n" .. extraNote, true)
local InfoRight = InfoTab:AddRightGroupbox("Others")
InfoRight:AddButton({
Text = "Join Discord Server",
Func = function()
local inviteCode = "q8QX76jyz"
local inviteLink = "https://discord.gg/" .. inviteCode
local success = false
if request then
success = pcall(function()
request({
Url = "http://127.0.0.1:6463/rpc?v=1",
Method = "POST",
Headers = {
["Content-Type"] = "application/json",
["Origin"] = "https://discord.com"
},
Body = HttpService:JSONEncode({
cmd = "INVITE_BROWSER",
args = { code = inviteCode },
nonce = HttpService:GenerateGUID(false)
})
})
end)
end
if not success and setclipboard then
setclipboard(inviteLink)
end
end,
})
end
local eh_success, err = pcall(function()
local Script_Start_Time = os.time()
local function GetSessionTime()
local seconds = os.time() - Script_Start_Time
local hours = math.floor(seconds / 3600)
local mins = math.floor((seconds % 3600) / 60)
return string.format("%dh %02dm", hours, mins)
end
local function GetObject(parent, pathString)
local current = parent
for _, name in ipairs(pathString:split(".")) do
if not current then return nil end
current = current:FindFirstChild(name)
end
return current
end
local function GetSafeModule(parent, name)
local obj = parent:FindFirstChild(name)
if obj and obj:IsA("ModuleScript") then
local success, result = pcall(require, obj)
if success then return result end
end
return nil
end
local function SafeConnect(key, getSignalFn, handler)
local ok, signal = pcall(getSignalFn)
if not ok or not signal then
return
end
Connections[key] = signal:Connect(handler)
end
local function SafeInvoke(remote, ...)
local args = {...}
local result = nil
task.spawn(function()
local success, res = pcall(function()
return remote:InvokeServer(unpack(args))
end)
result = res
end)
local start = tick()
repeat task.wait() until result ~= nil or (tick() - start) > 2 
return result
end
local function fire_event(signal, ...)
if firesignal then
return firesignal(signal, ...)
elseif getconnections then
for _, connection in ipairs(getconnections(signal)) do
if connection.Function then
task.spawn(connection.Function, ...)
end
end
else
warn("Your executor does not support firesignal or getconnections.")
end
end
local Remotes = {
ButtonBuy = RS:WaitForChild("E"):WaitForChild("ButtonBuy"),
Rebirth   = RS:WaitForChild("E"):WaitForChild("Rebirth"),
}
local Modules = {
}
local Flags = {}
local Shared = {
}
local Tables = {
}
local Connections = {
Player_General = nil,
Knockback = {},
Reconnect = nil,
}
local function Cleanup(tbl)
for key, value in pairs(tbl) do
if typeof(value) == "RBXScriptConnection" then
value:Disconnect()
tbl[key] = nil
elseif typeof(value) == 'thread' then
task.cancel(value)
tbl[key] = nil
elseif type(value) == 'table' then
Cleanup(value)
end
end
end
function Thread(featurePath, featureFunc, isEnabled, ...)
local pathParts = featurePath:split(".")
local currentTable = Flags 
for i = 1, #pathParts - 1 do
local part = pathParts[i]
if not currentTable[part] then currentTable[part] = {} end
currentTable = currentTable[part]
end
local flagKey = pathParts[#pathParts]
local activeThread = currentTable[flagKey]
if isEnabled then
if not activeThread or coroutine.status(activeThread) == "dead" then
local newThread = task.spawn(featureFunc, ...)
currentTable[flagKey] = newThread
end
else
if activeThread and typeof(activeThread) == 'thread' then
task.cancel(activeThread)
currentTable[flagKey] = nil
end
end
end
local function SafeLoop(name, func)
return function()
local success, err = pcall(func)
if not success then
Library:Notify("Error in ["..name.."]: "..tostring(err), 10)
warn("Error in ["..name.."]: "..tostring(err))
end
end
end
local function CommaFormat(n)
local s = tostring(n)
return s:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end
local function Abbreviate(n)
local abbrev = {{1e12, "T"}, {1e9, "B"}, {1e6, "M"}, {1e3, "K"}}
for _, v in ipairs(abbrev) do
if n >= v[1] then return string.format("%.1f%s", n / v[1], v[2]) end
end
return tostring(n)
end
function AddSliderToggle(Config)
local Toggle = Config.Group:AddToggle(Config.Id, {
Text = Config.Text,
Default = Config.DefaultToggle or false
})
local Slider = Config.Group:AddSlider(Config.Id .. "Value", {
Text = Config.Text,
Default = Config.Default,
Min = Config.Min,
Max = Config.Max,
Rounding = Config.Rounding or 0,
Compact = true,
Visible = false
})
Toggle:OnChanged(function()
Slider:SetVisible(Toggle.Value)
end)
return Toggle, Slider
end
local function GetCharacter()
local c = Plr.Character
return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
end
local function FuncTPW()
while true do
local delta = RunService.Heartbeat:Wait()
local char = GetCharacter()
local hum = char and char:FindFirstChildOfClass("Humanoid")
if char and hum and hum.Health > 0 then
if hum.MoveDirection.Magnitude > 0 then
local speed = Options.TPWValue.Value
char:TranslateBy(hum.MoveDirection * speed * delta * 10)
end
end
end
end
local function FuncNoclip()
while Toggles.Noclip.Value do
RunService.Stepped:Wait()
local char = GetCharacter()
if char then
for _, part in pairs(char:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then
part.CanCollide = false
end
end
end
end
end
local function Func_AntiKnockback()
if type(Connections.Knockback) == "table" then
for _, conn in pairs(Connections.Knockback) do
if conn then conn:Disconnect() end
end
table.clear(Connections.Knockback)
else
Connections.Knockback = {}
end
local function ApplyAntiKB(character)
if not character then return end
local root = character:WaitForChild("HumanoidRootPart", 10)
if root then
local conn = root.ChildAdded:Connect(function(child)
if not Toggles.AntiKnockback.Value then return end
if child:IsA("BodyVelocity") and child.MaxForce == Vector3.new(40000, 40000, 40000) then
child:Destroy()
end
end)
table.insert(Connections.Knockback, conn)
end
end
if Plr.Character then
ApplyAntiKB(Plr.Character)
end
local charAddedConn = Plr.CharacterAdded:Connect(function(newChar)
ApplyAntiKB(newChar)
end)
table.insert(Connections.Knockback, charAddedConn)
repeat task.wait(1) until not Toggles.AntiKnockback.Value
for _, conn in pairs(Connections.Knockback) do
if conn then conn:Disconnect() end
end
table.clear(Connections.Knockback)
end
local function Func_AutoReconnect()
if Connections.Reconnect then Connections.Reconnect:Disconnect() end
Connections.Reconnect = GuiService.ErrorMessageChanged:Connect(function()
if not Toggles.AutoReconnect.Value then return end
task.delay(2, function()
pcall(function()
local promptOverlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
if promptOverlay then
local errorPrompt = promptOverlay.promptOverlay:FindFirstChild("ErrorPrompt")
if errorPrompt and errorPrompt.Visible then
local secondaryTimer = 5
task.wait(secondaryTimer)
TeleportService:Teleport(game.PlaceId, Plr)
end
end
end)
end)
end)
end
local function Func_NoGameplayPaused()
while Toggles.NoGameplayPaused.Value do
local success, err = pcall(function()
local pauseGui = game:GetService("CoreGui").RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
if pauseGui then
pauseGui:Destroy()
end
end)
task.wait(1)
end
end
local function ApplyFPSBoost(state)
if not state then return end
pcall(function()
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 1
for _, v in pairs(Lighting:GetChildren()) do
if v:IsA("PostProcessEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
v.Enabled = false
end
end
task.spawn(function()
for i, v in pairs(workspace:GetDescendants()) do
if Toggles.FPSBoost and not Toggles.FPSBoost.Value then break end
pcall(function()
if v:IsA("BasePart") then
v.Material = Enum.Material.SmoothPlastic
v.CastShadow = false
elseif v:IsA("Decal") or v:IsA("Texture") then
v:Destroy()
elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
v.Enabled = false
end
end)
if i % 500 == 0 then task.wait() end
end
end)
end)
end
function gsc(guiObject)
if not guiObject then return false end
local success = false
pcall(function()
if Services.GuiService and Services.VirtualInputManager then
Services.GuiService.SelectedObject = guiObject
task.wait(0.05)
local keys = {Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter, Enum.KeyCode.ButtonA}
for _, key in ipairs(keys) do
Services.VirtualInputManager:SendKeyEvent(true, key, false, game); task.wait(0.03)
Services.VirtualInputManager:SendKeyEvent(false, key, false, game); task.wait(0.03)
end
Services.GuiService.SelectedObject = nil
success = true
end
end)
return success
end
local function FireCD(target)
if not fireclickdetector then
return
end
if not target or not target:IsA("ClickDetector") then
return
end
fireclickdetector(target)
end
local function FirePP(target, teleport)
if not fireproximityprompt then return end
if not target or not target:IsA("ProximityPrompt") then return end
local prevDist = target.MaxActivationDistance
if teleport then
local char = GetCharacter()
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local part = target.Parent
local isModel = false
if part then
if part:IsA("Model") then
isModel = true
elseif not part:IsA("BasePart") then
part = target:FindFirstAncestorWhichIsA("BasePart")
if not part then
part = target:FindFirstAncestorWhichIsA("Model")
if part then
isModel = true
end
end
end
end
if hrp and part then
local partPos = isModel and part:GetPivot().Position or part.Position
local dist = (hrp.Position - partPos).Magnitude
if dist > prevDist then
local partCFrame = isModel and part:GetPivot() or part.CFrame
hrp.CFrame = partCFrame * CFrame.new(0, 3, 0)
task.wait(0.175)
end
end
end
fireproximityprompt(target)
end
local function FireTI(target)
if not firetouchinterest then
return
end
local root = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
if not root then
return
end
local part
if target:IsA("BasePart") then
part = target
else
part = target:FindFirstAncestorWhichIsA("BasePart")
end
if not part then
return
end
task.spawn(function()
firetouchinterest(part, root, 1)
task.wait()
firetouchinterest(part, root, 0)
end)
end
local function Func_AutoRebirth()
while Toggles.AutoRebirth.Value do
local purchases = Plr:FindFirstChild("Purchases")
local rebReq    = RS:FindFirstChild("RebReq")
local rebirths  = Plr:FindFirstChild("Rebirths")
if purchases and rebReq and rebirths then
local count = #purchases:GetChildren()
local req   = rebReq.Value
local cur   = rebirths.Value
notyuri("[AutoRebirth] Purchases:", count, "/ RebReq:", req, "| Rebirths:", cur)
if count >= req and cur < 6 then
notyuri("[AutoRebirth] Conditions met, firing Rebirth")
Remotes.Rebirth:FireServer()
end
else
notyuri("[AutoRebirth] Missing Purchases/RebReq/Rebirths, retrying...")
end
task.wait()
end
end
local function GetTycoonButtons()
local tycoonNum = Plr:WaitForChild("TycoonNumber")
local tycoonFolder = workspace:WaitForChild("Tycoons"):FindFirstChild(tostring(tycoonNum.Value))
if not tycoonFolder then
notyuri("[BuyAll] Tycoon folder not found for number:", tycoonNum.Value)
return nil
end
return tycoonFolder:FindFirstChild("Buttons")
end
local function Func_AutoBuy()
while Toggles.AutoBuy.Value do
local buttonsFolder = GetTycoonButtons()
if buttonsFolder then
for _, btn in ipairs(buttonsFolder:GetChildren()) do
if not Toggles.AutoBuy.Value then break end
if btn:FindFirstChild("ShopId") and btn.ShopId.Value ~= 0 then
continue
end
if btn:FindFirstChild("Price") and btn:FindFirstChild("RequiresThis") then
notyuri("[AutoBuy] Buying:", btn.Name, "| Price:", btn.Price.Value)
Remotes.ButtonBuy:FireServer(0, btn.Name, btn.RequiresThis.Value)
task.wait()
end
end
else
notyuri("[AutoBuy] Tycoon buttons folder not found, retrying...")
end
task.wait()
end
end
local Window = Library:CreateWindow({
Title = "Yuri",
Center = true,
AutoShow = true,
Resizable = true,
ShowCustomCursor = false,
UnlockMouseWhileOpen = false,
NotifySide = "Left",
TabPadding = 8,
MenuFadeTime = 0.2
})
AddInfo(Window)
local Tabs = {
Main = Window:AddTab("Main"),
Player = Window:AddTab("Player"),
Config = Window:AddTab("Config"),
}
local TB = {
Main = {
Left = {
Autofarm = Tabs.Main:AddLeftTabbox(),
},
Right = {
Autofarm = Tabs.Main:AddRightTabbox(),
},
},
}
local TB_Tabs = {
Autofarm = {
T1 = TB.Main.Left.Autofarm:AddTab("Autofarm"),
},
Autofarm2 = {
T1 = TB.Main.Right.Autofarm:AddTab("Config"),
},
}
local GB = {
Player = {
Left = {
General = Tabs.Player:AddLeftGroupbox("General"),
Server  = Tabs.Player:AddLeftGroupbox("Server"),
},
Right = {
Game = Tabs.Player:AddRightGroupbox("Game"),
},
},
}
TB_Tabs.Autofarm.T1:AddButton({
Text = "Inf",
Func = function()
local buttonsFolder = GetTycoonButtons()
if not buttonsFolder then
return
end
local btn = buttonsFolder:GetChildren()[1]
if not btn then
return
end
if btn:FindFirstChild("ShopId") and btn.ShopId.Value ~= 0 then
return
end
notyuri("[TestBuy] Firing ButtonBuy for:", btn.Name, "| Price:", btn.Price.Value, "| RequiresThis:", btn.RequiresThis.Value)
Remotes.ButtonBuy:FireServer(-1e999, btn.Name, btn.RequiresThis.Value)
end,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoBuy", {
Text = "Auto Buy",
Default = false,
})
Toggles.AutoBuy:OnChanged(function(state)
Thread("AutoBuy", Func_AutoBuy, state)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", {
Text = "Auto Rebirth",
Default = false,
})
Toggles.AutoRebirth:OnChanged(function(state)
Thread("AutoRebirth", Func_AutoRebirth, state)
end)
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 250 })
local TPW_T, TPW_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "JP", Text = "JumpPower", Default = 50, Min = 0, Max = 500 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "HH", Text = "HipHeight", Default = 2, Min = 0, Max = 10, Rounding = 1 })
GB.Player.Left.General:AddToggle("Noclip", { Text = "Noclip" })
GB.Player.Left.General:AddToggle("AntiKnockback", {
Text = "Anti Knockback",
Default = false,
})
GB.Player.Left.General:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering" })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1})
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
local FPS_T, FPS_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
GB.Player.Left.General:AddToggle("FPSBoost", { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK", {
Text = "Anti AFK",
Default = true,
Disabled = not Support.Connections,
})
GB.Player.Left.Server:AddToggle("AntiKick", { Text = "Anti Kick (Client)" })
GB.Player.Left.Server:AddToggle("AutoReconnect", { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused"})
GB.Player.Left.Server:AddButton({ Text = "Serverhop", Func = function()
local Servers = game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100')
end})
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function() Services.TeleportService:Teleport(game.PlaceId, Plr) end })
GB.Player.Left.Server:AddToggle("AutoServerhop", { Text = "Auto Serverhop" })
GB.Player.Left.Server:AddSlider("AutoHopMins", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
GB.Player.Right.Game:AddToggle("InstantPP", { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog", { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
Toggles.AntiKnockback:OnChanged(function(state)
Thread("AntiKnockback", Func_AntiKnockback, state)
end)
Toggles.TPW:OnChanged(function(v)
TPW_S:SetVisible(TPW_T.Value)
Thread("TPW", FuncTPW, v)
end)
Toggles.Noclip:OnChanged(function(v)
Thread("Noclip", FuncNoclip, v)
end)
Connections.Player_General = RunService.Stepped:Connect(function()
local Hum = Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")
if Hum then
if Toggles.WS.Value then Hum.WalkSpeed = Options.WSValue.Value end
if Toggles.JP.Value then Hum.JumpPower = Options.JPValue.Value Hum.UseJumpPower = true end
if Toggles.HH.Value then Hum.HipHeight = Options.HHValue.Value end
end
workspace.Gravity = Toggles.Grav.Value and Options.GravValue.Value or 192
if Toggles.FOV.Value then workspace.CurrentCamera.FieldOfView = Options.FOVValue.Value end
if Toggles.Zoom.Value then Plr.CameraMaxZoomDistance = Options.ZoomValue.Value end
end)
task.spawn(function()
while task.wait() do
if Toggles.Fullbright.Value then
Lighting.Brightness = 2
Lighting.ClockTime = 14
Lighting.GlobalShadows = false
elseif Toggles.OverrideTime.Value then
Lighting.ClockTime = Options.OverrideTimeValue.Value
end
if Toggles.NoFog.Value then Lighting.FogEnd = 9e9 end
if Library.Unloaded then break end
end
end)
Options.LimitFPSValue:OnChanged(function()
if FPS_T.Value then
setfpscap(FPS_S.Value)
end
end)
Toggles.LimitFPS:OnChanged(function(v)
FPS_S:SetVisible(FPS_T.Value)
if not v then
setfpscap(999)
end
end)
Toggles.Disable3DRender:OnChanged(function(v) RunService:Set3dRenderingEnabled(not v) end)
Toggles.FPSBoost:OnChanged(function(state)
ApplyFPSBoost(state)
end)
Toggles.AutoReconnect:OnChanged(function(state)
if state then Func_AutoReconnect() end
end)
Toggles.NoGameplayPaused:OnChanged(function(state)
Thread("NoGameplayPaused", SafeLoop("Anti-Pause", Func_NoGameplayPaused), state)
end)
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
if Toggles.InstantPP and Toggles.InstantPP.Value then
prompt.HoldDuration = 0
end
end)
local function RunAntiAFK()
local GC = getconnections or get_signal_cons
if GC then
for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
if v["Disable"] then
v["Disable"](v)
elseif v["Disconnect"] then
v["Disconnect"](v)
end
end
else
local VirtualUser = cloneref(game:GetService("VirtualUser"))
Players.LocalPlayer.Idled:Connect(function()
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end)
end
end
Toggles.AntiAFK:OnChanged(function(state)
if state then RunAntiAFK() end
end)
if Toggles.AntiAFK.Value then RunAntiAFK() end
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("AutoShowUI", {
Text = "Auto Show UI",
Default = true,
})
MenuGroup:AddToggle("KeybindMenuOpen", {
Default = Library.KeybindFrame.Visible,
Text = "Open Keybind Menu",
Callback = function(value)
Library.KeybindFrame.Visible = value
end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
Text = "Custom Cursor",
Default = false,
Callback = function(Value)
Library.ShowCustomCursor = Value
end,
})
MenuGroup:AddDropdown("NotificationSide", {
Values = { "Left", "Right" },
Default = "Right",
Text = "Notification Side",
Callback = function(Value)
Library:SetNotifySide(Value)
end,
})
MenuGroup:AddDropdown("DPIDropdown", {
Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
Default = "100%",
Text = "DPI Scale",
Callback = function(Value)
Value = Value:gsub("%%", "")
local DPI = tonumber(Value)
Library:SetDPIScale(DPI)
end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
:AddKeyPicker("MenuKeybind", { Default = "U", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function()
getgenv().ayasemiyatongekissazumirisa = false
Shared.Farm = false
Cleanup(Connections)
Cleanup(Flags)
Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/RestStopTycoon")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
SaveManager:LoadAutoloadConfig()
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
Library:SetDPIScale(100)
end
Library:Notify("Script loaded.", 2)
Library:Notify("Yuri!", 5)
end)
if not eh_success then
Library:Notify("ERROR: " .. tostring(err), 4)
notyuri("ERROR: " .. tostring(err))
end
elseif game.GameId == 7613921865 then
if getgenv().ayasemiyatongekissazumirisa then
warn("yuri")
return
end
function missing(t, f, fallback)
if type(f) == t then return f end
return fallback
end
cloneref = missing("function", cloneref, function(...) return ... end)
getgc = missing("function", getgc or get_gc_objects)
getconnections = missing("function", getconnections or get_signal_cons)
do
local ScriptContext = cloneref(game:GetService("ScriptContext"))
if getconnections then
for _, conn in ipairs(getconnections(ScriptContext.Error)) do
pcall(function() conn:Disconnect() end)
end
ScriptContext.Error:Connect(function(msg, trace, script)
if script == nil or script.Parent == nil then
return 
end
end)
end
end
Services = setmetatable({}, {
__index = function(self, name)
local success, cache = pcall(function()
return cloneref(game:GetService(name))
end)
if success then
rawset(self, name, cache)
return cache
else
error("Invalid Service: " .. tostring(name))
end
end
})
local Players = Services.Players
local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local PGui = Plr:WaitForChild("PlayerGui")
local Lighting = game:GetService("Lighting")
local RS = Services.ReplicatedStorage
local RunService = Services.RunService
local HttpService = Services.HttpService
local GuiService = Services.GuiService
local TeleportService = Services.TeleportService
local Marketplace = Services.MarketplaceService
local UIS = Services.UserInputService
local VirtualUser = Services.VirtualUser
local v, Asset = pcall(function()
return Marketplace:GetProductInfo(game.PlaceId)
end)
local assetName = "game name"
if v and Asset then
assetName = Asset.Name
end
local Support = {
Webhook = (typeof(request) == "function" or typeof(http_request) == "function"),
Clipboard = (typeof(setclipboard) == "function"),
FileIO = (typeof(writefile) == "function" and typeof(isfile) == "function"),
QueueOnTeleport = (typeof(queue_on_teleport) == "function"),
Connections = (typeof(getconnections) == "function"),
FPS = (typeof(setfpscap) == "function"),
Proximity = (typeof(fireproximityprompt) == "function"),
}
local executorName = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local LimitedExecutors = {"xeno", "solara",}
local isLimitedExecutor = false
for _, name in ipairs(LimitedExecutors) do
if string.find(executorName, name) then
isLimitedExecutor = true
break
end
end
local function notyuri()
end
local repo = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
getgenv().ayasemiyatongekissazumirisa = true
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true
Library.NotifySide = "Left"
local function AddInfo(Window)
local InfoTab = Window:AddTab("Info")
local InfoLeft = InfoTab:AddLeftGroupbox("Information")
local statusText = isLimitedExecutor and "<font color='#FFA500'>Semi-Working</font>" or "<font color='#00FF00'>Working</font>"
local extraNote = isLimitedExecutor
and "<b>NOTE:</b> May experiencing bugs for some features!"
or "All features should works properly!"
InfoLeft:AddLabel("<b>Executor:</b> " .. executorDisplayName .. "\n<b>Status:</b> " .. statusText .. "\n" .. extraNote, true)
local InfoRight = InfoTab:AddRightGroupbox("Others")
InfoRight:AddButton({
Text = "Join Discord Server",
Func = function()
local inviteCode = "q8QX76jyz"
local inviteLink = "https://discord.gg/" .. inviteCode
local success = false
if request then
success = pcall(function()
request({
Url = "http://127.0.0.1:6463/rpc?v=1",
Method = "POST",
Headers = {
["Content-Type"] = "application/json",
["Origin"] = "https://discord.com"
},
Body = HttpService:JSONEncode({
cmd = "INVITE_BROWSER",
args = { code = inviteCode },
nonce = HttpService:GenerateGUID(false)
})
})
end)
end
if not success and setclipboard then
setclipboard(inviteLink)
end
end,
})
end
local eh_success, err = pcall(function()
local Script_Start_Time = os.time()
local function GetSessionTime()
local seconds = os.time() - Script_Start_Time
local hours = math.floor(seconds / 3600)
local mins = math.floor((seconds % 3600) / 60)
return string.format("%dh %02dm", hours, mins)
end
local function GetObject(parent, pathString)
local Cur = parent
for _, name in ipairs(pathString:split(".")) do
if not Cur then return nil end
Cur = Cur:FindFirstChild(name)
end
return Cur
end
local function GetSafeModule(parent, name)
local obj = parent:FindFirstChild(name)
if obj and obj:IsA("ModuleScript") then
local success, result = pcall(require, obj)
if success then return result end
end
return nil
end
local function SafeInvoke(remote, ...)
local args = {...}
local result = nil
task.spawn(function()
local success, res = pcall(function()
return remote:InvokeServer(unpack(args))
end)
result = res
end)
local start = tick()
repeat task.wait() until result ~= nil or (tick() - start) > 2
return result
end
local function fire_event(signal, ...)
if firesignal then
return firesignal(signal, ...)
elseif getconnections then
for _, connection in ipairs(getconnections(signal)) do
if connection.Function then
task.spawn(connection.Function, ...)
end
end
else
warn("Your executor does not support firesignal or getconnections.")
end
end
local Nodes = require(RS:WaitForChild("Nodes"))
local ReplicaWrite = RS:WaitForChild("RemoteEvents"):WaitForChild("ReplicaSignal")
local Shared = {}
local function WaveChanged(lastWave)
local gr = Nodes.GET_GAME_REPLICA:InvokeSelf()
local currentWave = gr and (gr.Data.Wave or 0) or 0
return currentWave < lastWave, currentWave
end
local function WaitReset(lastWave, shouldContinue, label)
while shouldContinue() do
task.wait(0.2)
local decreased, newWave = WaveChanged(lastWave)
if decreased then
notyuri(label, "Wave reset (" .. lastWave .. " -> " .. newWave .. ") — restarting macro")
return true
end
lastWave = newWave
end
return false
end
local MDir = "Yuri/AnimeExpeditions/Macros"
local MState = {
Rec            = false,
Rep            = false,
Cur            = nil,
Load           = nil,
Step           = 0,
Total          = 0,
LabelRef       = nil,
PendingLabel   = nil,
Hooked         = false,
CurWave        = 0,
WaveStartClock = 0,
UpgradeBatch   = {},
}
local Flags       = {}
local Connections = {
Player_General = nil,
Knockback      = {},
Reconnect      = nil,
GameFinished = nil
}
local GameFinished = false
local LastFinished = false
local MCENTERS = {
["SchoolGrounds"]           = Vector3.new(3078, 1800, 3338),
["FlowerForest"]            = Vector3.new(3026, 1910, 2958),  
["Dressrosa"]               = Vector3.new(3819, 1779, 2410),  
["FairyKingForest"]         = Vector3.new(2765, 1772, 3056),  
["KingsTomb"]               = Vector3.new(3010, 1971, 2923),  
["SchoolGroundsExpedition"] = Vector3.new(0, 0, 0),  
["FlowerForestExpedition"]  = Vector3.new(0, 0, 0),  
["DressrosaExpedition"]     = Vector3.new(0, 0, 0),  
["SpiritCity"]              = Vector3.new(0, 0, 0),  
["VillainInvasion"]         = Vector3.new(0, 0, 0),  
["CreatorSpotlight"]        = Vector3.new(0, 0, 0),  
}
local JoinerConfigs = {
{ Name = "Story",      Toggle = "AutoJoinStory",      MM = "SJMatchmaking", Priority = "SJPriority", Build = StoryQueue },
{ Name = "Raid",       Toggle = "AutoJoinRaid",       MM = "RJMatchmaking", Priority = "RJPriority", Build = RaidQueue },
{ Name = "Expedition", Toggle = "AutoJoinExpedition", MM = "EJMatchmaking", Priority = "EJPriority", Build = ExpdQueue },
{ Name = "Challenge",  Toggle = "AutoJoinChallenge",  MM = "CJMatchmaking", Priority = "CJPriority", Build = ChallQueue },
}
local yuri = {
"https://mangadex.org/covers/5311ac6f-3651-43a8-bb9c-b40dea7ab72d/062845cb-4498-4499-a23a-89ecac694ea9.jpg",
"https://mangadex.org/covers/df01a222-faeb-4952-84ac-d6040815e2dd/ec777628-a5d7-4d5f-92f5-11a8a746427e.jpg",
"https://cdn.donmai.us/original/dc/0e/__hayafuji_kasane_and_aoyama_meguru_keiyaku_shimai_drawn_by_hijiki_hijikini__dc0e2235f2ca00dcb06aa3db2999bd1f.jpg",
"https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/233/thumbnail.jpg",
"https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/328/thumbnail.jpg",
"https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/1339/thumbnail.jpeg",
"https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/1268/thumbnail.jpeg",
"https://dynasty-scans.com/system/releases/000/040/979/001.webp",
"https://dynasty-scans.com/system/images_images/000/031/460/full/GErfQqXagAA4mk7-orig.webp",
"https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2026/02/01/15/33/44/140636490_p0_master1200.jpg",
"https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2022/08/15/23/52/23/100515820_p0_master1200.jpg",
"https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2025/07/22/17/09/45/132989170_p0_master1200.jpg",
"https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2019/12/01/21/59/30/78092730_p0_master1200.jpg",
}
local SlotPositions   = {}
local FailedPositions = {}  
local SpanCursor = {}
local SpanCache = {}
local PCubePool = {
Free = {},
Active = {},
}
local function PCubeAcq()
local part = table.remove(PCubePool.Free)
if not part then
part = Instance.new("Part")
part.Name         = "PCube"
part.Size         = Vector3.new(0.5, 0.5, 0.5)
part.Anchored     = true
part.CanCollide   = false
part.CastShadow   = false
part.Material     = Enum.Material.Neon
end
part.Transparency = 0.55
part.Color        = Color3.fromRGB(80, 160, 255)
part.Parent        = workspace
PCubePool.Active[part] = true
return part
end
local function PCubeRelease(part)
if not part or not PCubePool.Active[part] then return end
PCubePool.Active[part] = nil
part.Parent = nil
table.insert(PCubePool.Free, part)
end
local function PCubeReleaseAll()
for part in pairs(PCubePool.Active) do
PCubePool.Active[part] = nil
part.Parent = nil
table.insert(PCubePool.Free, part)
end
end
local CurrentMapLabelRef = nil
local PosStatusLabelRef  = nil
local function CFrameToArr(cf)
local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cf:GetComponents()
return { x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 }
end
local function ArrToCFrame(arr)
if type(arr) ~= "table" or #arr < 12 then return CFrame.new() end
return CFrame.new(
arr[1], arr[2], arr[3],
arr[4], arr[5], arr[6],
arr[7], arr[8], arr[9],
arr[10], arr[11], arr[12]
)
end
local function GetTimeString()
return MState.CurWave .. " " .. (os.clock() - MState.WaveStartClock)
end
local function CFToPos(cf)
local x,y,z,r00,r01,r02,r10,r11,r12,r20,r21,r22 = cf:GetComponents()
return string.format(
"%.9g, %.9g, %.9g, %g, %g, %g, %g, %g, %g, %g, %g, %g",
x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22
)
end
local function GetUnitPos(model)
local name = model.Name
local unitsFolder = workspace:FindFirstChild("Units")
if not unitsFolder then return name .. " - 1" end
local idx = 0
for _, child in ipairs(unitsFolder:GetChildren()) do
if child.Name == name then
idx = idx + 1
if child == model then
return name .. " - " .. idx
end
end
end
return name .. " - 1"
end
local function UpdateLabel(suffix)
if MState.LabelRef and MState.LabelRef.SetText then
local txt
if MState.Rec then
if suffix then
txt = string.format("Recording [%d] %s", MState.Step, suffix)
else
txt = string.format("Recording [%d]", MState.Step)
end
elseif MState.Rep then
txt = string.format("Replaying [%d / %d]", MState.Step, MState.Total)
if suffix then txt = txt .. " | " .. suffix end
else
txt = "Idle"
if suffix then txt = txt .. " | " .. suffix end
end
notyuri("[Macro Rec] UpdateLabel called, txt=", txt, "LabelRef exists=", MState.LabelRef ~= nil)
local ok, err = pcall(function() MState.LabelRef:SetText(txt) end)
if not ok then
notyuri("[Macro Rec] SetText FAILED:", tostring(err))
MState.PendingLabel = txt
end
end
end
local function LabelPump()
while MState.Rec do
if MState.PendingLabel then
local txt = MState.PendingLabel
MState.PendingLabel = nil
local ok, err = pcall(function() MState.LabelRef:SetText(txt) end)
if not ok then
notyuri("[Macro Rec] LabelPump SetText FAILED:", tostring(err))
end
end
task.wait(0.1)
end
end
local function GetSlotName(slot)
local playerReplica = Nodes.GET_PLAYER_REPLICA:InvokeSelf()
if not playerReplica then return nil end
local hotbar = playerReplica.Data.HotbarData
if not hotbar then return nil end
local unitInstanceId = hotbar[tostring(slot)]
if not unitInstanceId then return nil end
local unitData = playerReplica.Data.UnitData
if not unitData then return nil end
local entry = unitData[unitInstanceId]
return entry and entry.Asset
end
local function CommitEntry(entry, labelSuffix)
if not MState.Rec or not MState.Cur then return end
MState.Step = MState.Step + 1
MState.Cur.entries[MState.Step] = entry
UpdateLabel(labelSuffix or entry.Type)
end
local function ParsePosToArr(posStr)
local nums = {}
for n in posStr:gmatch("[^,%s]+") do
table.insert(nums, tonumber(n))
end
return (#nums == 12) and nums or nil
end
local function FindUnitByRef(posStr)
local name, idxStr = posStr:match("^(.+)%s%-%s(%d+)$")
if not name or not idxStr then return nil end
local targetIdx = tonumber(idxStr)
local unitsFolder = workspace:FindFirstChild("Units")
if not unitsFolder then return nil end
local count = 0
for _, child in ipairs(unitsFolder:GetChildren()) do
if child.Name == name then
count = count + 1
if count == targetIdx then return child end
end
end
return nil
end
local function FindSlot(unitName)
local playerReplica = Nodes.GET_PLAYER_REPLICA:InvokeSelf()
if not playerReplica then return nil end
local hotbar  = playerReplica.Data.HotbarData
local unitMap = playerReplica.Data.UnitData
if not hotbar or not unitMap then return nil end
for slotStr, instanceId in pairs(hotbar) do
local ud = unitMap[instanceId]
if ud and ud.Asset == unitName then
return tonumber(slotStr)
end
end
return nil
end
local function FindUnit(targetCF)
local unitsFolder = workspace:FindFirstChild("Units")
if not unitsFolder then return nil end
local bestDist, bestModel = math.huge, nil
for _, model in ipairs(unitsFolder:GetChildren()) do
local hrp = model:FindFirstChild("HumanoidRootPart")
if hrp then
local d = (hrp.Position - targetCF.Position).Magnitude
if d < bestDist then
bestDist  = d
bestModel = model
end
end
end
return bestDist < 5 and bestModel or nil
end
local function LoadMDir()
if not writefile then return end
pcall(function()
if not isfolder(MDir) then
makefolder(MDir)
end
end)
end
local function ListMacros()
local names = {}
if not listfiles then return names end
local ok, files = pcall(listfiles, MDir)
if not ok or type(files) ~= "table" then return names end
for _, path in ipairs(files) do
if type(path) == "string" and path:sub(-5):lower() == ".json" then
local fname = path:match("([^/\\]+)%.json$")
if fname and fname ~= "" then table.insert(names, fname) end
end
end
table.sort(names)
return names
end
local function LoadMacro(name)
if not name or name == "" or not readfile then return nil end
local path = MDir .. "/" .. name .. ".json"
if not isfile(path) then return nil end
local ok, raw = pcall(readfile, path)
if not ok or type(raw) ~= "string" or raw == "" then return nil end
local data
pcall(function() data = HttpService:JSONDecode(raw) end)
if type(data) ~= "table" then return nil end
if type(data.actions) == "table" then
return { v = 2, entries = data.actions }
end
if type(data["1"]) == "table" and type(data["1"].Type) == "string" then
local entries = {}
local i = 1
while data[tostring(i)] do
entries[i] = data[tostring(i)]
i = i + 1
end
return { v = 3, entries = entries }
end
return nil
end
local function SaveMacro(name, macro)
if not name or name == "" or not writefile then return false end
LoadMDir()
local path = MDir .. "/" .. name .. ".json"
local out  = {}
for i, entry in ipairs(macro.entries) do
out[tostring(i)] = entry
end
local ok = pcall(function()
writefile(path, HttpService:JSONEncode(out))
end)
return ok
end
local function HandlePlace(slot, cf, isPhantom)
local unitName = GetSlotName(slot)
local timeStr  = GetTimeString()
task.delay(0.5, function()
if not MState.Rec then return end
local model = FindUnit(cf)
if not model then
notyuri("[Macro Rec] PlaceGameUnit GUARD FAIL: no unit appeared")
return
end
local entry = {
Type = "PlaceUnit",
Time = timeStr,
Unit = unitName or model.Name,
Pos  = CFToPos(cf),
}
if isPhantom then entry.Phantom = true end
CommitEntry(entry, "Place " .. (unitName or "?"))
notyuri("[Macro Rec] PlaceUnit recorded", entry.Unit, "phantom=", tostring(isPhantom))
end)
end
local function HandleUpg(unitId, arg5)
local model = Nodes.GET_UNIT_MODEL_FROM_ID:InvokeSelf(unitId)
local hrp   = model and model:FindFirstChild("HumanoidRootPart")
if not hrp then
notyuri("[Macro Rec] UpgradeGameUnit: no HRP for unitId=" .. unitId)
return
end
local amount        = (type(arg5) == "number" and arg5 > 1) and arg5 or nil
local beforeReplica = Nodes.GET_REPLICA_FROM_UNIT_MODEL:InvokeSelf(model)
local beforeUpgrade = beforeReplica and beforeReplica.Data and beforeReplica.Data.Upgrade
local posStr        = GetUnitPos(model)
local timeStr       = GetTimeString()
task.delay(0.5, function()
if not MState.Rec then return end
local afterReplica  = Nodes.GET_REPLICA_FROM_UNIT_MODEL:InvokeSelf(model)
local afterUpgrade  = afterReplica and afterReplica.Data and afterReplica.Data.Upgrade
if beforeUpgrade ~= nil and afterUpgrade ~= nil and afterUpgrade <= beforeUpgrade then
notyuri("[Macro Rec] UpgradeUnit GUARD FAIL: level unchanged at", posStr)
return
end
local entry = { Type = "UpgradeUnit", Time = timeStr, Pos = posStr }
if amount then entry.Amount = amount end
CommitEntry(entry, "Upgrade" .. (amount and " x" .. amount or ""))
notyuri("[Macro Rec] UpgradeUnit recorded", posStr, amount and ("x"..amount) or "")
end)
end
local function HandleSell(unitId)
local model = Nodes.GET_UNIT_MODEL_FROM_ID:InvokeSelf(unitId)
local hrp   = model and model:FindFirstChild("HumanoidRootPart")
if not hrp then
notyuri("[Macro Rec] SellGameUnit: no HRP for unitId=" .. unitId)
return
end
local posStr  = GetUnitPos(model)
local timeStr = GetTimeString()
task.delay(0.5, function()
if not MState.Rec then return end
if model.Parent ~= nil then
notyuri("[Macro Rec] SellUnit GUARD FAIL: model still alive at", posStr)
return
end
local entry = { Type = "SellUnit", Time = timeStr, Pos = posStr }
CommitEntry(entry, "Sell")
notyuri("[Macro Rec] SellUnit recorded", posStr)
end)
end
local function HandlePrior(unitId, prio)
local model = Nodes.GET_UNIT_MODEL_FROM_ID:InvokeSelf(unitId)
local hrp   = model and model:FindFirstChild("HumanoidRootPart")
if not hrp then
notyuri("[Macro Rec] ChangeGameUnitPriority: no HRP for unitId=" .. unitId)
return
end
local posStr = GetUnitPos(model)
local entry  = {
Type = "ChangePriority",
Time = GetTimeString(),
Pos  = posStr,
Prio = tostring(prio),
}
CommitEntry(entry, "Priority " .. tostring(prio))
notyuri("[Macro Rec] ChangePriority", posStr, prio)
end
local function HandleAUpg(unitId)
local model = Nodes.GET_UNIT_MODEL_FROM_ID:InvokeSelf(unitId)
local hrp   = model and model:FindFirstChild("HumanoidRootPart")
if not hrp then
notyuri("[Macro Rec] ChangeGameUnitAutoUpgradePriority: no HRP for unitId=" .. unitId)
return
end
local posStr = GetUnitPos(model)
local entry  = {
Type = "ToggleAutoUpgrade",
Time = GetTimeString(),
Pos  = posStr,
}
CommitEntry(entry, "Auto Upgrade")
notyuri("[Macro Rec] ToggleAutoUpgrade", posStr)
end
local function StartRec()
if MState.Hooked then return end
local originalNamecall
originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
local self   = ...
local Method = getnamecallmethod()
local ret    = table.pack(originalNamecall(...))
if MState.Rec
and Method == "FireServer"
and rawequal(self, ReplicaWrite) then
local action = select(3, ...)
local arg4   = select(4, ...)
local arg5   = select(5, ...)
task.defer(function()
if action == "PlaceGameUnit" or action == "PlaceGamePhantom" then
local slot    = arg4
local cf      = arg5
local phantom = (action == "PlaceGamePhantom")
if type(slot) ~= "number" or typeof(cf) ~= "CFrame" then return end
HandlePlace(slot, cf, phantom)
elseif action == "UpgradeGameUnit" then
local unitId = arg4
if type(unitId) ~= "string" then return end
HandleUpg(unitId, arg5)
elseif action == "SellGameUnit" then
local unitId = arg4
if type(unitId) ~= "string" then return end
HandleSell(unitId)
elseif action == "ChangeGameUnitPriority" then
local unitId = arg4
local prio   = arg5
if type(unitId) ~= "string" then return end
HandlePrior(unitId, prio)
elseif action == "ChangeGameUnitAutoUpgradePriority" then
local unitId = arg4
if type(unitId) ~= "string" then return end
HandleAUpg(unitId)
end
end)
end
return table.unpack(ret, 1, ret.n)
end))
MState.Hooked = true
notyuri("[Macro] __namecall hook installed")
end
local function Func_MacRec(state)
if state then
if Toggles.LoadMacro and Toggles.LoadMacro.Value then
Toggles.LoadMacro:SetValue(false)
end
MState.Rec            = true
MState.Rep            = false
MState.Step           = 0
MState.CurWave        = 0
MState.WaveStartClock = os.clock()
MState.Cur = {
name    = "Macro_" .. os.date("%Y%m%d_%H%M%S"),
entries = {},
v       = 3,
}
StartRec()
UpdateLabel()
task.spawn(LabelPump)
task.spawn(function()
while MState.Rec do
local gr = Nodes.GET_GAME_REPLICA:InvokeSelf()
if gr then
local w = gr.Data.Wave or 0
if w ~= MState.CurWave then
MState.CurWave        = w
MState.WaveStartClock = os.clock()
notyuri("[Macro Rec] Wave changed to", w)
end
end
task.wait(0.25)
end
end)
else
MState.Rec = false
for _, batch in pairs(MState.UpgradeBatch) do
if batch.thread then task.cancel(batch.thread) end
end
MState.UpgradeBatch = {}
if MState.Cur and #MState.Cur.entries > 0 then
local fname = (Options.FileName and Options.FileName.Value) or ""
if fname == "" then fname = MState.Cur.name end
fname = fname:gsub("[^A-Za-z0-9_%-]", "_")
if SaveMacro(fname, MState.Cur) then
Library:Notify("Saved: " .. fname .. " (" .. #MState.Cur.entries .. " steps)", 5)
end
if Options.MacroSelected then
Options.MacroSelected:SetValues(ListMacros())
end
end
MState.Cur  = nil
MState.Step = 0
UpdateLabel()
end
end
local function Func_LoadMacro()
while Toggles.LoadMacro.Value do
local macro = MState.Load
if not macro or not macro.entries or #macro.entries == 0 then
Toggles.LoadMacro:SetValue(false)
break
end
MState.Rep   = true
MState.Total = #macro.entries
local repWave      = 0
local repWaveStart = os.clock()
local Restart = false
if macro.v == 3 then
local gr = Nodes.GET_GAME_REPLICA:InvokeSelf()
if gr then repWave = gr.Data.Wave or 0 end
repWaveStart = os.clock()
end
if not Restart then
for i, action in ipairs(macro.entries) do
if not Toggles.LoadMacro.Value then break end
MState.Step = i
if macro.v == 3 then
local tWave, tElapsed
if type(action.Time) == "string" then
local wStr, eStr = action.Time:match("^(%d+)%s+(.+)$")
tWave    = tonumber(wStr)
tElapsed = tonumber(eStr)
end
local skipStep = false
if tWave and tElapsed then
if tWave > repWave then
while repWave < tWave and Toggles.LoadMacro.Value do
task.wait(.1)
local gr = Nodes.GET_GAME_REPLICA:InvokeSelf()
if gr then
local w = gr.Data.Wave or 0
if w < repWave then
Restart = true
break
elseif w ~= repWave then
repWave      = w
repWaveStart = os.clock()
end
end
end
if Restart then break end
end
if not Toggles.LoadMacro.Value then break end
local elapsed = os.clock() - repWaveStart
local diff    = tElapsed - elapsed
if diff < -5 then
skipStep = true
elseif diff > 0 then
task.wait(diff)
end
end
if not Toggles.LoadMacro.Value then break end
if skipStep then
UpdateLabel("skipped")
else
UpdateLabel(action.Type)
local Replica = Nodes.GET_GAME_PLAYER_REPLICA:InvokeSelf()
if not Replica then
task.wait(.5)
elseif action.Type == "PlaceUnit" then
local slot = FindSlot(action.Unit)
if slot then
local arr = ParsePosToArr(action.Pos)
if arr then
local cf     = ArrToCFrame(arr)
local remote = action.Phantom and "PlaceGamePhantom" or "PlaceGameUnit"
local placed = false
for retry = 1, 3 do
pcall(function()
Replica:FireServer(remote, slot, cf)
end)
task.wait(.1)
if FindUnit(cf) then
placed = true
break
end
end
end
end
elseif action.Type == "UpgradeUnit" then
local model = FindUnitByRef(action.Pos)
if model then
local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
if unitId then
local upgraded = false
for retry = 1, 3 do
local beforeReplica = Nodes.GET_REPLICA_FROM_UNIT_MODEL:InvokeSelf(model)
local beforeUpgrade = beforeReplica and beforeReplica.Data and beforeReplica.Data.Upgrade
pcall(function()
Replica:FireServer("UpgradeGameUnit", unitId, action.Amount)
end)
task.wait(.1)
local afterReplica = Nodes.GET_REPLICA_FROM_UNIT_MODEL:InvokeSelf(model)
local afterUpgrade = afterReplica and afterReplica.Data and afterReplica.Data.Upgrade
if beforeUpgrade == nil or afterUpgrade == nil or afterUpgrade > beforeUpgrade then
upgraded = true
break
end
end
end
end
elseif action.Type == "SellUnit" then
local model = FindUnitByRef(action.Pos)
if model then
local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
if unitId then
local sold = false
for retry = 1, 3 do
pcall(function()
Replica:FireServer("SellGameUnit", unitId)
end)
task.wait(.1)
if model.Parent == nil then
sold = true
break
end
end
end
end
elseif action.Type == "ChangePriority" then
local model = FindUnitByRef(action.Pos)
if model then
local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
if unitId then
pcall(function()
Replica:FireServer("ChangeGameUnitPriority", unitId, action.Prio)
end)
end
end
elseif action.Type == "ToggleAutoUpgrade" then
local model = FindUnitByRef(action.Pos)
if model then
local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
if unitId then
pcall(function()
Replica:FireServer("ChangeGameUnitAutoUpgradePriority", unitId)
end)
end
end
end
end
else
UpdateLabel(action.type)
if action.d and action.d > 0 then
task.wait(action.d)
end
if not Toggles.LoadMacro.Value then break end
local Replica = Nodes.GET_GAME_PLAYER_REPLICA:InvokeSelf()
if not Replica then
task.wait(.5)
elseif action.type == "place" then
local cf = ArrToCFrame(action.cf)
pcall(function()
Replica:FireServer("PlaceGameUnit", action.slot, cf)
end)
elseif action.type == "upgrade" then
local targetCF = ArrToCFrame(action.cf)
local model    = FindUnit(targetCF)
if model then
local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
if unitId then
pcall(function()
Replica:FireServer("UpgradeGameUnit", unitId, action.level)
end)
end
end
elseif action.type == "sell" then
local targetCF = ArrToCFrame(action.cf)
local model    = FindUnit(targetCF)
if model then
local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
if unitId then
pcall(function()
Replica:FireServer("SellGameUnit", unitId)
end)
end
end
elseif action.type == "priority" then
local targetCF = ArrToCFrame(action.cf)
local model    = FindUnit(targetCF)
if model then
local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
if unitId then
pcall(function()
Replica:FireServer("ChangeGameUnitPriority", unitId, action.prio)
end)
end
end
elseif action.type == "autoupgrade" then
local targetCF = ArrToCFrame(action.cf)
local model    = FindUnit(targetCF)
if model then
local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
if unitId then
pcall(function()
Replica:FireServer("ChangeGameUnitAutoUpgradePriority", unitId)
end)
end
end
end
end
end
if not Restart and Toggles.LoadMacro.Value then
UpdateLabel("Finished")
WaitReset(repWave, function() return Toggles.LoadMacro.Value end, "")
end
end
MState.Rep  = false
MState.Step = 0
UpdateLabel("done")
end
MState.Rep = false
UpdateLabel()
end
local function Cleanup(tbl)
for key, value in pairs(tbl) do
if typeof(value) == "RBXScriptConnection" then
value:Disconnect()
tbl[key] = nil
elseif typeof(value) == "thread" then
task.cancel(value)
tbl[key] = nil
elseif type(value) == "table" then
Cleanup(value)
end
end
end
function Thread(featurePath, featureFunc, isEnabled, ...)
local pathParts    = featurePath:split(".")
local currentTable = Flags
for i = 1, #pathParts - 1 do
local part = pathParts[i]
if not currentTable[part] then currentTable[part] = {} end
currentTable = currentTable[part]
end
local flagKey     = pathParts[#pathParts]
local activeThread = currentTable[flagKey]
if isEnabled then
if not activeThread or coroutine.status(activeThread) == "dead" then
local newThread = task.spawn(featureFunc, ...)
currentTable[flagKey] = newThread
end
else
if activeThread and typeof(activeThread) == "thread" then
task.cancel(activeThread)
currentTable[flagKey] = nil
end
end
end
local function SafeLoop(name, func)
return function()
local success, e = pcall(func)
if not success then
Library:Notify("Error in [" .. name .. "]: " .. tostring(e), 10)
notyuri("Error in [" .. name .. "]: " .. tostring(e))
end
end
end
function AddSliderToggle(Config)
local Toggle = Config.Group:AddToggle(Config.Id, {
Text    = Config.Text,
Default = Config.DefaultToggle or false
})
local Slider = Config.Group:AddSlider(Config.Id .. "Value", {
Text     = Config.Text,
Default  = Config.Default,
Min      = Config.Min,
Max      = Config.Max,
Rounding = Config.Rounding or 0,
Compact  = true,
Visible  = false
})
Toggle:OnChanged(function()
Slider:SetVisible(Toggle.Value)
end)
return Toggle, Slider
end
local function GetCharacter()
local c = Plr.Character
return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
end
local function FuncTPW()
while true do
local delta = RunService.Heartbeat:Wait()
local char  = GetCharacter()
local hum   = char and char:FindFirstChildOfClass("Humanoid")
if char and hum and hum.Health > 0 then
if hum.MoveDirection.Magnitude > 0 then
char:TranslateBy(hum.MoveDirection * Options.TPWValue.Value * delta * 10)
end
end
end
end
local function FuncNoclip()
while Toggles.Noclip.Value do
RunService.Stepped:Wait()
local char = GetCharacter()
if char then
for _, part in pairs(char:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then
part.CanCollide = false
end
end
end
end
end
local function Func_AntiKnockback()
if type(Connections.Knockback) == "table" then
for _, conn in pairs(Connections.Knockback) do
if conn then conn:Disconnect() end
end
table.clear(Connections.Knockback)
else
Connections.Knockback = {}
end
local function ApplyAntiKB(character)
if not character then return end
local root = character:WaitForChild("HumanoidRootPart", 10)
if root then
local conn = root.ChildAdded:Connect(function(child)
if not Toggles.AntiKnockback.Value then return end
if child:IsA("BodyVelocity") and child.MaxForce == Vector3.new(40000, 40000, 40000) then
child:Destroy()
end
end)
table.insert(Connections.Knockback, conn)
end
end
if Plr.Character then ApplyAntiKB(Plr.Character) end
local charAddedConn = Plr.CharacterAdded:Connect(function(newChar)
ApplyAntiKB(newChar)
end)
table.insert(Connections.Knockback, charAddedConn)
repeat task.wait(1) until not Toggles.AntiKnockback.Value
for _, conn in pairs(Connections.Knockback) do
if conn then conn:Disconnect() end
end
table.clear(Connections.Knockback)
end
local function Func_AutoReconnect()
if Connections.Reconnect then Connections.Reconnect:Disconnect() end
Connections.Reconnect = GuiService.ErrorMessageChanged:Connect(function()
if not Toggles.AutoReconnect.Value then return end
task.delay(2, function()
pcall(function()
local promptOverlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
if promptOverlay then
local errorPrompt = promptOverlay.promptOverlay:FindFirstChild("ErrorPrompt")
if errorPrompt and errorPrompt.Visible then
task.wait(2)
TeleportService:Teleport(game.PlaceId, Plr)
end
end
end)
end)
end)
end
local function Func_NoGameplayPaused()
while Toggles.NoGameplayPaused.Value do
pcall(function()
local pauseGui = game:GetService("CoreGui").RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
if pauseGui then pauseGui:Destroy() end
end)
task.wait(1)
end
end
local function ApplyFPSBoost(state)
if not state then return end
pcall(function()
Lighting.GlobalShadows = false
Lighting.FogEnd        = 9e9
Lighting.Brightness    = 1
for _, v in pairs(Lighting:GetChildren()) do
if v:IsA("PostProcessEffect") or v:IsA("BloomEffect")
or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
v.Enabled = false
end
end
task.spawn(function()
for i, v in pairs(workspace:GetDescendants()) do
if Toggles.FPSBoost and not Toggles.FPSBoost.Value then break end
pcall(function()
if v:IsA("BasePart") then
v.Material   = Enum.Material.SmoothPlastic
v.CastShadow = false
elseif v:IsA("Decal") or v:IsA("Texture") then
v:Destroy()
elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
v.Enabled = false
end
end)
if i % 500 == 0 then task.wait() end
end
end)
end)
end
local function FirePP(target, teleport)
if not fireproximityprompt then return end
if not target or not target:IsA("ProximityPrompt") then return end
if teleport then
local char = GetCharacter()
local hrp  = char and char:FindFirstChild("HumanoidRootPart")
local part = target.Parent
local isModel = false
if part then
if part:IsA("Model") then
isModel = true
elseif not part:IsA("BasePart") then
part = target:FindFirstAncestorWhichIsA("BasePart")
if not part then
part = target:FindFirstAncestorWhichIsA("Model")
if part then isModel = true end
end
end
end
if hrp and part then
local partPos  = isModel and part:GetPivot().Position or part.Position
local dist     = (hrp.Position - partPos).Magnitude
local prevDist = target.MaxActivationDistance
if dist > prevDist then
local partCF = isModel and part:GetPivot() or part.CFrame
hrp.CFrame   = partCF * CFrame.new(0, 3, 0)
task.wait(0.175)
end
end
end
fireproximityprompt(target)
end
local function GetGameReplica()
local result, done
task.spawn(function() result = Nodes.GET_GAME_REPLICA:InvokeSelf() done = true end)
local start = tick()
repeat task.wait() until done or (tick() - start) > 2
return result
end
local function GetGamePlayerReplica()
return Nodes.GET_GAME_PLAYER_REPLICA:InvokeSelf()
end
local function StartGameFinishedWatcher()
if Connections.GameFinished then Connections.GameFinished:Disconnect() end
GameFinished = false
Connections.GameFinished = Nodes.SHOW_END_SCREEN:Connect(function()
GameFinished = true
end)
end
local function IsGameFinished()
return GameFinished
end
local function SendGameRequest(action, ...)
local args = {...}
pcall(function()
Nodes.SEND_GAME_REQUEST:FireSelf(nil, action, unpack(args))
end)
end
local function Func_AutoClaimQuest()
while Toggles.AutoClaimQuest.Value do
pcall(function() Nodes.QUEST_CLAIM_ALL:FireServer() end)
task.wait(0.3)
pcall(function() Nodes.QUEST_CLAIM_ALL_CATEGORIES:FireServer() end)
task.wait(3)
end
end
local function Func_AutoClaimBattlepass()
while Toggles.AutoClaimBattlepass.Value do
pcall(function() Nodes.CLAIM_ALL_BATTLEPASS_REWARDS:FireServer("free") end)
task.wait(0.3)
pcall(function() Nodes.CLAIM_ALL_BATTLEPASS_REWARDS:FireServer("premium") end)
task.wait(3)
end
end
local function Func_AutoClaimMilestone()
while Toggles.AutoClaimMilestone.Value do
pcall(function() Nodes.QUESTBOARD_CLAIM_ALL_MILESTONES:FireServer() end)
task.wait(3)
end
end
local function Func_AutoClaimIndex()
while Toggles.AutoClaimIndex.Value do
pcall(function() Nodes.INDEX_CLAIM_ALL:FireServer() end)
task.wait(3)
end
end
local function Func_AutoClaimCalendar()
while Toggles.AutoClaimCalendar.Value do
for day = 1, 7 do
pcall(function() Nodes.CLAIM_CALENDAR:FireServer(day, "free") end)
task.wait(0.2)
end
task.wait(3)
end
end
local function Func_AutoClaimGroup()
while Toggles.AutoClaimGroup.Value do
pcall(function() Nodes.GROUP_REWARDS_CLAIM:FireServer() end)
task.wait(3)
end
end
local function Func_AutoVoteStart()
pcall(function() Nodes.CLIENT_CHANGE_SETTING:FireServer("AutoVoteStart", true) end)
notyuri("[AutoVoteStart] Enabled game AutoVoteStart setting")
while Toggles.AutoVoteStart.Value do
task.wait(1)
end
pcall(function() Nodes.CLIENT_CHANGE_SETTING:FireServer("AutoVoteStart", false) end)
notyuri("[AutoVoteStart] Disabled game AutoVoteStart setting")
end
local function Func_AutoVoteSkip()
while Toggles.AutoVoteSkip.Value do
local stopWave = tonumber(Options.SkipStopWave.Value) or 0
local gr = GetGameReplica()
local wave = gr and gr.Data and (gr.Data.Wave or 0) or 0
if stopWave == 0 or wave < stopWave then
SendGameRequest("SkipWave")
end
task.wait(0.1)
end
end
local function Func_AutoRestart()
while Toggles.AutoRestart.Value do
local gr = GetGameReplica()
if gr and gr.Data then
local finished = gr.Data.Finished == true
if finished and not LastFinished then
LastFinished = true
task.wait(1)
pcall(function()
local pr = GetGamePlayerReplica()
if pr then
pr:FireServer("RestartGame")
end
end)
notyuri("[AutoRestart] Stage finished, restarting")
elseif not finished then
LastFinished = false
end
end
task.wait(.5)
end
end
local function Func_GameplayVoteStart()
while Toggles.GameplayVoteStart.Value do
local gr = GetGameReplica()
local inGame = gr and gr.Data and gr.Data.Wave and gr.Data.Wave > 0
if not inGame then
local pr = GetGamePlayerReplica()
if pr then
pcall(function() pr:FireServer("StartGame") end)
end
end
task.wait(.5)
end
end
local function Func_AutoSkipWave()
pcall(function() Nodes.CLIENT_TOGGLE_AUTO_SKIP_WAVES:FireServer() end)
end
local function Func_AutoReplay()
pcall(function() Nodes.CLIENT_CHANGE_SETTING:FireServer("AutoRetry", true) end)
while Toggles.AutoReplay.Value do
task.wait(1)
end
pcall(function() Nodes.CLIENT_CHANGE_SETTING:FireServer("AutoRetry", false) end)
end
local function Func_AutoNext()
pcall(function() Nodes.CLIENT_CHANGE_SETTING:FireServer("AutoNext", true) end)
while Toggles.AutoNext.Value do
task.wait(1)
end
pcall(function() Nodes.CLIENT_CHANGE_SETTING:FireServer("AutoNext", false) end)
end
local function Func_AutoReturnLobby()
while Toggles.AutoReturnLobby.Value do
local gr = GetGameReplica()
if gr and gr.Data then
local wave = gr.Data.Wave or 0
local finished = gr.Data.Finished == true
if wave > 0 and not finished then
local deadline = tick() + (tonumber(Options.AutoReturnLobbyTime.Value) or 5) * 60
while Toggles.AutoReturnLobby.Value and tick() < deadline do
task.wait(1)
local gr2 = GetGameReplica()
if not gr2 or not gr2.Data or (gr2.Data.Finished == true) or (gr2.Data.Wave or 0) == 0 then
break
end
end
if Toggles.AutoReturnLobby.Value then
local gr3 = GetGameReplica()
if gr3 and gr3.Data and not gr3.Data.Finished and (gr3.Data.Wave or 0) > 0 then
local pr = GetGamePlayerReplica()
if pr then
pcall(function() pr:FireServer("Lobby") end)
notyuri("[AutoReturnLobby] triggered, returning to lobby")
end
end
end
end
end
task.wait(2)
end
end
local function Func_TPLobby()
while Toggles.TPLobby.Value do
local gr = GetGameReplica()
if gr and gr.Data then
local wave = gr.Data.Wave or 0
local finished = gr.Data.Finished == true
if wave > 0 and not finished then
local deadline = tick() + (tonumber(Options.TPLobbyTime.Value) or 10) * 60
while Toggles.TPLobby.Value and tick() < deadline do
task.wait(1)
local gr2 = GetGameReplica()
if not gr2 or not gr2.Data or (gr2.Data.Finished == true) or (gr2.Data.Wave or 0) == 0 then
break
end
end
if Toggles.TPLobby.Value then
local gr3 = GetGameReplica()
if gr3 and gr3.Data and not gr3.Data.Finished and (gr3.Data.Wave or 0) > 0 then
notyuri("[TPLobby] triggered, teleporting to lobby")
pcall(function() TeleportService:Teleport(game.PlaceId, Plr) end)
end
end
end
end
task.wait(2)
end
end
local UnitUtils    = require(RS:WaitForChild("Shared"):WaitForChild("UnitUtils"))
local UnitReplicas = require(RS:WaitForChild("Shared"):WaitForChild("UnitReplicas"))
local Information  = require(RS:WaitForChild("Shared"):WaitForChild("Information"))
local function Func_AutoSellFarm()
local _lastSoldFarm = false
while Toggles.AutoSellFarm.Value do
local gr = GetGameReplica()
local wave = gr and gr.Data and (gr.Data.Wave or 0) or 0
local targetWave = tonumber(Options.SellFarmWave.Value) or 0
if targetWave > 0 and wave >= targetWave then
if not _lastSoldFarm then
_lastSoldFarm = true
local pr = GetGamePlayerReplica()
local unitsFolder = workspace:FindFirstChild("Units")
if pr and unitsFolder then
local sold = 0
for _, model in ipairs(unitsFolder:GetChildren()) do
local replica = UnitReplicas[model]
if replica then
local asset = replica.Data and replica.Data.UnitData and replica.Data.UnitData.Asset
if asset and UnitUtils:IsUnitNameFarm(asset) then
local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
if unitId then
pcall(function() pr:FireServer("SellGameUnit", unitId) end)
sold = sold + 1
end
end
end
end
notyuri("[AutoSellFarm] Sold", sold, "farm units at wave", wave)
end
end
else
_lastSoldFarm = false
end
task.wait(2)
end
end
local function Func_AutoSellUnit()
local _lastSoldUnit = false
while Toggles.AutoSellUnit.Value do
local gr = GetGameReplica()
local wave = gr and gr.Data and (gr.Data.Wave or 0) or 0
local targetWave = tonumber(Options.SellUnitWave.Value) or 0
if targetWave > 0 and wave >= targetWave then
if not _lastSoldUnit then
_lastSoldUnit = true
local pr = GetGamePlayerReplica()
if pr then
pcall(function() pr:FireServer("SellAllGameUnits") end)
notyuri("[AutoSellUnit] Sold all units at wave", wave)
end
end
else
_lastSoldUnit = false
end
task.wait(2)
end
end
local function FailKey(cf)
return string.format("%d,%d", math.round(cf.X), math.round(cf.Z))
end
local function GetCurrentMapName()
local gr = GetGameReplica()
return gr and gr.Data and gr.Data.Parameters and gr.Data.Parameters.MapName
end
local function PosText(mapName)
if not mapName then return "Not in a game" end
local lines = {}
for i = 1, 6 do
local cf = SlotPositions[mapName] and SlotPositions[mapName][i] and SlotPositions[mapName][i][1]
if cf then
table.insert(lines, string.format("Slot %d: %.1f, %.1f, %.1f", i, cf.X, cf.Y, cf.Z))
else
table.insert(lines, "Slot " .. i .. ": No Position")
end
end
return table.concat(lines, "\n")
end
local function UpdatePosLabels()
local mapName = GetCurrentMapName()
if CurrentMapLabelRef then
pcall(function()
CurrentMapLabelRef:SetText("Current Map: " .. (mapName or "Not in game"))
end)
end
if PosStatusLabelRef then
pcall(function()
PosStatusLabelRef:SetText(PosText(mapName))
end)
end
end
local function GetGround(pos)
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
local excluded = {}
local unitsFolder = workspace:FindFirstChild("Units")
if unitsFolder then table.insert(excluded, unitsFolder) end
for _, v in ipairs(workspace:GetChildren()) do
if v.Name == "PCube" then table.insert(excluded, v) end
end
rayParams.FilterDescendantsInstances = excluded
local result = workspace:Raycast(pos, Vector3.new(0, -10, 0), rayParams)
local finalY = result and result.Position.Y + 1 or (pos.Y + 1)
notyuri("[GetGround] from=(" .. string.format("%.1f,%.1f,%.1f", pos.X, pos.Y, pos.Z) ..
") hit=" .. tostring(result ~= nil) ..
(result and (" hitInstance=" .. tostring(result.Instance and result.Instance:GetFullName())) or "") ..
" finalY=" .. string.format("%.1f", finalY))
return finalY
end
local function HandleSlotPos(act, slot)
local mapName = GetCurrentMapName()
if not mapName then
Library:Notify("Not in a game — map not detected", 3)
return
end
if act == "reset" then
if slot then
if SlotPositions[mapName] then SlotPositions[mapName][slot] = nil end
Library:Notify("Slot " .. slot .. " positions cleared (" .. mapName .. ")", 3)
notyuri("[AutoPlay] ResetPos slot=" .. slot .. " map=" .. mapName)
else
SlotPositions[mapName] = nil
Library:Notify("All slot positions cleared (" .. mapName .. ")", 3)
notyuri("[AutoPlay] ResetPos all map=" .. mapName)
end
UpdatePosLabels()
return
end
local char = GetCharacter()
local hrp  = char and char:FindFirstChild("HumanoidRootPart")
if not hrp then
Library:Notify("Character not found", 3)
return
end
local pos = hrp.Position
local groundY = GetGround(pos)
local cf = CFrame.new(Vector3.new(pos.X, groundY, pos.Z))
if not SlotPositions[mapName] then SlotPositions[mapName] = {} end
if act == "set" then
if not SlotPositions[mapName][slot] then SlotPositions[mapName][slot] = {} end
table.insert(SlotPositions[mapName][slot], cf)
local count = #SlotPositions[mapName][slot]
Library:Notify("Slot " .. slot .. " pos " .. count .. " set (" .. mapName .. ")", 3)
notyuri("[AutoPlay] SetPos slot=" .. slot .. " count=" .. count .. " map=" .. mapName .. " Y=" .. string.format("%.2f", cf.Y))
elseif act == "massset" then
for i = 1, 6 do
if not SlotPositions[mapName][i] then SlotPositions[mapName][i] = {} end
table.insert(SlotPositions[mapName][i], cf)
end
Library:Notify("All 6 slots: pos appended (" .. mapName .. ")", 3)
notyuri("[AutoPlay] MassSetPos map=" .. mapName .. " Y=" .. string.format("%.2f", cf.Y))
end
UpdatePosLabels()
end
local function SetPos(slot)
HandleSlotPos("set", slot)
end
local function MassSetPos()
HandleSlotPos("massset")
end
local function ResetPos(slot)
HandleSlotPos("reset", slot)
end
local function DoSpan(center, count, spacing)
spacing = spacing or 1.5
local result = {}
if count <= 0 then return result end
result[1] = CFrame.new(Vector3.new(center.X, GetGround(center), center.Z))
if count == 1 then return result end
local x, z = 0, 0          
local dx, dz = 1, 0        
local segLen  = 1           
local stepped = 0           
local turns   = 0           
while #result < count do
x  = x + dx
z  = z + dz
local px = center.X + x * spacing
local pz = center.Z + z * spacing
table.insert(result, CFrame.new(
px,
GetGround(Vector3.new(px, center.Y, pz)),
pz
))
stepped = stepped + 1
if stepped == segLen then
stepped = 0
dx, dz = -dz, dx
turns = turns + 1
if turns % 2 == 0 then
segLen = segLen + 1
end
end
end
return result
end
local function ExtendSpan(cache, center, upToCount, spacing)
spacing = spacing or 1.5
if upToCount <= 0 then return cache end
if #cache == 0 then
cache[1] = CFrame.new(Vector3.new(center.X, GetGround(center), center.Z))
cache.x, cache.z = 0, 0
cache.dx, cache.dz = 1, 0
cache.segLen  = 1
cache.stepped = 0
cache.turns   = 0
end
while #cache < upToCount do
cache.x = cache.x + cache.dx
cache.z = cache.z + cache.dz
local px = center.X + cache.x * spacing
local pz = center.Z + cache.z * spacing
table.insert(cache, CFrame.new(
px,
GetGround(Vector3.new(px, center.Y, pz)),
pz
))
cache.stepped = cache.stepped + 1
if cache.stepped == cache.segLen then
cache.stepped = 0
cache.dx, cache.dz = -cache.dz, cache.dx
cache.turns = cache.turns + 1
if cache.turns % 2 == 0 then
cache.segLen = cache.segLen + 1
end
end
end
return cache
end
local function PositionsAroundCenter(center, count)
if count <= 0 then return {} end
if count == 1 then return { CFrame.new(center) } end
return DoSpan(center, count, 1.5)
end
local function CountPlaced(slot)
local unitName = GetSlotName(slot)
if not unitName then return 0 end
local unitsFolder = workspace:FindFirstChild("Units")
if not unitsFolder then return 0 end
local count = 0
for _, model in ipairs(unitsFolder:GetChildren()) do
if model.Name == unitName then
local rep = Nodes.GET_REPLICA_FROM_UNIT_MODEL:InvokeSelf(model)
if rep and rep.Data and rep.Data.Owner == Plr then
count = count + 1
end
end
end
return count
end
local function GamePlcLimit(slot)
local unitName = GetSlotName(slot)
if not unitName then return 0 end
local info = UnitUtils:GetUnitInfo(unitName)
if not info then return 1 end
local lim = info.PlacementLimit
if lim == nil or lim ~= lim or lim == math.huge then return 1 end
return lim
end
local function GetPlcLimit(slot)
local cfg = tonumber(Options["APPlaceLimit" .. slot] and Options["APPlaceLimit" .. slot].Value) or 0
local game = GamePlcLimit(slot)
return (cfg > 0) and math.min(cfg, game) or game
end
local function GetUpgLimit(slot)
return tonumber(Options["APUpgradeLimit" .. slot] and Options["APUpgradeLimit" .. slot].Value) or 0
end
local function GetUnits()
local unitsFolder = workspace:FindFirstChild("Units")
if not unitsFolder then return {} end
local result = {}
for _, model in ipairs(unitsFolder:GetChildren()) do
local rep = Nodes.GET_REPLICA_FROM_UNIT_MODEL:InvokeSelf(model)
if rep and rep.Data and rep.Data.Owner == Plr then
local unitId = Nodes.GET_ID_FROM_UNIT_MODEL:InvokeSelf(model)
if unitId then
local slot       = FindSlot(model.Name)
local upgrade    = rep.Data.Upgrade or 0
local maxUpgrade = rep.Data.MaxUpgrade or 0
local cfgCap     = slot and GetUpgLimit(slot) or 0
local effectiveMax = (cfgCap > 0) and math.min(cfgCap, maxUpgrade) or maxUpgrade
table.insert(result, {
model        = model,
unitId       = unitId,
slot         = slot,
upgrade      = upgrade,
maxUpgrade   = maxUpgrade,
effectiveMax = effectiveMax,
})
end
end
end
return result
end
local function UpgradeCand(units)
local method    = Options.APUpgradeMethod and Options.APUpgradeMethod.Value or "Lowest Level (Spread Upgrade)"
local focusFarm = Toggles.APFocusFarm and Toggles.APFocusFarm.Value
local upgradable = {}
for _, e in ipairs(units) do
if e.upgrade < e.effectiveMax then
table.insert(upgradable, e)
end
end
if #upgradable == 0 then return nil end
if focusFarm then
local farms = {}
for _, e in ipairs(upgradable) do
if UnitUtils:IsUnitNameFarm(e.model.Name) then
table.insert(farms, e)
end
end
if #farms > 0 then upgradable = farms end
end
if method == "Randomize" then
return upgradable[math.random(1, #upgradable)]
elseif method == "Lowest Level (Spread Upgrade)" then
table.sort(upgradable, function(a, b) return a.upgrade < b.upgrade end)
return upgradable[1]
elseif method == "Hotbar left to right (until Max)" or method == "Customize upgrade order (Set below)" then
table.sort(upgradable, function(a, b)
local sa, sb = a.slot or 99, b.slot or 99
if sa ~= sb then return sa < sb end
return a.upgrade < b.upgrade
end)
return upgradable[1]
end
return upgradable[1]
end
local function DoUpgrade(pr)
local units  = GetUnits()
local target = UpgradeCand(units)
if not target then return false end
pcall(function()
pr:FireServer("UpgradeGameUnit", target.unitId)
end)
notyuri("[AutoPlay] UpgradeGameUnit slot=" .. tostring(target.slot) .. " unit=" .. target.model.Name .. " lv=" .. target.upgrade)
task.wait(0.25)
return true
end
local function PlacePhase(pr, currentWave)
local mapName = GetCurrentMapName()
local centerRaw = mapName and MCENTERS[mapName]
local center = centerRaw and centerRaw ~= Vector3.new(0, 0, 0) and Vector3.new(centerRaw.X, GetGround(centerRaw), centerRaw.Z) or centerRaw
notyuri("[PlacePhase] mapName=" .. tostring(mapName) ..
" centerRaw=" .. (centerRaw and string.format("(%.1f,%.1f,%.1f)", centerRaw.X, centerRaw.Y, centerRaw.Z) or "nil") ..
" center=" .. (center and string.format("(%.1f,%.1f,%.1f)", center.X, center.Y, center.Z) or "nil"))
local slotOrder = {}
for i = 1, 6 do table.insert(slotOrder, i) end
table.sort(slotOrder, function(a, b)
local oa = tonumber(Options["APPlaceOrder" .. a] and Options["APPlaceOrder" .. a].Value) or a
local ob = tonumber(Options["APPlaceOrder" .. b] and Options["APPlaceOrder" .. b].Value) or b
return oa < ob
end)
local allPlaced = true
local waitingForYen = false
for _, slot in ipairs(slotOrder) do
if not Toggles.AutoPlay.Value then break end
if waitingForYen then break end
local placeWave = tonumber(Options["APPlaceWave" .. slot] and Options["APPlaceWave" .. slot].Value) or 0
if placeWave > 0 and currentWave < placeWave then
allPlaced = false
else
local unitName = GetSlotName(slot)
if unitName then
local limit  = GetPlcLimit(slot)
local placed = CountPlaced(slot)
local need   = limit - placed
if need > 0 then
allPlaced = false
if not FailedPositions[mapName] then FailedPositions[mapName] = {} end
local failed = FailedPositions[mapName]
local positions = {}
local slotCfg = mapName and SlotPositions[mapName] and SlotPositions[mapName][slot]
if slotCfg and #slotCfg > 0 then
if #slotCfg >= limit then
for i = 1, #slotCfg do
if not failed[FailKey(slotCfg[i].Position)] then
table.insert(positions, slotCfg[i])
end
end
if #positions == 0 then
local centerPos = slotCfg[1].Position
local cursorKey = mapName .. ":" .. FailKey(centerPos)
if not SpanCache[cursorKey] then SpanCache[cursorKey] = {} end
local cache = SpanCache[cursorKey]
local idx = SpanCursor[cursorKey] or 0
local collected = 0
while collected < need do
idx = idx + 1
ExtendSpan(cache, centerPos, idx)
local cf = cache[idx]
if not failed[FailKey(cf.Position)] then
table.insert(positions, cf)
collected = collected + 1
end
end
SpanCursor[cursorKey] = idx
end
else
local centerPos = slotCfg[1].Position
local cursorKey = mapName .. ":" .. FailKey(centerPos)
if not SpanCache[cursorKey] then SpanCache[cursorKey] = {} end
local cache = SpanCache[cursorKey]
local idx = SpanCursor[cursorKey] or 0
local collected = 0
while collected < need do
idx = idx + 1
ExtendSpan(cache, centerPos, idx)
local cf = cache[idx]
if not failed[FailKey(cf.Position)] then
table.insert(positions, cf)
collected = collected + 1
end
end
SpanCursor[cursorKey] = idx
end
elseif center and center ~= Vector3.new(0, 0, 0) then
local cursorKey = mapName .. ":center"
if not SpanCache[cursorKey] then SpanCache[cursorKey] = {} end
positions.__spiral = true
positions.__cache = SpanCache[cursorKey]
positions.__center = center
positions.__cursorKey = cursorKey
positions.__need = need
end
local unitInfo = nil
pcall(function() unitInfo = UnitUtils:GetUnitInfo(unitName) end)
local placeCost = unitInfo and unitInfo.UpgradeInfo and unitInfo.UpgradeInfo[0] and unitInfo.UpgradeInfo[0].Cost or 0
local placedThisCall = 0
while true do
if not Toggles.AutoPlay.Value then break end
local cf
if positions.__spiral then
if placedThisCall >= positions.__need then break end
if placeCost > 0 then
local currentYen = pr.Data and pr.Data.Yen or 0
if currentYen < placeCost then
waitingForYen = true
break
end
end
local cache = positions.__cache
local idx = SpanCursor[positions.__cursorKey] or 0
local found = false
while not found do
idx = idx + 1
ExtendSpan(cache, positions.__center, idx)
local candidate = cache[idx]
if not failed[FailKey(candidate.Position)] then
cf = candidate
found = true
end
end
SpanCursor[positions.__cursorKey] = idx
notyuri("[PlacePhase] slot=" .. slot .. " cursorKey=" .. positions.__cursorKey ..
" idx=" .. idx .. " pos=" .. string.format("(%.1f,%.1f,%.1f)", cf.Position.X, cf.Position.Y, cf.Position.Z))
placedThisCall = placedThisCall + 1
else
placedThisCall = placedThisCall + 1
if placedThisCall > #positions then break end
cf = positions[placedThisCall]
if placeCost > 0 then
local currentYen = pr.Data and pr.Data.Yen or 0
if currentYen < placeCost then
waitingForYen = true
break
end
end
end
local ghost = PCubeAcq()
ghost.CFrame       = cf * CFrame.new(0, 0.5, 0)
local countBefore = CountPlaced(slot)
local ok = false
for retry = 1, 1 do
pcall(function() pr:FireServer("PlaceGameUnit", slot, cf) end)
task.wait(0.3)
if CountPlaced(slot) > countBefore then
ok = true
break
end
end
notyuri("[PlacePhase] PLACE slot=" .. slot .. " unit=" .. tostring(unitName) ..
" pos=" .. string.format("(%.1f,%.1f,%.1f)", cf.Position.X, cf.Position.Y, cf.Position.Z) ..
" ok=" .. tostring(ok))
failed[FailKey(cf.Position)] = true
if ok then
ghost.Color        = Color3.fromRGB(80, 255, 120)
ghost.Transparency = 0.6
else
ghost.Color        = Color3.fromRGB(255, 80, 80)
ghost.Transparency = 0.6
end
if not ok then
waitingForYen = true
else
if Toggles.APPlaceAndUpgrade and Toggles.APPlaceAndUpgrade.Value then
DoUpgrade(pr)
end
if CountPlaced(slot) >= limit then
break
end
end
end
end
end
end
end
return allPlaced
end
local function Func_AutoPlay()
local lastGameId = nil  
while Toggles.AutoPlay.Value do
local gr   = GetGameReplica()
local wave = gr and gr.Data and (gr.Data.Wave or 0) or 0
if wave > 0 then
local gameId = gr.Data.GameTime
if gameId ~= lastGameId then
lastGameId = gameId
FailedPositions = {}
StartGameFinishedWatcher()
notyuri("[AutoPlay] New game detected, blacklist cleared")
end
local pr = GetGamePlayerReplica()
if not pr then
notyuri("[AutoPlay] No player replica, retrying")
task.wait(1)
else
notyuri("[AutoPlay] Starting, wave=" .. wave)
local lastWave = wave
while Toggles.AutoPlay.Value do
local decreased, currentWave = WaveChanged(lastWave)
if decreased then
notyuri("[AutoPlay] Wave decreased (" .. lastWave .. " -> " .. currentWave .. ") — game ended")
PCubeReleaseAll()
break
end
lastWave = currentWave
local allPlaced = PlacePhase(pr, currentWave)
if allPlaced and Toggles.APAutoUpgrade and Toggles.APAutoUpgrade.Value then
local didUpgrade = DoUpgrade(pr)
if not didUpgrade then
task.wait(1)
end
end
task.wait(0.1)
end
end
else
task.wait(1)
end
end
end
local function Func_AutoCraft()
while Toggles.AutoCraft.Value do
if recipe ~= "" then
pcall(function()
Nodes.REQUEST_CRAFT_CRAFTING_RECIPE:FireServer(recipe, 1)
end)
end
task.wait(2)
end
end
local function GetActiveBanners()
local ok, banners = pcall(function()
return Nodes.GET_ACTIVE_BANNERS:InvokeSelf()
end)
local names = {}
if ok and type(banners) == "table" then
for bannerId in pairs(banners) do
table.insert(names, bannerId)
end
table.sort(names)
end
return names
end
local function GetSummonTargetList()
local ok, list = pcall(function()
return Information:GetCommandAssetList("Unit")
end)
local values = {}
if ok and type(list) == "table" then
for _, name in ipairs(list) do
if name ~= "All" and name ~= "AllHidden" then
table.insert(values, name)
end
end
end
return values
end
local SummonHookConn = nil
local SummonTargetHit = false
local SummonTargetAsset = nil
local function HookSummonRewards()
if SummonHookConn then return end
SummonHookConn = Nodes.PROMPT_OBTAINED_REWARDS:Connect(function(rewards)
if not (Toggles.AutoSummon and Toggles.AutoSummon.Value) then return end
if type(rewards) ~= "table" then return end
local targets = Options.SummonTargets and Options.SummonTargets.Value or {}
if next(targets) == nil then return end
for _, entry in ipairs(rewards) do
local asset = entry and entry.Asset
if asset and targets[asset] then
SummonTargetHit = true
SummonTargetAsset = asset
return
end
end
end)
end
local function Func_AutoSummon()
SummonTargetHit = false
SummonTargetAsset = nil
HookSummonRewards()
while Toggles.AutoSummon.Value do
if SummonTargetHit then
break
end
local banner = Options.SummonBanner and Options.SummonBanner.Value
if not banner or banner == "" then
Library:Notify("No banner selected", 3)
break
end
pcall(function()
Nodes.BANNER_SUMMON:FireServer(banner, 10)
end)
notyuri("[AutoSummon] Rolled banner=" .. tostring(banner))
task.wait(1)
if SummonTargetHit then
break
end
end
if SummonTargetHit then
notyuri("[AutoSummon] Target obtained: " .. tostring(SummonTargetAsset))
Library:Notify("Target obtained: " .. tostring(SummonTargetAsset), 6)
end
if Toggles.AutoSummon.Value then
task.spawn(function()
Toggles.AutoSummon:SetValue(false)
end)
end
end
local function StoryQueue()
local map = Options.SJMap and Options.SJMap.Value
if not map or map == "" then return nil end
return {
Gamemode   = "Story",
MapName    = map,
ActName    = Options.SJAct and Options.SJAct.Value,
Difficulty = Options.SJDifficulty and Options.SJDifficulty.Value,
}
end
local function RaidQueue()
local map = Options.RJMap and Options.RJMap.Value
if not map or map == "" then return nil end
return {
Gamemode   = "Raid",
MapName    = map,
ActName    = Options.RJAct and Options.RJAct.Value,
Difficulty = Options.RJDifficulty and Options.RJDifficulty.Value,
}
end
local function ExpdQueue()
local map = Options.EJMap and Options.EJMap.Value
if not map or map == "" then return nil end
return {
Gamemode        = "Expedition",
MapName         = map,
DifficultyLevel = Options.EJDifficultyLevel and Options.EJDifficultyLevel.Value,
}
end
local function ChallQueue()
local ctype = Options.CJType and Options.CJType.Value
if not ctype or ctype == "" then return nil end
return {
Gamemode       = "Challenge",
ChallengeType  = ctype,
ChallengeIndex = Options.CJIndex and Options.CJIndex.Value,
}
end
local function DoJoin(queueData)
local partyReplica = Nodes.GET_PARTY_DATA_REPLICA:InvokeSelf()
if partyReplica then
partyReplica:FireServer("StartGame")
else
local reqId = math.random(1, 2^31)
local conn
conn = Nodes.PARTY_CREATE_ReturnNODE:Connect(function(id)
if id ~= reqId then return end
conn:Disconnect()
partyReplica = Nodes.WAIT_FOR_PARTY_REPLICA:InvokeSelf()
task.wait(1)
if partyReplica then
partyReplica:FireServer("StartGame")
else
notyuri("[AutoJoiner] DoJoin: WAIT_FOR_PARTY_REPLICA returned nil")
end
end)
Nodes.PARTY_CREATE_RequestNODE:FireServer(reqId, queueData or {})
task.delay(5, function()
if conn.Connected then
conn:Disconnect()
notyuri("[AutoJoiner] DoJoin: PARTY_CREATE_ReturnNODE timed out")
end
end)
end
end
local function JoinerEnabled()
for _, cfg in ipairs(JoinerConfigs) do
local t = Toggles[cfg.Toggle]
if t and t.Value then return true end
end
return false
end
local function Func_AutoJoiner()
while JoinerEnabled() do
local gr = GetGameReplica()
local inGame = gr and gr.Data and gr.Data.Wave and gr.Data.Wave > 0 and gr.Data.Finished ~= true
if not inGame then
local candidates = {}
for _, cfg in ipairs(JoinerConfigs) do
local t = Toggles[cfg.Toggle]
if t and t.Value then
table.insert(candidates, cfg)
end
end
table.sort(candidates, function(a, b)
local pa = (Options[a.Priority] and Options[a.Priority].Value) or 99
local pb = (Options[b.Priority] and Options[b.Priority].Value) or 99
return pa < pb
end)
local chosen, queueData
for _, cfg in ipairs(candidates) do
local data = cfg.Build()
if data then
chosen = cfg
queueData = data
break
else
notyuri("[AutoJoiner] Priority " .. tostring((Options[cfg.Priority] and Options[cfg.Priority].Value) or "?") .. " (" .. cfg.Name .. ") Build() returned nil, falling back")
end
end
if chosen and queueData then
pcall(function() Nodes.REQUEST_LEAVE_MATCHMAKING:Request() end)
task.wait(1)
local mm = Toggles[chosen.MM]
if mm and mm.Value then
pcall(function() Nodes.REQUEST_ENTER_MATCHMAKING:Request(queueData) end)
notyuri("[AutoJoiner] Matchmaking into " .. chosen.Name)
else
DoJoin(queueData)
notyuri("[AutoJoiner] Solo joining " .. chosen.Name)
end
task.wait(3)
end
end
task.wait(2)
end
end
local function UpdateAutoJoinerThread()
local enabled = JoinerEnabled()
if Flags["AutoJoiner"] and typeof(Flags["AutoJoiner"]) == "thread" then
task.cancel(Flags["AutoJoiner"])
Flags["AutoJoiner"] = nil
end
Thread("AutoJoiner", Func_AutoJoiner, enabled)
end
local function SendWebhook(title, description)
if not request then return end
local img = yuri[math.random(1, #yuri)]
pcall(function()
request({
Url = Options.WebhookURL.Value,
Method = "POST",
Headers = { ["Content-Type"] = "application/json" },
Body = HttpService:JSONEncode({
username = "Yuri",
avatar_url = img,
embeds = {
{
title = title,
description = description,
color = 0xFFB6C1,
thumbnail = { url = img },
},
},
}),
})
end)
end
local function Func_WHMatchEnd()
local conn
conn = Nodes.SHOW_END_SCREEN:Connect(function(p1)
if not Toggles.WHMatchEnd.Value then
conn:Disconnect()
return
end
local rd = p1
if not rd then return end
local victory = rd.Victory and "Victory" or "Defeat"
local gm = rd.Gamemode or "Unknown"
local mapName = rd.MapName or ""
local actName = rd.ActName or ""
local diff = rd.Difficulty or ""
local totalTime = rd.TotalTime or 0
local mins = math.floor(totalTime / 60)
local secs = totalTime % 60
local stageParts = {}
if mapName ~= "" then table.insert(stageParts, mapName) end
if actName ~= "" or diff ~= "" then
local inner = {}
if actName ~= "" then table.insert(inner, actName) end
if diff ~= "" then table.insert(inner, diff) end
table.insert(stageParts, "(" .. table.concat(inner, " - ") .. ")")
end
local stageStr = string.format("[%s] %s - %s", gm, table.concat(stageParts, " "), victory)
local rewardTotals = {}
local rewardOrder = {}
if type(rd.Rewards) == "table" then
for _, reward in ipairs(rd.Rewards) do
local asset = reward.Asset or "?"
local amount = reward.Amount or 1
if rewardTotals[asset] then
rewardTotals[asset] = rewardTotals[asset] + amount
else
rewardTotals[asset] = amount
table.insert(rewardOrder, asset)
end
end
end
local rewardLines = {}
for _, asset in ipairs(rewardOrder) do
table.insert(rewardLines, string.format("+%s %s", tostring(rewardTotals[asset]), asset))
end
local timeStr = string.format("%d:%02d", mins, secs)
local desc = string.format(
"**%s**\n- Time: %s\n- Player: ||%s||\n- Reward:\n%s",
stageStr,
timeStr,
Plr.Name,
#rewardLines > 0 and table.concat(rewardLines, "\n") or "None"
)
SendWebhook("Stage Finished", desc)
notyuri("[Webhook] Stage finished notification sent")
end)
while Toggles.WHMatchEnd.Value do
task.wait(1)
end
if conn then conn:Disconnect() end
end
local function DoDeleteMap()
if Toggles.DeleteMap and Toggles.DeleteMap.Value then
for _, v in pairs(workspace:GetDescendants()) do
pcall(function()
if v:IsA("BasePart") and not v:IsDescendantOf(Plr.Character or {}) then
v.Transparency = 1
if v:IsA("MeshPart") then v.TextureID = "" end
end
end)
end
end
end
local function Func_DeleteMap()
while Toggles.DeleteMap.Value do
DoDeleteMap()
task.wait(2)
end
end
local function Func_DeleteEnemies()
while Toggles.DeleteEnemies.Value do
local enemies = workspace:FindFirstChild("Enemies")
if enemies then
for _, enemy in ipairs(enemies:GetChildren()) do
pcall(function() enemy.Parent = nil end)
end
end
task.wait(1)
end
end
local function Func_BlackScreen()
while Toggles.BlackScreen.Value do
pcall(function()
local gui = Instance.new("ScreenGui")
gui.Name = "Bs"
gui.IgnoreGuiInset = true
gui.DisplayOrder = 9999
local frame = Instance.new("Frame")
frame.Size = UDim2.fromScale(1, 1)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = gui
gui.Parent = game:GetService("CoreGui")
task.wait(1)
gui:Destroy()
end)
task.wait(0.5)
end
end
local _nameConn = nil
local function Func_HideName()
if Toggles.HideName.Value then
_nameConn = game:GetService("RunService").RenderStepped:Connect(function()
for _, plr in ipairs(Players:GetPlayers()) do
if plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
if humanoid then
pcall(function() humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end)
end
local head = plr.Character:FindFirstChild("Head")
if head then
for _, child in ipairs(head:GetChildren()) do
if child:IsA("BillboardGui") or child:IsA("SurfaceGui") then
pcall(function() child.Enabled = false end)
end
end
end
end
end
end)
else
if _nameConn then
_nameConn:Disconnect()
_nameConn = nil
end
end
end
local Window = Library:CreateWindow({
Title                = "Yuri",
Center               = true,
AutoShow             = true,
Resizable            = true,
ShowCustomCursor     = false,
UnlockMouseWhileOpen = false,
NotifySide           = "Left",
TabPadding           = 8,
MenuFadeTime         = 0.2
})
AddInfo(Window)
local Tabs = {
Main     = Window:AddTab("Main"),
AutoPlay = Window:AddTab("Auto Play"),
Joiner   = Window:AddTab("Joiner"),
Player   = Window:AddTab("Player"),
Webhook  = Window:AddTab("Webhook"),
Config   = Window:AddTab("Config"),
}
local Left  = Tabs.AutoPlay:AddLeftGroupbox("Auto Play")
local Right = Tabs.AutoPlay:AddRightGroupbox("Limits")
Left:AddToggle("AutoPlay", {
Text    = "Auto Play",
Default = false,
})
Left:AddDivider()
Left:AddDropdown("APUpgradeMethod", {
Text    = "Upgrade Method",
Values  = {
"Lowest Level (Spread Upgrade)",
"Hotbar left to right (until Max)",
"Randomize",
"Customize upgrade order (Set below)",
},
Default = "Lowest Level (Spread Upgrade)",
})
Left:AddDivider()
Left:AddToggle("APAutoUpgrade", {
Text    = "Auto Upgrade",
Default = false,
})
Left:AddToggle("APPlaceAndUpgrade", {
Text    = "Place and Upgrade",
Default = false,
})
Left:AddToggle("APFocusFarm", {
Text    = "Focus on Farm",
Default = false,
})
Right:AddLabel("Place Order per Slot", true)
for i = 1, 6 do
Right:AddSlider("APPlaceOrder" .. i, {
Text     = "Slot " .. i,
Default  = i,
Min      = 1,
Max      = 6,
Rounding = 0,
Compact  = true,
})
end
Right:AddDivider()
Right:AddLabel("Place Wave per Slot", true)
for i = 1, 6 do
Right:AddSlider("APPlaceWave" .. i, {
Text     = "Slot " .. i,
Default  = 0,
Min      = 0,
Max      = 50,
Rounding = 0,
Compact  = true,
})
end
Right:AddDivider()
Right:AddLabel("Place Limit per Slot", true)
for i = 1, 6 do
Right:AddSlider("APPlaceLimit" .. i, {
Text     = "Slot " .. i,
Default  = 0,
Min      = 0,
Max      = 10,
Rounding = 0,
Compact  = true,
})
end
Right:AddDivider()
Right:AddLabel("Upgrade Limit per Slot", true)
for i = 1, 6 do
Right:AddSlider("APUpgradeLimit" .. i, {
Text     = "Slot " .. i,
Default  = 0,
Min      = 0,
Max      = 30,
Rounding = 0,
Compact  = true,
})
end
local Pos_A    = Tabs.AutoPlay:AddLeftGroupbox("Set Position")
local Pos_B = Tabs.AutoPlay:AddRightGroupbox("Position Manage")
Pos_A:AddLabel("Stand where you want units placed, select a slot, then press Set Slot Position.", true)
CurrentMapLabelRef = Pos_A:AddLabel("Current Map: ...", true)
Pos_A:AddDropdown("APSetSlotSelect", {
Text    = "Set Slot Position",
Values  = { "Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5", "Slot 6" },
Default = "Slot 1",
})
Pos_A:AddButton({
Text = "Set Slot Position",
Func = function()
local val  = Options.APSetSlotSelect and Options.APSetSlotSelect.Value or "Slot 1"
local slot = tonumber(val:match("%d+")) or 1
SetPos(slot)
end,
})
Pos_A:AddButton({
Text = "Mass Set All Slots",
Func = function()
MassSetPos()
end,
})
Pos_B:AddLabel("Positions recorded for current map:", true)
PosStatusLabelRef = Pos_B:AddLabel("Not in a game", true)
Pos_B:AddDivider()
Pos_B:AddDropdown("APResetSlotSelect", {
Text    = "Reset Position",
Values  = { "Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5", "Slot 6", "All Slots" },
Default = "Slot 1",
})
Pos_B:AddButton({
Text = "Reset Slot Positions",
Func = function()
local val = Options.APResetSlotSelect and Options.APResetSlotSelect.Value or "Slot 1"
if val == "All Slots" then
ResetPos(nil)
else
local slot = tonumber(val:match("%d+"))
ResetPos(slot)
end
end,
})
task.spawn(function()
while not Library.Unloaded do
UpdatePosLabels()
task.wait(2)
end
end)
local WH1 = Tabs.Webhook:AddLeftGroupbox("Webhook")
local TB = {
Main = {
Left  = { Autofarm = Tabs.Main:AddLeftTabbox()  },
Right = { Autofarm = Tabs.Main:AddRightTabbox() },
},
}
local TB_Tabs = {
Autofarm = {
T1    = TB.Main.Left.Autofarm:AddTab("Macro"),
T2   = TB.Main.Left.Autofarm:AddTab("Reward"),
T3   = TB.Main.Left.Autofarm:AddTab("Lobby"),
T4   = TB.Main.Left.Autofarm:AddTab("Game"),
},
Autofarm2 = {
T1    = TB.Main.Right.Autofarm:AddTab("Game Config"),
T2    = TB.Main.Right.Autofarm:AddTab("Lobby Config"),
},
}
local GB = {
Player = {
Left  = {
General = Tabs.Player:AddLeftGroupbox("General"),
Server  = Tabs.Player:AddLeftGroupbox("Server"),
},
Right = {
Game = Tabs.Player:AddRightGroupbox("Game"),
},
},
}
TB_Tabs.Autofarm.T1:AddDropdown("MacroSelected", {
Text   = "Select File",
Values = ListMacros(),
Default = ListMacros()[1] or "",
})
Options.MacroSelected:OnChanged(function(v)
if v and v ~= "" then
MState.Load = LoadMacro(v)
if not MState.Load then
Library:Notify("Failed to load macro: " .. v, 4)
end
end
end)
TB_Tabs.Autofarm.T1:AddInput("FileName", {
Text        = "File Name",
Default     = "",
Placeholder = "yuriyuri",
})
TB_Tabs.Autofarm.T1:AddToggle("RecMacro", {
Text    = "Record Macro",
Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("LoadMacro", {
Text    = "Load Macro",
Default = false,
})
MState.LabelRef = TB_Tabs.Autofarm.T1:AddLabel("Idle", true)
Toggles.RecMacro:OnChanged(function(v)
Func_MacRec(v)
end)
Toggles.LoadMacro:OnChanged(function(v)
if v then
if not MState.Load then
local name = Options.MacroSelected and Options.MacroSelected.Value or ""
if name and name ~= "" then
MState.Load = LoadMacro(name)
end
end
if not MState.Load then
Library:Notify("No macro selected", 3)
Toggles.LoadMacro:SetValue(false)
return
end
end
Thread("LoadMacro", Func_LoadMacro, v)
end)
LoadMDir()
TB_Tabs.Autofarm.T2:AddToggle("AutoClaimQuest", { Text = "Auto Claim Quests", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoClaimBattlepass", { Text = "Auto Claim Battlepass", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoClaimMilestone", { Text = "Auto Claim Milestones", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoClaimIndex", { Text = "Auto Claim Index", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoClaimCalendar", { Text = "Auto Claim Calendar", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoVoteSkip", { Text = "Auto Vote Skip", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoRestart", { Text = "Auto Restart", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoVoteStart", { Text = "Auto Vote Start", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoSkipWave", { Text = "Auto Skip Wave", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoReplay", { Text = "Auto Replay", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoNext", { Text = "Auto Next", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoReturnLobby", { Text = "Auto Return Lobby", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("TPLobby", { Text = "Auto TP Lobby", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoSellFarm", { Text = "Auto Sell Farm", Default = false })
TB_Tabs.Autofarm.T4:AddToggle("AutoSellUnit", { Text = "Auto Sell Unit", Default = false })
TB_Tabs.Autofarm.T3:AddToggle("AutoCraft", { Text = "Auto Craft", Default = false })
local SummonBannerValues = GetActiveBanners()
local SummonTargetValues = GetSummonTargetList()
TB_Tabs.Autofarm2.T2:AddDropdown("SummonBanner", {
Text    = "Target Banner",
Values  = SummonBannerValues,
Default = SummonBannerValues[1] or "",
})
TB_Tabs.Autofarm2.T2:AddDropdown("SummonTargets", {
Text      = "Target Unit",
Values    = SummonTargetValues,
Default   = {},
Multi     = true,
AllowNull = true,
Searchable = true,
})
TB_Tabs.Autofarm.T3:AddToggle("AutoSummon", { Text = "Auto Summon", Default = false })
WH1:AddToggle("WHMatchEnd", { Text = "Match End", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("AutoReturnLobbyTime", { Text = "Return Lobby", Default = "5" })
TB_Tabs.Autofarm2.T1:AddInput("TPLobbyTime", { Text = "TP Lobby", Default = "10" })
TB_Tabs.Autofarm2.T1:AddInput("SkipStopWave", { Text = "Skip Stop Wave", Default = "0" })
TB_Tabs.Autofarm2.T1:AddInput("SellFarmWave", { Text = "Sell Farm Wave", Default = "0" })
TB_Tabs.Autofarm2.T1:AddInput("SellUnitWave", { Text = "Sell Unit Wave", Default = "0" })
local SJ_DefaultMap   = (Information.Maps:GetOrderedMaps("Story"))[1]
local SJ_DefaultActs  = Information.Maps:GetOrderedActs("Story", SJ_DefaultMap)
local SJ_DefaultDiffs = (Information.Maps:GetMapData("Story", SJ_DefaultMap) or {}).Difficulties or {}
local SJ = Tabs.Joiner:AddLeftGroupbox("Story Joiner")
SJ:AddToggle("AutoJoinStory", { Text = "Auto Join Story", Default = false })
SJ:AddToggle("SJMatchmaking", { Text = "Match Making", Default = false })
SJ:AddDropdown("SJMap", { Text = "Map", Values = Information.Maps:GetOrderedMaps("Story"), Default = SJ_DefaultMap })
SJ:AddDropdown("SJAct", { Text = "Act", Values = SJ_DefaultActs, Default = SJ_DefaultActs[1] })
SJ:AddDropdown("SJDifficulty", { Text = "Difficulty", Values = SJ_DefaultDiffs, Default = SJ_DefaultDiffs[1] })
SJ:AddSlider("SJPriority", { Text = "Priority", Default = 1, Min = 1, Max = 4, Rounding = 0, Compact = true })
Options.SJMap:OnChanged(function(v)
local acts = Information.Maps:GetOrderedActs("Story", v)
Options.SJAct:SetValues(acts)
if not table.find(acts, Options.SJAct.Value) then
Options.SJAct:SetValue(acts[1])
end
local diffs = (Information.Maps:GetMapData("Story", v) or {}).Difficulties or {}
Options.SJDifficulty:SetValues(diffs)
if not table.find(diffs, Options.SJDifficulty.Value) then
Options.SJDifficulty:SetValue(diffs[1])
end
end)
local RJ_DefaultMap   = (Information.Maps:GetOrderedMaps("Raid"))[1]
local RJ_DefaultActs  = Information.Maps:GetOrderedActs("Raid", RJ_DefaultMap)
local RJ_DefaultDiffs = (Information.Maps:GetMapData("Raid", RJ_DefaultMap) or {}).Difficulties or {}
local RJ = Tabs.Joiner:AddRightGroupbox("Raid Joiner")
RJ:AddToggle("AutoJoinRaid", { Text = "Auto Join Raid", Default = false })
RJ:AddToggle("RJMatchmaking", { Text = "Match Making", Default = false })
RJ:AddDropdown("RJMap", { Text = "Map", Values = Information.Maps:GetOrderedMaps("Raid"), Default = RJ_DefaultMap })
RJ:AddDropdown("RJAct", { Text = "Act", Values = RJ_DefaultActs, Default = RJ_DefaultActs[1] })
RJ:AddDropdown("RJDifficulty", { Text = "Difficulty", Values = RJ_DefaultDiffs, Default = RJ_DefaultDiffs[1] })
RJ:AddSlider("RJPriority", { Text = "Priority", Default = 2, Min = 1, Max = 4, Rounding = 0, Compact = true })
Options.RJMap:OnChanged(function(v)
local acts = Information.Maps:GetOrderedActs("Raid", v)
Options.RJAct:SetValues(acts)
if not table.find(acts, Options.RJAct.Value) then
Options.RJAct:SetValue(acts[1])
end
local diffs = (Information.Maps:GetMapData("Raid", v) or {}).Difficulties or {}
Options.RJDifficulty:SetValues(diffs)
if not table.find(diffs, Options.RJDifficulty.Value) then
Options.RJDifficulty:SetValue(diffs[1])
end
end)
local EJ_DefaultMap = (Information.Maps:GetOrderedMaps("Expedition"))[1]
local EJ = Tabs.Joiner:AddLeftGroupbox("Expedition Joiner")
EJ:AddToggle("AutoJoinExpedition", { Text = "Auto Join Expedition", Default = false })
EJ:AddToggle("EJMatchmaking", { Text = "Match Making", Default = false })
EJ:AddDropdown("EJMap", { Text = "Map", Values = Information.Maps:GetOrderedMaps("Expedition"), Default = EJ_DefaultMap })
EJ:AddSlider("EJDifficultyLevel", { Text = "Difficulty Level", Default = 1, Min = 1, Max = 3, Rounding = 0, Compact = true })
EJ:AddSlider("EJPriority", { Text = "Priority", Default = 3, Min = 1, Max = 4, Rounding = 0, Compact = true })
local CJ = Tabs.Joiner:AddRightGroupbox("Challenge Joiner")
CJ:AddToggle("AutoJoinChallenge", { Text = "Auto Join Challenge", Default = false })
CJ:AddToggle("CJMatchmaking", { Text = "Match Making", Default = false })
CJ:AddDropdown("CJType", { Text = "Challenge Type", Values = { "Regular", "Daily", "Weekly" }, Default = "Regular" })
CJ:AddSlider("CJIndex", { Text = "Challenge Slot", Default = 1, Min = 1, Max = 3, Rounding = 0, Compact = true })
CJ:AddSlider("CJPriority", { Text = "Priority", Default = 4, Min = 1, Max = 4, Rounding = 0, Compact = true })
WH1:AddInput("WebhookURL", { Text = "Webhook URL", Default = "" })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS",  Text = "WalkSpeed",  Default = 16,  Min = 16,  Max = 250 })
local TPW_T, TPW_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "JP",  Text = "JumpPower",  Default = 50,  Min = 0,   Max = 500 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "HH",  Text = "HipHeight",  Default = 2,   Min = 0,   Max = 10, Rounding = 1 })
GB.Player.Left.General:AddToggle("Noclip", { Text = "Noclip" })
GB.Player.Left.General:AddToggle("AntiKnockback", { Text = "Anti Knockback", Default = false })
GB.Player.Left.General:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering" })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "FOV",  Text = "Field of View", Default = 70, Min = 30, Max = 120 })
local FPS_T, FPS_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
GB.Player.Left.General:AddToggle("FPSBoost", { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK", {
Text     = "Anti AFK",
Default  = true,
Disabled = not Support.Connections,
})
GB.Player.Left.Server:AddToggle("AntiKick",         { Text = "Anti Kick (Client)" })
GB.Player.Left.Server:AddToggle("AutoReconnect",    { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused" })
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function()
Services.TeleportService:Teleport(game.PlaceId, Plr)
end })
GB.Player.Right.Game:AddToggle("InstantPP",  { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog",      { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
GB.Player.Right.Game:AddToggle("DeleteMap",      { Text = "Delete Map",      Default = false })
GB.Player.Right.Game:AddToggle("DeleteEnemies",  { Text = "Delete Enemies",  Default = false })
GB.Player.Right.Game:AddToggle("BlackScreen",    { Text = "Black Screen",    Default = false })
GB.Player.Right.Game:AddToggle("HideName",       { Text = "Hide Name",       Default = false })
Toggles.AntiKnockback:OnChanged(function(state)
Thread("AntiKnockback", Func_AntiKnockback, state)
end)
Toggles.TPW:OnChanged(function(v)
TPW_S:SetVisible(TPW_T.Value)
Thread("TPW", FuncTPW, v)
end)
Toggles.Noclip:OnChanged(function(v)
Thread("Noclip", FuncNoclip, v)
end)
Connections.Player_General = RunService.Stepped:Connect(function()
local Hum = Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")
if Hum then
if Toggles.WS.Value  then Hum.WalkSpeed  = Options.WSValue.Value end
if Toggles.JP.Value  then Hum.JumpPower  = Options.JPValue.Value; Hum.UseJumpPower = true end
if Toggles.HH.Value  then Hum.HipHeight  = Options.HHValue.Value end
end
workspace.Gravity = Toggles.Grav.Value and Options.GravValue.Value or 192
if Toggles.FOV.Value  then workspace.CurrentCamera.FieldOfView = Options.FOVValue.Value end
if Toggles.Zoom.Value then Plr.CameraMaxZoomDistance           = Options.ZoomValue.Value end
end)
task.spawn(function()
while task.wait() do
if Toggles.Fullbright.Value then
Lighting.Brightness    = 2
Lighting.ClockTime     = 14
Lighting.GlobalShadows = false
elseif Toggles.OverrideTime.Value then
Lighting.ClockTime = Options.OverrideTimeValue.Value
end
if Toggles.NoFog.Value then Lighting.FogEnd = 9e9 end
if Library.Unloaded then break end
end
end)
Options.LimitFPSValue:OnChanged(function()
if FPS_T.Value then setfpscap(FPS_S.Value) end
end)
Toggles.LimitFPS:OnChanged(function(v)
FPS_S:SetVisible(FPS_T.Value)
if not v then setfpscap(999) end
end)
Toggles.Disable3DRender:OnChanged(function(v) RunService:Set3dRenderingEnabled(not v) end)
Toggles.FPSBoost:OnChanged(function(state) ApplyFPSBoost(state) end)
Toggles.AutoReconnect:OnChanged(function(state)
if state then Func_AutoReconnect() end
end)
Toggles.NoGameplayPaused:OnChanged(function(state)
Thread("NoGameplayPaused", SafeLoop("Anti-Pause", Func_NoGameplayPaused), state)
end)
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
if Toggles.InstantPP and Toggles.InstantPP.Value then
prompt.HoldDuration = 0
end
end)
local function RunAntiAFK()
local GC = getconnections or get_signal_cons
if GC then
for _, v in pairs(GC(Players.LocalPlayer.Idled)) do
if v["Disable"]    then v["Disable"](v)
elseif v["Disconnect"] then v["Disconnect"](v) end
end
else
local VU = cloneref(game:GetService("VirtualUser"))
Players.LocalPlayer.Idled:Connect(function()
VU:CaptureController()
VU:ClickButton2(Vector2.new())
end)
end
end
Toggles.AntiAFK:OnChanged(function(state) if state then RunAntiAFK() end end)
if Toggles.AntiAFK.Value then RunAntiAFK() end
Toggles.AutoClaimQuest:OnChanged(function(v) Thread("AutoClaimQuest", SafeLoop("AutoClaimQuest", Func_AutoClaimQuest), v) end)
Toggles.AutoClaimBattlepass:OnChanged(function(v) Thread("AutoClaimBattlepass", SafeLoop("AutoClaimBattlepass", Func_AutoClaimBattlepass), v) end)
Toggles.AutoClaimMilestone:OnChanged(function(v) Thread("AutoClaimMilestone", SafeLoop("AutoClaimMilestone", Func_AutoClaimMilestone), v) end)
Toggles.AutoClaimIndex:OnChanged(function(v) Thread("AutoClaimIndex", SafeLoop("AutoClaimIndex", Func_AutoClaimIndex), v) end)
Toggles.AutoClaimCalendar:OnChanged(function(v) Thread("AutoClaimCalendar", SafeLoop("AutoClaimCalendar", Func_AutoClaimCalendar), v) end)
Toggles.AutoVoteSkip:OnChanged(function(v) Thread("AutoVoteSkip", SafeLoop("AutoVoteSkip", Func_AutoVoteSkip), v) end)
Toggles.AutoRestart:OnChanged(function(v) Thread("AutoRestart", SafeLoop("AutoRestart", Func_AutoRestart), v) end)
Toggles.AutoSkipWave:OnChanged(function(v) if v then Func_AutoSkipWave() end end)
Toggles.AutoVoteStart:OnChanged(function(v) Thread("AutoVoteStart", SafeLoop("AutoVoteStart", Func_AutoVoteStart), v) end)
Toggles.AutoReplay:OnChanged(function(v) Thread("AutoReplay", SafeLoop("AutoReplay", Func_AutoReplay), v) end)
Toggles.AutoNext:OnChanged(function(v) Thread("AutoNext", SafeLoop("AutoNext", Func_AutoNext), v) end)
Toggles.AutoReturnLobby:OnChanged(function(v) Thread("AutoReturnLobby", SafeLoop("AutoReturnLobby", Func_AutoReturnLobby), v) end)
Toggles.TPLobby:OnChanged(function(v) Thread("TPLobby", SafeLoop("TPLobby", Func_TPLobby), v) end)
Toggles.AutoSellFarm:OnChanged(function(v) Thread("AutoSellFarm", SafeLoop("AutoSellFarm", Func_AutoSellFarm), v) end)
Toggles.AutoSellUnit:OnChanged(function(v) Thread("AutoSellUnit", SafeLoop("AutoSellUnit", Func_AutoSellUnit), v) end)
Toggles.AutoCraft:OnChanged(function(v) Thread("AutoCraft", SafeLoop("AutoCraft", Func_AutoCraft), v) end)
Toggles.AutoSummon:OnChanged(function(v) Thread("AutoSummon", SafeLoop("AutoSummon", Func_AutoSummon), v) end)
Toggles.AutoPlay:OnChanged(function(v)
Thread("AutoPlay", SafeLoop("AutoPlay", Func_AutoPlay), v)
if not v then
PCubeReleaseAll()
for _, p in ipairs(workspace:GetChildren()) do
if p.Name == "PCube" and not PCubePool.Active[p] then p:Destroy() end
end
end
end)
Toggles.AutoJoinStory:OnChanged(UpdateAutoJoinerThread)
Toggles.AutoJoinRaid:OnChanged(UpdateAutoJoinerThread)
Toggles.AutoJoinExpedition:OnChanged(UpdateAutoJoinerThread)
Toggles.AutoJoinChallenge:OnChanged(UpdateAutoJoinerThread)
Toggles.WHMatchEnd:OnChanged(function(v) Thread("WHMatchEnd", SafeLoop("WHMatchEnd", Func_WHMatchEnd), v) end)
Toggles.DeleteMap:OnChanged(function(v) Thread("DeleteMap", SafeLoop("DeleteMap", Func_DeleteMap), v) end)
Toggles.DeleteEnemies:OnChanged(function(v) Thread("DeleteEnemies", SafeLoop("DeleteEnemies", Func_DeleteEnemies), v) end)
Toggles.BlackScreen:OnChanged(function(v) Thread("BlackScreen", SafeLoop("BlackScreen", Func_BlackScreen), v) end)
Toggles.HideName:OnChanged(function(v) Func_HideName() end)
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("AutoShowUI", { Text = "Auto Show UI", Default = true })
MenuGroup:AddToggle("KeybindMenuOpen", {
Default  = Library.KeybindFrame.Visible,
Text     = "Open Keybind Menu",
Callback = function(value) Library.KeybindFrame.Visible = value end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
Text     = "Custom Cursor",
Default  = false,
Callback = function(Value) Library.ShowCustomCursor = Value end,
})
MenuGroup:AddDropdown("NotificationSide", {
Values   = { "Left", "Right" },
Default  = "Right",
Text     = "Notification Side",
Callback = function(Value) Library:SetNotifySide(Value) end,
})
MenuGroup:AddDropdown("DPIDropdown", {
Values   = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
Default  = "100%",
Text     = "DPI Scale",
Callback = function(Value)
Value = Value:gsub("%%", "")
Library:SetDPIScale(tonumber(Value))
end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
:AddKeyPicker("MenuKeybind", { Default = "U", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function()
getgenv().ayasemiyatongekissazumirisa = false
Cleanup(Connections)
Cleanup(Flags)
Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/AnimeExpeditions")
local function SerializePositions()
local out = {}
for mapName, slots in pairs(SlotPositions) do
local slotsOut = {}
for slot, list in pairs(slots) do
local arr = {}
for _, cf in ipairs(list) do
table.insert(arr, { X = cf.X, Y = cf.Y, Z = cf.Z })
end
slotsOut[tostring(slot)] = arr
end
out[mapName] = slotsOut
end
return out
end
local function DeserializePositions(data)
local out = {}
if type(data) ~= "table" then return out end
for mapName, slots in pairs(data) do
local slotsOut = {}
for slotKey, arr in pairs(slots) do
local slot = tonumber(slotKey) or slotKey
local list = {}
for _, p in ipairs(arr) do
table.insert(list, CFrame.new(p.X, p.Y, p.Z))
end
slotsOut[slot] = list
end
out[mapName] = slotsOut
end
return out
end
local function GetConfigFilePath(name)
local fullPath = SaveManager.Folder .. '/settings/' .. name .. '.json'
if SaveManager:CheckSubFolder(false) then
fullPath = SaveManager.Folder .. "/settings/" .. SaveManager.SubFolder .. "/" .. name .. '.json'
end
return fullPath
end
local Original_SaveManager_Save   = SaveManager.Save
local Original_SaveManager_Load   = SaveManager.Load
local Original_SaveManager_Delete = SaveManager.Delete
function SaveManager:Save(name)
local ok, err = Original_SaveManager_Save(self, name)
if ok and Support.FileIO then
local path = GetConfigFilePath(name)
if isfile(path) then
local rok, raw = pcall(readfile, path)
if rok then
local dok, data = pcall(HttpService.JSONDecode, HttpService, raw)
if dok and type(data) == "table" then
data.positions = SerializePositions()
local enc_ok, encoded = pcall(HttpService.JSONEncode, HttpService, data)
if enc_ok then
pcall(writefile, path, encoded)
else
notyuri("[AutoPlay] Failed to encode positions into config " .. tostring(name))
end
else
notyuri("[AutoPlay] Failed to decode config for positions inject: " .. tostring(name))
end
else
notyuri("[AutoPlay] Failed to read config file for positions inject: " .. tostring(name))
end
end
end
return ok, err
end
function SaveManager:Load(name)
if Support.FileIO then
local path = GetConfigFilePath(name)
if isfile(path) then
local rok, raw = pcall(readfile, path)
if rok then
local dok, data = pcall(HttpService.JSONDecode, HttpService, raw)
if dok and type(data) == "table" and data.positions ~= nil then
local posData = data.positions
data.positions = nil
local enc_ok, stripped = pcall(HttpService.JSONEncode, HttpService, data)
if enc_ok then
pcall(writefile, path, stripped)
end
local ok, err = Original_SaveManager_Load(self, name)
if ok then
SlotPositions = DeserializePositions(posData)
UpdatePosLabels()
notyuri("[AutoPlay] Loaded positions from config " .. tostring(name))
end
if isfile(path) then
local rok2, raw2 = pcall(readfile, path)
if rok2 then
local dok2, data2 = pcall(HttpService.JSONDecode, HttpService, raw2)
if dok2 and type(data2) == "table" then
data2.positions = posData
local enc_ok2, encoded2 = pcall(HttpService.JSONEncode, HttpService, data2)
if enc_ok2 then pcall(writefile, path, encoded2) end
end
end
end
return ok, err
else
notyuri("[AutoPlay] No positions key in config " .. tostring(name) .. ", loading normally")
end
end
end
end
return Original_SaveManager_Load(self, name)
end
function SaveManager:Delete(name)
return Original_SaveManager_Delete(self, name)
end
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
SaveManager:LoadAutoloadConfig()
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
Library:SetDPIScale(100)
end
Library:Notify("Script Loaded.", 2)
Library:Notify("Yuri!", 5)
end)
if not eh_success then
Library:Notify("ERROR: " .. tostring(err), 4)
notyuri("ERROR: " .. tostring(err))
end
elseif game.GameId == 3913007563 then
print("a")
if getgenv().ayasemiyatongekissazumirisa then
warn("yuri")
return
end
print("b")
function missing(t, f, fallback)
if type(f) == t then return f end
return fallback
end
cloneref = missing("function", cloneref, function(...) return ... end)
getgc = missing("function", getgc or get_gc_objects)
getconnections = missing("function", getconnections or get_signal_cons)
print("c")
Services = setmetatable({}, {
__index = function(self, name)
local success, cache = pcall(function()
return cloneref(game:GetService(name))
end)
if success then
rawset(self, name, cache)
return cache
else
error("Invalid Service: " .. tostring(name))
end
end
})
print("d")
local Players = Services.Players
local Plr = Players.LocalPlayer
local Char = Plr.Character
local PGui = Plr.PlayerGui
local PlayerData = Plr.PlayerData
print("e")
local Lighting = game:GetService('Lighting');
local RS = Services.ReplicatedStorage
local RunService = Services.RunService
local HttpService = Services.HttpService
local GuiService = Services.GuiService
local TeleportService = Services.TeleportService
local Marketplace = Services.MarketplaceService
local UIS = Services.UserInputService
local VirtualUser = Services.VirtualUser
local v, Asset = pcall(function()
return Marketplace:GetProductInfo(game.PlaceId)
end)
local assetName = "game name"
if v and Asset then
assetName = Asset.Name
end
local Support = {
Webhook = (typeof(request) == "function" or typeof(http_request) == "function"),
Clipboard = (typeof(setclipboard) == "function"),
FileIO = (typeof(writefile) == "function" and typeof(isfile) == "function"),
QueueOnTeleport = (typeof(queue_on_teleport) == "function"),
Connections = (typeof(getconnections) == "function"),
FPS = (typeof(setfpscap) == "function"),
Proximity = (typeof(fireproximityprompt) == "function"),
}
local executorName = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local LimitedExecutors = {"xeno", "solara",}
local isLimitedExecutor = false
for _, name in ipairs(LimitedExecutors) do
if string.find(executorName, name) then
isLimitedExecutor = true
break
end
end
local function notyuri()
end
print("f")
local repo = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
print("g")
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
print("h")
getgenv().ayasemiyatongekissazumirisa = true
print("i")
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true 
Library.ShowCustomCursor = true 
Library.NotifySide = "Left"
local function AddInfo(Window)
local InfoTab = Window:AddTab("Info")
local InfoLeft = InfoTab:AddLeftGroupbox("Information")
local statusText = isLimitedExecutor and "<font color='#FFA500'>Semi-Working</font>" or "<font color='#00FF00'>Working</font>"
local extraNote = isLimitedExecutor
and "<b>NOTE:</b> May experiencing bugs for some features!"
or "All features should works properly!"
InfoLeft:AddLabel("<b>Executor:</b> " .. executorDisplayName .. "\n<b>Status:</b> " .. statusText .. "\n" .. extraNote, true)
local InfoRight = InfoTab:AddRightGroupbox("Others")
InfoRight:AddButton({
Text = "Join Discord Server",
Func = function()
local inviteCode = "q8QX76jyz"
local inviteLink = "https://discord.gg/" .. inviteCode
local success = false
if request then
success = pcall(function()
request({
Url = "http://127.0.0.1:6463/rpc?v=1",
Method = "POST",
Headers = {
["Content-Type"] = "application/json",
["Origin"] = "https://discord.com"
},
Body = HttpService:JSONEncode({
cmd = "INVITE_BROWSER",
args = { code = inviteCode },
nonce = HttpService:GenerateGUID(false)
})
})
end)
end
if not success and setclipboard then
setclipboard(inviteLink)
end
end,
})
end
local eh_success, err = pcall(function()
print("x")
local Script_Start_Time = os.time()
local function GetSessionTime()
local seconds = os.time() - Script_Start_Time
local hours = math.floor(seconds / 3600)
local mins = math.floor((seconds % 3600) / 60)
return string.format("%dh %02dm", hours, mins)
end
local function GetObject(parent, pathString)
local current = parent
for _, name in ipairs(pathString:split(".")) do
if not current then return nil end
current = current:FindFirstChild(name)
end
return current
end
local function GetSafeModule(parent, name)
local obj = parent:FindFirstChild(name)
if obj and obj:IsA("ModuleScript") then
local success, result = pcall(require, obj)
if success then return result end
end
return nil
end
local function SafeConnect(key, getSignalFn, handler)
local ok, signal = pcall(getSignalFn)
if not ok or not signal then
return
end
Connections[key] = signal:Connect(handler)
end
local function SafeInvoke(remote, ...)
local args = {...}
local result = nil
task.spawn(function()
local success, res = pcall(function()
return remote:InvokeServer(unpack(args))
end)
result = res
end)
local start = tick()
repeat task.wait() until result ~= nil or (tick() - start) > 2 
return result
end
local function fire_event(signal, ...)
if firesignal then
return firesignal(signal, ...)
elseif getconnections then
for _, connection in ipairs(getconnections(signal)) do
if connection.Function then
task.spawn(connection.Function, ...)
end
end
else
warn("Your executor does not support firesignal or getconnections.")
end
end
local Remotes = {
Events = RS.Events,
RemoteEvents = RS.Events.RemoteEvents,
RemoteFunction = RS.Events.RemoteFunction,
PlayerSpawn = RS.Events.RemoteFunction.PlayerSpawn,
StartBattle = RS.Events.RemoteFunction.StartBattle,
BattleInfo = RS.Events.RemoteEvents.BattleInfo,
WinOrLose = RS.Events.RemoteEvents.WinOrLose,
GiveUp = RS.Events.RemoteEvents.GiveUp,
}
local Modules = {
GameValues = require(RS.Modules.GameValues),
}
local Flags = {}
local Shared = {
Farm = false,
}
local Tables = {
}
local MDir = "Yuri/TBB/Macros"
local MState = {
Rec          = false,
Rep          = false,
Cur          = nil,
Load         = nil,
Hooked       = false,
Step         = 0,
Total        = 0,
LabelRef     = nil,
PendingLabel = nil,
StartRelay   = false,
}
local StageSwitch = {
Active      = false,
ReplayCount = 0,
OrigChapter = nil,
OrigStage   = nil,
OrigDiff    = nil,
OrigStars   = nil,
OrigLimit   = nil,
OrigDXP     = nil,
OrigMult    = nil,
}
local Connections = {
Player_General = nil,
Knockback = {},
Reconnect = nil,
Macro = {},
AutoReplay = nil,
}
local function Cleanup(tbl)
for key, value in pairs(tbl) do
if typeof(value) == "RBXScriptConnection" then
value:Disconnect()
tbl[key] = nil
elseif typeof(value) == 'thread' then
task.cancel(value)
tbl[key] = nil
elseif type(value) == 'table' then
Cleanup(value)
end
end
end
function Thread(featurePath, featureFunc, isEnabled, ...)
local pathParts = featurePath:split(".")
local currentTable = Flags 
for i = 1, #pathParts - 1 do
local part = pathParts[i]
if not currentTable[part] then currentTable[part] = {} end
currentTable = currentTable[part]
end
local flagKey = pathParts[#pathParts]
local activeThread = currentTable[flagKey]
if isEnabled then
if not activeThread or coroutine.status(activeThread) == "dead" then
local newThread = task.spawn(featureFunc, ...)
currentTable[flagKey] = newThread
end
else
if activeThread and typeof(activeThread) == 'thread' then
task.cancel(activeThread)
currentTable[flagKey] = nil
end
end
end
local function SafeLoop(name, func)
return function()
local success, err = pcall(func)
if not success then
Library:Notify("Error in ["..name.."]: "..tostring(err), 10)
warn("Error in ["..name.."]: "..tostring(err))
end
end
end
local function CommaFormat(n)
local s = tostring(n)
return s:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end
local function Abbreviate(n)
local abbrev = {{1e12, "T"}, {1e9, "B"}, {1e6, "M"}, {1e3, "K"}}
for _, v in ipairs(abbrev) do
if n >= v[1] then return string.format("%.1f%s", n / v[1], v[2]) end
end
return tostring(n)
end
function AddSliderToggle(Config)
local Toggle = Config.Group:AddToggle(Config.Id, {
Text = Config.Text,
Default = Config.DefaultToggle or false
})
local Slider = Config.Group:AddSlider(Config.Id .. "Value", {
Text = Config.Text,
Default = Config.Default,
Min = Config.Min,
Max = Config.Max,
Rounding = Config.Rounding or 0,
Compact = true,
Visible = false
})
Toggle:OnChanged(function()
Slider:SetVisible(Toggle.Value)
end)
return Toggle, Slider
end
local function GetCharacter()
local c = Plr.Character
return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
end
local function FuncTPW()
while true do
local delta = RunService.Heartbeat:Wait()
local char = GetCharacter()
local hum = char and char:FindFirstChildOfClass("Humanoid")
if char and hum and hum.Health > 0 then
if hum.MoveDirection.Magnitude > 0 then
local speed = Options.TPWValue.Value
char:TranslateBy(hum.MoveDirection * speed * delta * 10)
end
end
end
end
local function FuncNoclip()
while Toggles.Noclip.Value do
RunService.Stepped:Wait()
local char = GetCharacter()
if char then
for _, part in pairs(char:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then
part.CanCollide = false
end
end
end
end
end
local function Func_AntiKnockback()
if type(Connections.Knockback) == "table" then
for _, conn in pairs(Connections.Knockback) do
if conn then conn:Disconnect() end
end
table.clear(Connections.Knockback)
else
Connections.Knockback = {}
end
local function ApplyAntiKB(character)
if not character then return end
local root = character:WaitForChild("HumanoidRootPart", 10)
if root then
local conn = root.ChildAdded:Connect(function(child)
if not Toggles.AntiKnockback.Value then return end
if child:IsA("BodyVelocity") and child.MaxForce == Vector3.new(40000, 40000, 40000) then
child:Destroy()
end
end)
table.insert(Connections.Knockback, conn)
end
end
if Plr.Character then
ApplyAntiKB(Plr.Character)
end
local charAddedConn = Plr.CharacterAdded:Connect(function(newChar)
ApplyAntiKB(newChar)
end)
table.insert(Connections.Knockback, charAddedConn)
repeat task.wait(1) until not Toggles.AntiKnockback.Value
for _, conn in pairs(Connections.Knockback) do
if conn then conn:Disconnect() end
end
table.clear(Connections.Knockback)
end
local function Func_AutoReconnect()
if Connections.Reconnect then Connections.Reconnect:Disconnect() end
Connections.Reconnect = GuiService.ErrorMessageChanged:Connect(function()
if not Toggles.AutoReconnect.Value then return end
task.delay(2, function()
pcall(function()
local promptOverlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
if promptOverlay then
local errorPrompt = promptOverlay.promptOverlay:FindFirstChild("ErrorPrompt")
if errorPrompt and errorPrompt.Visible then
local secondaryTimer = 5
task.wait(secondaryTimer)
TeleportService:Teleport(game.PlaceId, Plr)
end
end
end)
end)
end)
end
local function Func_NoGameplayPaused()
while Toggles.NoGameplayPaused.Value do
local success, err = pcall(function()
local pauseGui = game:GetService("CoreGui").RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
if pauseGui then
pauseGui:Destroy()
end
end)
task.wait(1)
end
end
local function GetElapsedBattleTime()
local startTime = workspace:GetAttribute("StartTime")
if not startTime then return nil end
return (DateTime.now().UnixTimestampMillis / 1000) - startTime
end
local function LoadMDir()
if not writefile then return end
pcall(function()
local built = ""
for _, part in ipairs(MDir:split("/")) do
built = (built == "") and part or (built .. "/" .. part)
if not isfolder(built) then
makefolder(built)
end
end
end)
end
LoadMDir()
local function ListMacros()
local names = {}
if not listfiles then return names end
local ok, files = pcall(listfiles, MDir)
if not ok or type(files) ~= "table" then return names end
for _, path in ipairs(files) do
if type(path) == "string" and path:sub(-5):lower() == ".json" then
local fname = path:match("([^/\\]+)%.json$")
if fname and fname ~= "" then table.insert(names, fname) end
end
end
table.sort(names)
return names
end
local function LoadMacro(name)
if not name or name == "" or not readfile then return nil end
local path = MDir .. "/" .. name .. ".json"
if not isfile(path) then return nil end
local ok, raw = pcall(readfile, path)
if not ok or type(raw) ~= "string" or raw == "" then return nil end
local data
pcall(function() data = HttpService:JSONDecode(raw) end)
if type(data) ~= "table" then return nil end
local entries = {}
local i = 1
while data[tostring(i)] do
entries[i] = data[tostring(i)]
i = i + 1
end
return { entries = entries }
end
local function SaveMacro(name, macro)
if not name or name == "" or not writefile then return false end
LoadMDir()
local path = MDir .. "/" .. name .. ".json"
local out = {}
for i, entry in ipairs(macro.entries) do
out[tostring(i)] = entry
end
local ok = pcall(function()
writefile(path, HttpService:JSONEncode(out))
end)
return ok
end
local function UpdateLabel(suffix, elapsed)
if MState.LabelRef and MState.LabelRef.SetText then
local txt
local timeStr = elapsed and string.format(" [%.2fs]", elapsed) or ""
if MState.Rec then
if suffix then
txt = string.format("Recording [%d] %s%s", MState.Step, suffix, timeStr)
else
txt = string.format("Recording [%d]", MState.Step)
end
elseif MState.Rep then
txt = string.format("Replaying [%d / %d]", MState.Step, MState.Total)
if suffix then txt = txt .. " | " .. suffix .. timeStr end
else
txt = "Idle"
if suffix then txt = txt .. " | " .. suffix end
end
notyuri("[Macro Rec] UpdateLabel called, txt=", txt, "LabelRef exists=", MState.LabelRef ~= nil)
if MState.Rec then
MState.PendingLabel = txt
else
local ok, err = pcall(function() MState.LabelRef:SetText(txt) end)
if not ok then
notyuri("[Macro Rec] SetText FAILED:", tostring(err))
MState.PendingLabel = txt
end
end
end
end
local function LabelPump()
while MState.Rec do
if MState.PendingLabel then
local txt = MState.PendingLabel
MState.PendingLabel = nil
local ok, err = pcall(function() MState.LabelRef:SetText(txt) end)
if not ok then
notyuri("[Macro Rec] LabelPump SetText FAILED:", tostring(err))
end
end
task.wait()
end
end
local function HandleRecordedAction(kind, slotName, capturedElapsed)
if not MState.Rec or not MState.Cur then return end
local elapsed = capturedElapsed
if not elapsed then return end
MState.Step = MState.Step + 1
table.insert(MState.Cur.entries, {
Type = kind,
Slot = slotName,
Elapsed = elapsed,
})
UpdateLabel(kind, elapsed)
notyuri("[Macro Rec] recorded", kind, slotName or "", string.format("%.2f", elapsed))
end
local function InstallMacroHook()
if MState.Hooked then return end
local originalNamecall
originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
local self = ...
local Method = getnamecallmethod()
local ret = table.pack(originalNamecall(...))
if MState.Rec and Method == "InvokeServer" and rawequal(self, Remotes.PlayerSpawn) then
local arg2 = select(2, ...)
local capturedElapsed = GetElapsedBattleTime()
local success = ret[1] ~= nil
task.defer(function()
if not success then
notyuri("[Macro Rec] skip record - InvokeServer returned nil (failure)", tostring(arg2))
return
end
if type(arg2) == "string" then
if arg2 == "Bank" then
HandleRecordedAction("Bank", nil, capturedElapsed)
elseif arg2 == "Cannon" then
HandleRecordedAction("Cannon", nil, capturedElapsed)
elseif arg2:match("^Slot%d$") then
HandleRecordedAction("Unit", arg2, capturedElapsed)
end
end
end)
end
return table.unpack(ret, 1, ret.n)
end))
MState.Hooked = true
notyuri("[Macro] __namecall hook installed")
end
local function Func_MacroRecord(state)
if not state then return end
if Toggles.LoadMacro and Toggles.LoadMacro.Value then
Toggles.LoadMacro:SetValue(false)
end
InstallMacroHook()
MState.Cur = { entries = {} }
MState.Step = 0
UpdateLabel("Waiting")
notyuri("[Macro Rec] waiting for StartTime change")
MState.StartRelay = false
while Toggles.MacroRecord.Value and not MState.StartRelay do
task.wait()
end
if not Toggles.MacroRecord.Value then
MState.Cur = nil
MState.Step = 0
UpdateLabel()
return
end
MState.StartRelay = false
MState.Rec = true
UpdateLabel()
task.spawn(LabelPump)
notyuri("[Macro Rec] recording started")
while Toggles.MacroRecord.Value do
task.wait()
end
MState.Rec = false
notyuri("[Macro Rec] recording stopped,", #MState.Cur.entries, "actions")
local fname = (Options.FileName and Options.FileName.Value) or ""
if fname == "" then fname = "Macro_" .. os.date("%Y%m%d_%H%M%S") end
if SaveMacro(fname, MState.Cur) then
Library:Notify("Macro saved:" .. fname, 4)
if Options.MacroSelected then
Options.MacroSelected:SetValues(ListMacros())
end
else
Library:Notify("Failed to save macro (writefile unsupported?)", 4)
end
MState.Cur = nil
MState.Step = 0
UpdateLabel()
end
local function GetActiveSpawnMenu()
local battleGui = PGui:FindFirstChild("BattleScreen")
if not battleGui then return nil end
local settings = PlayerData and PlayerData:FindFirstChild("Settings")
local unitSwitch = settings and settings:FindFirstChild("UnitSwitch")
if unitSwitch and unitSwitch.Value == false then
return battleGui:FindFirstChild("MobileSpawnMenu") or battleGui:FindFirstChild("SpawnMenu")
end
return battleGui:FindFirstChild("SpawnMenu") or battleGui:FindFirstChild("MobileSpawnMenu")
end
local function DoMacroAction(entry)
if entry.Type == "Unit" then
local spawnMenu = GetActiveSpawnMenu()
local slotBtn = spawnMenu and spawnMenu:FindFirstChild(entry.Slot, true)
if slotBtn and slotBtn.Active == false then
notyuri("[Macro Rep] skip", entry.Slot, "- not active")
return
end
Remotes.PlayerSpawn:InvokeServer(entry.Slot)
elseif entry.Type == "Bank" then
Remotes.PlayerSpawn:InvokeServer("Bank")
elseif entry.Type == "Cannon" then
Remotes.PlayerSpawn:InvokeServer("Cannon", {
CameraPosition = workspace.CurrentCamera.CFrame.Position
})
end
end
local function Func_MacroReplay()
local macro = MState.Load
if not macro or not macro.entries or #macro.entries == 0 then
Toggles.LoadMacro:SetValue(false)
Library:Notify("No macro loaded", 3)
return
end
MState.Rep = true
MState.Total = #macro.entries
MState.Step = 0
UpdateLabel()
while Toggles.LoadMacro.Value do
if StageSwitch.Active then
task.wait()
elseif not Modules.GameValues.InStage then
task.wait()
else
local battleGui = PGui:FindFirstChild("BattleScreen")
if not battleGui then
task.wait()
else
if not MState.StartRelay then
UpdateLabel("Waiting")
while Toggles.LoadMacro.Value and Modules.GameValues.InStage and PGui:FindFirstChild("BattleScreen") and not MState.StartRelay and not StageSwitch.Active do
task.wait()
end
end
local started = MState.StartRelay
and Toggles.LoadMacro.Value
and Modules.GameValues.InStage
and PGui:FindFirstChild("BattleScreen") ~= nil
and not StageSwitch.Active
if started then
MState.StartRelay = false
notyuri("[Macro Rep] relay consumed, starting replay")
for i, entry in ipairs(macro.entries) do
if not Toggles.LoadMacro.Value then break end
if not Modules.GameValues.InStage or not PGui:FindFirstChild("BattleScreen") or StageSwitch.Active then
break
end
MState.Step = i
UpdateLabel(entry.Type, entry.Elapsed)
while Toggles.LoadMacro.Value do
if StageSwitch.Active then break end
local elapsed = GetElapsedBattleTime()
if elapsed and elapsed >= entry.Elapsed then break end
task.wait()
end
if Toggles.LoadMacro.Value and not StageSwitch.Active then
local ok, err = pcall(DoMacroAction, entry)
if not ok then
notyuri("[Macro Rep] action failed:", tostring(err))
end
end
end
UpdateLabel("Finished")
notyuri("[Macro Rep] pass complete, waiting for next stage")
end
while Toggles.LoadMacro.Value and Modules.GameValues.InStage and PGui:FindFirstChild("BattleScreen") and not StageSwitch.Active do
task.wait()
end
end
end
end
MState.Rep = false
MState.Step = 0
UpdateLabel()
end
local function Func_AutoReplay()
Connections.AutoReplay = Remotes.WinOrLose.OnClientEvent:Connect(function(won)
if not Toggles.AutoReplay.Value then return end
if StageSwitch.Active then
notyuri("[AutoReplay] WinOrLose fired during stage switch, won=", tostring(won), "- reverting to original stage")
StageSwitch.Active = false
task.defer(function()
local ok, result = pcall(function()
return Remotes.StartBattle:InvokeServer(
StageSwitch.OrigChapter,
StageSwitch.OrigStage,
StageSwitch.OrigDiff,
StageSwitch.OrigStars,
false,
StageSwitch.OrigLimit,
StageSwitch.OrigDXP,
StageSwitch.OrigMult
)
end)
if not ok then
notyuri("[AutoReplay] Revert StartBattle invoke failed:", tostring(result))
elseif not result then
notyuri("[AutoReplay] Revert StartBattle returned falsy (rejected)")
else
notyuri("[AutoReplay] Revert StartBattle accepted")
end
end)
return
end
notyuri("[AutoReplay] WinOrLose fired, won=", tostring(won), "- restarting battle")
if Toggles.SwitchStageWhen and Toggles.SwitchStageWhen.Value then
StageSwitch.ReplayCount = StageSwitch.ReplayCount + 1
local threshold = tonumber(Options.SwitchStageEvery and Options.SwitchStageEvery.Value) or 0
if threshold > 0 and StageSwitch.ReplayCount >= threshold then
notyuri("[AutoReplay] Switch-stage threshold reached (", StageSwitch.ReplayCount, "/", threshold, ") - switching stage")
StageSwitch.ReplayCount = 0
StageSwitch.OrigChapter = Modules.GameValues.Chapter
StageSwitch.OrigStage   = Modules.GameValues.Stage
StageSwitch.OrigDiff    = Modules.GameValues.Difficulty
StageSwitch.OrigStars   = Modules.GameValues.Stars
StageSwitch.OrigLimit   = Modules.GameValues.LevelLimit
StageSwitch.OrigDXP     = Modules.GameValues.EnableDoubleXP
StageSwitch.OrigMult    = Modules.GameValues.EnemyMultiplier
StageSwitch.Active = true
task.defer(function()
local ok, result = pcall(function()
return Remotes.StartBattle:InvokeServer(
"Chapter1", 1, 2, 1, false, {}, false, 1
)
end)
if not ok then
notyuri("[AutoReplay] Switch StartBattle invoke failed:", tostring(result))
StageSwitch.Active = false
return
elseif not result then
notyuri("[AutoReplay] Switch StartBattle returned falsy (rejected)")
StageSwitch.Active = false
return
else
notyuri("[AutoReplay] Switch StartBattle accepted")
end
task.defer(function()
Remotes.GiveUp:FireServer()
notyuri("[AutoReplay] GiveUp fired for switch stage")
end)
end)
return
end
end
task.defer(function()
local ok, result = pcall(function()
return Remotes.StartBattle:InvokeServer(
Modules.GameValues.Chapter,
Modules.GameValues.Stage,
Modules.GameValues.Difficulty,
Modules.GameValues.Stars,
false,
Modules.GameValues.LevelLimit,
Modules.GameValues.EnableDoubleXP,
Modules.GameValues.EnemyMultiplier
)
end)
if not ok then
notyuri("[AutoReplay] StartBattle invoke failed:", tostring(result))
elseif not result then
notyuri("[AutoReplay] StartBattle returned falsy (rejected)")
else
notyuri("[AutoReplay] StartBattle accepted")
end
end)
end)
end
local function GetSelectedSlots()
local slots = {}
local values = Options.AutoSpawnSlots and Options.AutoSpawnSlots.Value
if type(values) == "table" then
for slotName, isSelected in pairs(values) do
if isSelected then table.insert(slots, slotName) end
end
end
return slots
end
local function Func_AutoSpawn()
while Toggles.AutoSpawn.Value do
local slots = GetSelectedSlots()
if #slots == 0 then
task.wait()
else
local spawnMenu = GetActiveSpawnMenu()
if not spawnMenu then
task.wait()
else
for _, slotName in ipairs(slots) do
if not Toggles.AutoSpawn.Value then break end
local slotBtn = spawnMenu:FindFirstChild(slotName, true)
if slotBtn and slotBtn.Active == true then
Remotes.PlayerSpawn:InvokeServer(slotName)
end
end
task.wait()
end
end
end
end
local function Func_SpamAll()
while Toggles.SpamAll.Value do
local elapsed = GetElapsedBattleTime()
local threshold = tonumber(Options.SpamThreshold.Value) or 0
if elapsed and elapsed >= threshold then
local spawnMenu = GetActiveSpawnMenu()
if not spawnMenu then
task.wait()
else
for i = 1, 8 do
if not Toggles.SpamAll.Value then break end
local slotName = "Slot" .. i
local slotBtn = spawnMenu:FindFirstChild(slotName, true)
if slotBtn and slotBtn.Active == true then
Remotes.PlayerSpawn:InvokeServer(slotName)
end
end
task.wait()
end
else
task.wait()
end
end
end
local function Func_AutoCannon()
while Toggles.AutoCannon.Value do
local spawnMenu = GetActiveSpawnMenu()
if spawnMenu then
local cannonBtn = spawnMenu:FindFirstChild("Cannon", true)
if cannonBtn and cannonBtn.Active == true then
Remotes.PlayerSpawn:InvokeServer("Cannon", {
CameraPosition = workspace.CurrentCamera.CFrame.Position
})
end
end
task.wait()
end
end
local function ApplyFPSBoost(state)
if not state then return end
pcall(function()
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 1
for _, v in pairs(Lighting:GetChildren()) do
if v:IsA("PostProcessEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
v.Enabled = false
end
end
task.spawn(function()
for i, v in pairs(workspace:GetDescendants()) do
if Toggles.FPSBoost and not Toggles.FPSBoost.Value then break end
pcall(function()
if v:IsA("BasePart") then
v.Material = Enum.Material.SmoothPlastic
v.CastShadow = false
elseif v:IsA("Decal") or v:IsA("Texture") then
v:Destroy()
elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
v.Enabled = false
end
end)
if i % 500 == 0 then task.wait() end
end
end)
end)
end
function gsc(guiObject)
if not guiObject then return false end
local success = false
pcall(function()
if Services.GuiService and Services.VirtualInputManager then
Services.GuiService.SelectedObject = guiObject
task.wait(0.05)
local keys = {Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter, Enum.KeyCode.ButtonA}
for _, key in ipairs(keys) do
Services.VirtualInputManager:SendKeyEvent(true, key, false, game); task.wait(0.03)
Services.VirtualInputManager:SendKeyEvent(false, key, false, game); task.wait(0.03)
end
Services.GuiService.SelectedObject = nil
success = true
end
end)
return success
end
local function FireCD(target)
if not fireclickdetector then
return
end
if not target or not target:IsA("ClickDetector") then
return
end
fireclickdetector(target)
end
local function FirePP(target, teleport)
if not fireproximityprompt then return end
if not target or not target:IsA("ProximityPrompt") then return end
local prevDist = target.MaxActivationDistance
if teleport then
local char = GetCharacter()
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local part = target.Parent
local isModel = false
if part then
if part:IsA("Model") then
isModel = true
elseif not part:IsA("BasePart") then
part = target:FindFirstAncestorWhichIsA("BasePart")
if not part then
part = target:FindFirstAncestorWhichIsA("Model")
if part then
isModel = true
end
end
end
end
if hrp and part then
local partPos = isModel and part:GetPivot().Position or part.Position
local dist = (hrp.Position - partPos).Magnitude
if dist > prevDist then
local partCFrame = isModel and part:GetPivot() or part.CFrame
hrp.CFrame = partCFrame * CFrame.new(0, 3, 0)
task.wait(0.175)
end
end
end
fireproximityprompt(target)
end
local function FireTI(target)
if not firetouchinterest then
return
end
local root = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
if not root then
return
end
local part
if target:IsA("BasePart") then
part = target
else
part = target:FindFirstAncestorWhichIsA("BasePart")
end
if not part then
return
end
task.spawn(function()
firetouchinterest(part, root, 1)
task.wait()
firetouchinterest(part, root, 0)
end)
end
local Window = Library:CreateWindow({
Title = "Yuri",
Center = true,
AutoShow = true,
Resizable = true,
ShowCustomCursor = false,
UnlockMouseWhileOpen = false,
NotifySide = "Left",
TabPadding = 8,
MenuFadeTime = 0.2
})
print("y")
AddInfo(Window)
local Tabs = {
Main = Window:AddTab("Main"),
Player = Window:AddTab("Player"),
Config = Window:AddTab("Config"),
}
local TB = {
Main = {
Left = {
Autofarm = Tabs.Main:AddLeftTabbox(),
},
Right = {
Autofarm = Tabs.Main:AddRightTabbox(),
},
},
}
local TB_Tabs = {
Autofarm = {
T1 = TB.Main.Left.Autofarm:AddTab("Macro"),
T2 = TB.Main.Left.Autofarm:AddTab("AutoPlay"),
},
Autofarm2 = {
T1 = TB.Main.Right.Autofarm:AddTab("Config"),
},
}
TB_Tabs.Autofarm.T1:AddInput("FileName", {
Text = "File Name",
Default = "",
Placeholder = "yuriyuri",
})
TB_Tabs.Autofarm.T1:AddToggle("MacroRecord", { Text = "Record Macro" })
TB_Tabs.Autofarm.T1:AddDivider()
TB_Tabs.Autofarm.T1:AddDropdown("MacroSelected", {
Values = ListMacros(),
Default = ListMacros()[1] or "",
Text = "Macro List",
})
TB_Tabs.Autofarm.T1:AddToggle("LoadMacro", { Text = "Load Macro" })
MState.LabelRef = TB_Tabs.Autofarm.T1:AddLabel("Idle", true)
TB_Tabs.Autofarm.T2:AddToggle("AutoReplay", { Text = "Auto Replay" })
TB_Tabs.Autofarm.T2:AddToggle("SwitchStageWhen", { Text = "Switch Stage" })
TB_Tabs.Autofarm.T2:AddInput("SwitchStageEvery", {
Default = "3",
Text = "Switch Every n Replays",
})
TB_Tabs.Autofarm.T2:AddDivider()
TB_Tabs.Autofarm.T2:AddDropdown("AutoSpawnSlots", {
Text = "Select Slot(s)",
Values = { "Slot1", "Slot2", "Slot3", "Slot4", "Slot5", "Slot6", "Slot7", "Slot8" },
Default = {},
Multi = true,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoSpawn", { Text = "Auto Spawn" })
TB_Tabs.Autofarm.T2:AddInput("SpamThreshold", {
Default = "0",
Text = "Spam When(s)",
})
TB_Tabs.Autofarm.T2:AddToggle("SpamAll", { Text = "Spam All" })
TB_Tabs.Autofarm.T2:AddToggle("AutoCannon", { Text = "Auto Cannon" })
local GB = {
Player = {
Left = {
General = Tabs.Player:AddLeftGroupbox("General"),
Server  = Tabs.Player:AddLeftGroupbox("Server"),
},
Right = {
Game = Tabs.Player:AddRightGroupbox("Game"),
},
},
}
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 250 })
local TPW_T, TPW_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "JP", Text = "JumpPower", Default = 50, Min = 0, Max = 500 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "HH", Text = "HipHeight", Default = 2, Min = 0, Max = 10, Rounding = 1 })
GB.Player.Left.General:AddToggle("Noclip", { Text = "Noclip" })
GB.Player.Left.General:AddToggle("AntiKnockback", {
Text = "Anti Knockback",
Default = false,
})
GB.Player.Left.General:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering" })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1})
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
local FPS_T, FPS_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
GB.Player.Left.General:AddToggle("FPSBoost", { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK", {
Text = "Anti AFK",
Default = true,
Disabled = not Support.Connections,
})
GB.Player.Left.Server:AddToggle("AntiKick", { Text = "Anti Kick (Client)" })
GB.Player.Left.Server:AddToggle("AutoReconnect", { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused"})
GB.Player.Left.Server:AddButton({ Text = "Serverhop", Func = function()
local Servers = game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100')
end})
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function() Services.TeleportService:Teleport(game.PlaceId, Plr) end })
GB.Player.Left.Server:AddToggle("AutoServerhop", { Text = "Auto Serverhop" })
GB.Player.Left.Server:AddSlider("AutoHopMins", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
GB.Player.Right.Game:AddToggle("InstantPP", { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog", { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
Toggles.AntiKnockback:OnChanged(function(state)
Thread("AntiKnockback", Func_AntiKnockback, state)
end)
Toggles.TPW:OnChanged(function(v)
TPW_S:SetVisible(TPW_T.Value)
Thread("TPW", FuncTPW, v)
end)
Toggles.Noclip:OnChanged(function(v)
Thread("Noclip", FuncNoclip, v)
end)
Connections.Player_General = RunService.Stepped:Connect(function()
local Hum = Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")
if Hum then
if Toggles.WS.Value then Hum.WalkSpeed = Options.WSValue.Value end
if Toggles.JP.Value then Hum.JumpPower = Options.JPValue.Value Hum.UseJumpPower = true end
if Toggles.HH.Value then Hum.HipHeight = Options.HHValue.Value end
end
workspace.Gravity = Toggles.Grav.Value and Options.GravValue.Value or 192
if Toggles.FOV.Value then workspace.CurrentCamera.FieldOfView = Options.FOVValue.Value end
if Toggles.Zoom.Value then Plr.CameraMaxZoomDistance = Options.ZoomValue.Value end
end)
task.spawn(function()
while task.wait() do
if Toggles.Fullbright.Value then
Lighting.Brightness = 2
Lighting.ClockTime = 14
Lighting.GlobalShadows = false
elseif Toggles.OverrideTime.Value then
Lighting.ClockTime = Options.OverrideTimeValue.Value
end
if Toggles.NoFog.Value then Lighting.FogEnd = 9e9 end
if Library.Unloaded then break end
end
end)
workspace:GetAttributeChangedSignal("StartTime"):Connect(function()
MState.StartRelay = true
notyuri("[Macro Rep] StartTime changed, relay armed")
end)
Options.LimitFPSValue:OnChanged(function()
if FPS_T.Value then
setfpscap(FPS_S.Value)
end
end)
Toggles.LimitFPS:OnChanged(function(v)
FPS_S:SetVisible(FPS_T.Value)
if not v then
setfpscap(999)
end
end)
Toggles.Disable3DRender:OnChanged(function(v) RunService:Set3dRenderingEnabled(not v) end)
Toggles.FPSBoost:OnChanged(function(state)
ApplyFPSBoost(state)
end)
Toggles.AutoReconnect:OnChanged(function(state)
if state then Func_AutoReconnect() end
end)
Toggles.NoGameplayPaused:OnChanged(function(state)
Thread("NoGameplayPaused", SafeLoop("Anti-Pause", Func_NoGameplayPaused), state)
end)
Toggles.MacroRecord:OnChanged(function(state)
Func_MacroRecord(state)
end)
Options.MacroSelected:OnChanged(function(v)
MState.Load = LoadMacro(v)
if MState.Load then
notyuri("[Macro Rep] loaded", v, "-", #MState.Load.entries, "actions")
end
end)
Toggles.LoadMacro:OnChanged(function(state)
if state then
MState.Load = LoadMacro(Options.MacroSelected.Value)
if not MState.Load then
Library:Notify("Select a valid macro first", 3)
Toggles.LoadMacro:SetValue(false)
return
end
end
Thread("LoadMacro", SafeLoop("Macro Replay", Func_MacroReplay), state)
end)
Toggles.AutoReplay:OnChanged(function(state)
if state then
if not Connections.AutoReplay then
Func_AutoReplay()
end
else
if Connections.AutoReplay then
Connections.AutoReplay:Disconnect()
Connections.AutoReplay = nil
end
end
end)
Toggles.AutoSpawn:OnChanged(function(state)
Thread("AutoSpawn", SafeLoop("Auto Spawn", Func_AutoSpawn), state)
end)
Toggles.SpamAll:OnChanged(function(state)
Thread("SpamAll", SafeLoop("Spam All", Func_SpamAll), state)
end)
Toggles.AutoCannon:OnChanged(function(state)
Thread("AutoCannon", SafeLoop("Auto Cannon", Func_AutoCannon), state)
end)
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
if Toggles.InstantPP and Toggles.InstantPP.Value then
prompt.HoldDuration = 0
end
end)
local function RunAntiAFK()
local GC = getconnections or get_signal_cons
if GC then
for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
if v["Disable"] then
v["Disable"](v)
elseif v["Disconnect"] then
v["Disconnect"](v)
end
end
else
local VirtualUser = cloneref(game:GetService("VirtualUser"))
Players.LocalPlayer.Idled:Connect(function()
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end)
end
end
Toggles.AntiAFK:OnChanged(function(state)
if state then RunAntiAFK() end
end)
if Toggles.AntiAFK.Value then RunAntiAFK() end
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("AutoShowUI", {
Text = "Auto Show UI",
Default = true,
})
MenuGroup:AddToggle("KeybindMenuOpen", {
Default = Library.KeybindFrame.Visible,
Text = "Open Keybind Menu",
Callback = function(value)
Library.KeybindFrame.Visible = value
end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
Text = "Custom Cursor",
Default = false,
Callback = function(Value)
Library.ShowCustomCursor = Value
end,
})
MenuGroup:AddDropdown("NotificationSide", {
Values = { "Left", "Right" },
Default = "Right",
Text = "Notification Side",
Callback = function(Value)
Library:SetNotifySide(Value)
end,
})
MenuGroup:AddDropdown("DPIDropdown", {
Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
Default = "100%",
Text = "DPI Scale",
Callback = function(Value)
Value = Value:gsub("%%", "")
local DPI = tonumber(Value)
Library:SetDPIScale(DPI)
end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
:AddKeyPicker("MenuKeybind", { Default = "U", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function()
getgenv().ayasemiyatongekissazumirisa = false
Shared.Farm = false
Cleanup(Connections)
Cleanup(Flags)
Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/TBB")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
task.defer(function()
SaveManager:LoadAutoloadConfig()
end)
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
Library:SetDPIScale(100)
end
Library:Notify("Script loaded.", 2)
print("z")
Library:Notify("Yuri!", 5)
end)
if not eh_success then
Library:Notify("ERROR: " .. tostring(err), 4)
notyuri("ERROR: " .. tostring(err))
end
elseif game.GameId == 10439925935 then
if getgenv().ayasemiyatongekissazumirisa then
warn("yuri")
return
end
function missing(t, f, fallback)
if type(f) == t then return f end
return fallback
end
cloneref = missing("function", cloneref, function(...) return ... end)
getgc = missing("function", getgc or get_gc_objects)
getconnections = missing("function", getconnections or get_signal_cons)
Services = setmetatable({}, {
__index = function(self, name)
local success, cache = pcall(function()
return cloneref(game:GetService(name))
end)
if success then
rawset(self, name, cache)
return cache
else
error("Invalid Service: " .. tostring(name))
end
end
})
local Players = Services.Players
local Plr = Players.LocalPlayer
local PGui = Plr.PlayerGui
local Lighting = Services.Lighting
local RS = Services.ReplicatedStorage
local RunService = Services.RunService
local HttpService = Services.HttpService
local GuiService = Services.GuiService
local TeleportService = Services.TeleportService
local Marketplace = Services.MarketplaceService
local UIS = Services.UserInputService
local VirtualUser = Services.VirtualUser
local v, Asset = pcall(function()
return Marketplace:GetProductInfo(game.PlaceId)
end)
local assetName = "game name"
if v and Asset then
assetName = Asset.Name
end
local Support = {
Webhook = (typeof(request) == "function" or typeof(http_request) == "function"),
Clipboard = (typeof(setclipboard) == "function"),
FileIO = (typeof(writefile) == "function" and typeof(isfile) == "function"),
QueueOnTeleport = (typeof(queue_on_teleport) == "function"),
Connections = (typeof(getconnections) == "function"),
FPS = (typeof(setfpscap) == "function"),
Proximity = (typeof(fireproximityprompt) == "function"),
}
local executorName = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local LimitedExecutors = {"xeno", "solara",}
local isLimitedExecutor = false
for _, name in ipairs(LimitedExecutors) do
if string.find(executorName, name) then
isLimitedExecutor = true
break
end
end
local l,f={},"1log.txt";if isfile and isfile(f)then delfile(f)end;if writefile then writefile(f,"")end;function notyuri(...)local t=table.create(select("#",...))for i=1,select("#",...)do t[i]=tostring(select(i,...))end local s=("[%s] %s"):format(os.date("%H:%M:%S"),table.concat(t," "));l[#l+1]=s;if appendfile then appendfile(f,s.."\n")end end
local repo = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
getgenv().ayasemiyatongekissazumirisa = true
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true 
Library.ShowCustomCursor = true 
Library.NotifySide = "Left"
local function AddInfo(Window)
local InfoTab = Window:AddTab("Info")
local InfoLeft = InfoTab:AddLeftGroupbox("Information")
local statusText = isLimitedExecutor and "<font color='#FFA500'>Semi-Working</font>" or "<font color='#00FF00'>Working</font>"
local extraNote = isLimitedExecutor
and "<b>NOTE:</b> May experiencing bugs for some features!"
or "All features should works properly!"
InfoLeft:AddLabel("<b>Executor:</b> " .. executorDisplayName .. "\n<b>Status:</b> " .. statusText .. "\n" .. extraNote, true)
local InfoRight = InfoTab:AddRightGroupbox("Others")
InfoRight:AddButton({
Text = "Join Discord Server",
Func = function()
local inviteCode = "q8QX76jyz"
local inviteLink = "https://discord.gg/" .. inviteCode
local success = false
if request then
success = pcall(function()
request({
Url = "http://127.0.0.1:6463/rpc?v=1",
Method = "POST",
Headers = {
["Content-Type"] = "application/json",
["Origin"] = "https://discord.com"
},
Body = HttpService:JSONEncode({
cmd = "INVITE_BROWSER",
args = { code = inviteCode },
nonce = HttpService:GenerateGUID(false)
})
})
end)
end
if not success and setclipboard then
setclipboard(inviteLink)
end
end,
})
end
local eh_success, err = pcall(function()
local Script_Start_Time = os.time()
local function GetSessionTime()
local seconds = os.time() - Script_Start_Time
local hours = math.floor(seconds / 3600)
local mins = math.floor((seconds % 3600) / 60)
return string.format("%dh %02dm", hours, mins)
end
local function GetObject(parent, pathString)
local current = parent
for _, name in ipairs(pathString:split(".")) do
if not current then return nil end
current = current:FindFirstChild(name)
end
return current
end
local function GetSafeModule(parent, name)
local obj = parent:FindFirstChild(name)
if obj and obj:IsA("ModuleScript") then
local success, result = pcall(require, obj)
if success then return result end
end
return nil
end
local function SafeConnect(key, getSignalFn, handler)
local ok, signal = pcall(getSignalFn)
if not ok or not signal then
return
end
Connections[key] = signal:Connect(handler)
end
local function SafeInvoke(remote, ...)
local args = {...}
local result = nil
task.spawn(function()
local success, res = pcall(function()
return remote:InvokeServer(unpack(args))
end)
result = res
end)
local start = tick()
repeat task.wait() until result ~= nil or (tick() - start) > 2 
return result
end
local function fire_event(signal, ...)
if firesignal then
return firesignal(signal, ...)
elseif getconnections then
for _, connection in ipairs(getconnections(signal)) do
if connection.Function then
task.spawn(connection.Function, ...)
end
end
else
warn("Your executor does not support firesignal or getconnections.")
end
end
local Remotes = {
}
local Modules = {
}
local Flags = {}
local Shared = {
}
local Tables = {
}
local Connections = {
Player_General = nil,
Knockback = {},
Reconnect = nil,
}
local function Cleanup(tbl)
for key, value in pairs(tbl) do
if typeof(value) == "RBXScriptConnection" then
value:Disconnect()
tbl[key] = nil
elseif typeof(value) == 'thread' then
task.cancel(value)
tbl[key] = nil
elseif type(value) == 'table' then
Cleanup(value)
end
end
end
function Thread(featurePath, featureFunc, isEnabled, ...)
local pathParts = featurePath:split(".")
local currentTable = Flags 
for i = 1, #pathParts - 1 do
local part = pathParts[i]
if not currentTable[part] then currentTable[part] = {} end
currentTable = currentTable[part]
end
local flagKey = pathParts[#pathParts]
local activeThread = currentTable[flagKey]
if isEnabled then
if not activeThread or coroutine.status(activeThread) == "dead" then
local newThread = task.spawn(featureFunc, ...)
currentTable[flagKey] = newThread
end
else
if activeThread and typeof(activeThread) == 'thread' then
task.cancel(activeThread)
currentTable[flagKey] = nil
end
end
end
local function SafeLoop(name, func)
return function()
local success, err = pcall(func)
if not success then
Library:Notify("Error in ["..name.."]: "..tostring(err), 10)
warn("Error in ["..name.."]: "..tostring(err))
end
end
end
local function CommaFormat(n)
local s = tostring(n)
return s:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end
local function Abbreviate(n)
local abbrev = {{1e12, "T"}, {1e9, "B"}, {1e6, "M"}, {1e3, "K"}}
for _, v in ipairs(abbrev) do
if n >= v[1] then return string.format("%.1f%s", n / v[1], v[2]) end
end
return tostring(n)
end
function AddSliderToggle(Config)
local Toggle = Config.Group:AddToggle(Config.Id, {
Text = Config.Text,
Default = Config.DefaultToggle or false
})
local Slider = Config.Group:AddSlider(Config.Id .. "Value", {
Text = Config.Text,
Default = Config.Default,
Min = Config.Min,
Max = Config.Max,
Rounding = Config.Rounding or 0,
Compact = true,
Visible = false
})
Toggle:OnChanged(function()
Slider:SetVisible(Toggle.Value)
end)
return Toggle, Slider
end
local function GetCharacter()
local c = Plr.Character
return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
end
local function FuncTPW()
while true do
local delta = RunService.Heartbeat:Wait()
local char = GetCharacter()
local hum = char and char:FindFirstChildOfClass("Humanoid")
if char and hum and hum.Health > 0 then
if hum.MoveDirection.Magnitude > 0 then
local speed = Options.TPWValue.Value
char:TranslateBy(hum.MoveDirection * speed * delta * 10)
end
end
end
end
local function FuncNoclip()
while Toggles.Noclip.Value do
RunService.Stepped:Wait()
local char = GetCharacter()
if char then
for _, part in pairs(char:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then
part.CanCollide = false
end
end
end
end
end
local function Func_AntiKnockback()
if type(Connections.Knockback) == "table" then
for _, conn in pairs(Connections.Knockback) do
if conn then conn:Disconnect() end
end
table.clear(Connections.Knockback)
else
Connections.Knockback = {}
end
local function ApplyAntiKB(character)
if not character then return end
local root = character:WaitForChild("HumanoidRootPart", 10)
if root then
local conn = root.ChildAdded:Connect(function(child)
if not Toggles.AntiKnockback.Value then return end
if child:IsA("BodyVelocity") and child.MaxForce == Vector3.new(40000, 40000, 40000) then
child:Destroy()
end
end)
table.insert(Connections.Knockback, conn)
end
end
if Plr.Character then
ApplyAntiKB(Plr.Character)
end
local charAddedConn = Plr.CharacterAdded:Connect(function(newChar)
ApplyAntiKB(newChar)
end)
table.insert(Connections.Knockback, charAddedConn)
repeat task.wait(1) until not Toggles.AntiKnockback.Value
for _, conn in pairs(Connections.Knockback) do
if conn then conn:Disconnect() end
end
table.clear(Connections.Knockback)
end
local function Func_AutoReconnect()
if Connections.Reconnect then Connections.Reconnect:Disconnect() end
Connections.Reconnect = GuiService.ErrorMessageChanged:Connect(function()
if not Toggles.AutoReconnect.Value then return end
task.delay(2, function()
pcall(function()
local promptOverlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
if promptOverlay then
local errorPrompt = promptOverlay.promptOverlay:FindFirstChild("ErrorPrompt")
if errorPrompt and errorPrompt.Visible then
local secondaryTimer = 5
task.wait(secondaryTimer)
TeleportService:Teleport(game.PlaceId, Plr)
end
end
end)
end)
end)
end
local function Func_NoGameplayPaused()
while Toggles.NoGameplayPaused.Value do
local success, err = pcall(function()
local pauseGui = game:GetService("CoreGui").RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
if pauseGui then
pauseGui:Destroy()
end
end)
task.wait(1)
end
end
local function ApplyFPSBoost(state)
if not state then return end
pcall(function()
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 1
for _, v in pairs(Lighting:GetChildren()) do
if v:IsA("PostProcessEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
v.Enabled = false
end
end
task.spawn(function()
for i, v in pairs(workspace:GetDescendants()) do
if Toggles.FPSBoost and not Toggles.FPSBoost.Value then break end
pcall(function()
if v:IsA("BasePart") then
v.Material = Enum.Material.SmoothPlastic
v.CastShadow = false
elseif v:IsA("Decal") or v:IsA("Texture") then
v:Destroy()
elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
v.Enabled = false
end
end)
if i % 500 == 0 then task.wait() end
end
end)
end)
end
function gsc(guiObject)
if not guiObject then return false end
local success = false
pcall(function()
if Services.GuiService and Services.VirtualInputManager then
Services.GuiService.SelectedObject = guiObject
task.wait(0.05)
local keys = {Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter, Enum.KeyCode.ButtonA}
for _, key in ipairs(keys) do
Services.VirtualInputManager:SendKeyEvent(true, key, false, game); task.wait(0.03)
Services.VirtualInputManager:SendKeyEvent(false, key, false, game); task.wait(0.03)
end
Services.GuiService.SelectedObject = nil
success = true
end
end)
return success
end
local function FireCD(target)
if not fireclickdetector then
return
end
if not target or not target:IsA("ClickDetector") then
return
end
fireclickdetector(target)
end
local function FirePP(target, teleport)
if not fireproximityprompt then return end
if not target or not target:IsA("ProximityPrompt") then return end
local prevDist = target.MaxActivationDistance
if teleport then
local char = GetCharacter()
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local part = target.Parent
local isModel = false
if part then
if part:IsA("Model") then
isModel = true
elseif not part:IsA("BasePart") then
part = target:FindFirstAncestorWhichIsA("BasePart")
if not part then
part = target:FindFirstAncestorWhichIsA("Model")
if part then
isModel = true
end
end
end
end
if hrp and part then
local partPos = isModel and part:GetPivot().Position or part.Position
local dist = (hrp.Position - partPos).Magnitude
if dist > prevDist then
local partCFrame = isModel and part:GetPivot() or part.CFrame
hrp.CFrame = partCFrame * CFrame.new(0, 3, 0)
task.wait(0.175)
end
end
end
fireproximityprompt(target)
end
local function FireTI(target)
if not firetouchinterest then
return
end
local root = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
if not root then
return
end
local part
if target:IsA("BasePart") then
part = target
else
part = target:FindFirstAncestorWhichIsA("BasePart")
end
if not part then
return
end
task.spawn(function()
firetouchinterest(part, root, 1)
task.wait()
firetouchinterest(part, root, 0)
end)
end
local Window = Library:CreateWindow({
Title = "Yuri",
Center = true,
AutoShow = true,
Resizable = true,
ShowCustomCursor = false,
UnlockMouseWhileOpen = false,
NotifySide = "Left",
TabPadding = 8,
MenuFadeTime = 0.2
})
AddInfo(Window)
local Tabs = {
Main = Window:AddTab("Main"),
Player = Window:AddTab("Player"),
Config = Window:AddTab("Config"),
}
local TB = {
Main = {
Left = {
Autofarm = Tabs.Main:AddLeftTabbox(),
},
Right = {
Autofarm = Tabs.Main:AddRightTabbox(),
},
},
}
local TB_Tabs = {
Autofarm = {
T1 = TB.Main.Left.Autofarm:AddTab("Autofarm"),
},
Autofarm2 = {
T1 = TB.Main.Right.Autofarm:AddTab("Config"),
},
}
TB_Tabs.Autofarm.T1:AddButton({
Text = "Finish the game",
Func = function()
local Event = RS:WaitForChild("BounceSave")
local payload = {
ppr = 100000,
sl1 = 1000000000,
sl2 = 5,
sl3 = 30,
sl4 = true,
sl5 = true,
sl6 = 5,
rlr = true,
clka = 0,
clkb = 0,
clkg = true,
clkt = 0,
clko = 4,
clkv = 0,
npcd = true,
nacd = true,
tsg = false,
c2u = os.time() + 7200,
siu = os.time() + 3600,
gbest = {},
nbc = 0,
plkr = true,
plk = true,
plks = 500,
plt = 0,
rday = 10,
bluck = 21,
rainbow = 9999,
rebirths = 100000,
cpk = true,
nbb = 86400,
sbb = true,
spinw = 6,
lk = 9999999,
evp = true,
bmax = 25,
gmb = 25,
clo = 0,
prism = 9999,
prb = 9999,
clkb = 0,
sp = 12,
utaps = 10000000,
ult = 10000000,
nb = 1000000,
nbp = 240,
gold = 9999,
gifted = {},
stt = {
rb2 = 100000,
bn = 100000,
bb = 100000,
gf = 100000,
cr = 100000,
bm = 1e308,
rf = 100000,
},
sl6 = 5,
pw = 9999999,
unlocked = true,
gp = 15,
bunlock = {},
rsp = true,
srp = true,
sru = 0,
nova = 9999,
spinl = 1784878052,
tut = true,
mvol = 0.5,
rlast = 0,
rbx = 0,
bspin = 9999,
spn = 9999,
cds = {},
esc = false,
orate = 0,
lat = 0,
bxc = false,
rsl = 5,
rsk = 4,
anti = 9999,
nfl = false,
cst = 0,
pt = 9999,
lbm = 100,
lbu = os.time() + 9999999,
lpt = 0,
sl4 = true,
spk = 10,
grpt = 0,
cb = 9999,
msong = 1,
snd = true,
ngp = false,
co = 9999999,
pm = 9999999,
tree = {},
slo = true,
sac = true,
aby = true,
abs = {},
spn = 9999,
spin = 20,
rings = 20,
scm = 1000000000,
asc = 1000000000,
rp = 9999999,
mlg = 1000000,
money = 1e308,
telg = 1000000,
bmlg = 1000000,
balls = 300,
fsd = true,
fx = true,
r2g = true,
uwd = true,
hole = 9999,
exs = 9999,
rbx = 0,
hui = false,
hpb = false,
bgo = {},
utr = {},
crc = {},
uwN = 0,
uw = 0,
}
task.spawn(function()
local startTime = os.time()
while task.wait() do
pcall(function()
Event:FireServer(payload)
end)
if os.time() - startTime >= 1 then
break
end
end
task.wait(1)
Services.TeleportService:Teleport(game.PlaceId, Plr)
end)
end,
})
local GB = {
Player = {
Left = {
General = Tabs.Player:AddLeftGroupbox("General"),
Server  = Tabs.Player:AddLeftGroupbox("Server"),
},
Right = {
Game = Tabs.Player:AddRightGroupbox("Game"),
},
},
}
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 250 })
local TPW_T, TPW_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "JP", Text = "JumpPower", Default = 50, Min = 0, Max = 500 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "HH", Text = "HipHeight", Default = 2, Min = 0, Max = 10, Rounding = 1 })
GB.Player.Left.General:AddToggle("Noclip", { Text = "Noclip" })
GB.Player.Left.General:AddToggle("AntiKnockback", {
Text = "Anti Knockback",
Default = false,
})
GB.Player.Left.General:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering" })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1})
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
local FPS_T, FPS_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
GB.Player.Left.General:AddToggle("FPSBoost", { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK", {
Text = "Anti AFK",
Default = true,
Disabled = not Support.Connections,
})
GB.Player.Left.Server:AddToggle("AntiKick", { Text = "Anti Kick (Client)" })
GB.Player.Left.Server:AddToggle("AutoReconnect", { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused"})
GB.Player.Left.Server:AddButton({ Text = "Serverhop", Func = function()
local Servers = game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100')
end})
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function() Services.TeleportService:Teleport(game.PlaceId, Plr) end })
GB.Player.Left.Server:AddToggle("AutoServerhop", { Text = "Auto Serverhop" })
GB.Player.Left.Server:AddSlider("AutoHopMins", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
GB.Player.Right.Game:AddToggle("InstantPP", { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog", { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
Toggles.AntiKnockback:OnChanged(function(state)
Thread("AntiKnockback", Func_AntiKnockback, state)
end)
Toggles.TPW:OnChanged(function(v)
TPW_S:SetVisible(TPW_T.Value)
Thread("TPW", FuncTPW, v)
end)
Toggles.Noclip:OnChanged(function(v)
Thread("Noclip", FuncNoclip, v)
end)
Connections.Player_General = RunService.Stepped:Connect(function()
local Hum = Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")
if Hum then
if Toggles.WS.Value then Hum.WalkSpeed = Options.WSValue.Value end
if Toggles.JP.Value then Hum.JumpPower = Options.JPValue.Value Hum.UseJumpPower = true end
if Toggles.HH.Value then Hum.HipHeight = Options.HHValue.Value end
end
workspace.Gravity = Toggles.Grav.Value and Options.GravValue.Value or 192
if Toggles.FOV.Value then workspace.CurrentCamera.FieldOfView = Options.FOVValue.Value end
if Toggles.Zoom.Value then Plr.CameraMaxZoomDistance = Options.ZoomValue.Value end
end)
task.spawn(function()
while task.wait() do
if Toggles.Fullbright.Value then
Lighting.Brightness = 2
Lighting.ClockTime = 14
Lighting.GlobalShadows = false
elseif Toggles.OverrideTime.Value then
Lighting.ClockTime = Options.OverrideTimeValue.Value
end
if Toggles.NoFog.Value then Lighting.FogEnd = 9e9 end
if Library.Unloaded then break end
end
end)
Options.LimitFPSValue:OnChanged(function()
if FPS_T.Value then
setfpscap(FPS_S.Value)
end
end)
Toggles.LimitFPS:OnChanged(function(v)
FPS_S:SetVisible(FPS_T.Value)
if not v then
setfpscap(999)
end
end)
Toggles.Disable3DRender:OnChanged(function(v) RunService:Set3dRenderingEnabled(not v) end)
Toggles.FPSBoost:OnChanged(function(state)
ApplyFPSBoost(state)
end)
Toggles.AutoReconnect:OnChanged(function(state)
if state then Func_AutoReconnect() end
end)
Toggles.NoGameplayPaused:OnChanged(function(state)
Thread("NoGameplayPaused", SafeLoop("Anti-Pause", Func_NoGameplayPaused), state)
end)
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
if Toggles.InstantPP and Toggles.InstantPP.Value then
prompt.HoldDuration = 0
end
end)
local function RunAntiAFK()
local GC = getconnections or get_signal_cons
if GC then
for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
if v["Disable"] then
v["Disable"](v)
elseif v["Disconnect"] then
v["Disconnect"](v)
end
end
else
local VirtualUser = cloneref(game:GetService("VirtualUser"))
Players.LocalPlayer.Idled:Connect(function()
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end)
end
end
Toggles.AntiAFK:OnChanged(function(state)
if state then RunAntiAFK() end
end)
if Toggles.AntiAFK.Value then RunAntiAFK() end
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("AutoShowUI", {
Text = "Auto Show UI",
Default = true,
})
MenuGroup:AddToggle("KeybindMenuOpen", {
Default = Library.KeybindFrame.Visible,
Text = "Open Keybind Menu",
Callback = function(value)
Library.KeybindFrame.Visible = value
end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
Text = "Custom Cursor",
Default = false,
Callback = function(Value)
Library.ShowCustomCursor = Value
end,
})
MenuGroup:AddDropdown("NotificationSide", {
Values = { "Left", "Right" },
Default = "Right",
Text = "Notification Side",
Callback = function(Value)
Library:SetNotifySide(Value)
end,
})
MenuGroup:AddDropdown("DPIDropdown", {
Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
Default = "100%",
Text = "DPI Scale",
Callback = function(Value)
Value = Value:gsub("%%", "")
local DPI = tonumber(Value)
Library:SetDPIScale(DPI)
end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
:AddKeyPicker("MenuKeybind", { Default = "U", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function()
getgenv().ayasemiyatongekissazumirisa = false
Shared.Farm = false
Cleanup(Connections)
Cleanup(Flags)
Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/IdleBalls")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
task.defer(function()
SaveManager:LoadAutoloadConfig()
end)
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
Library:SetDPIScale(100)
end
Library:Notify("Script loaded.", 2)
Library:Notify("Yuri!", 5)
end)
if not eh_success then
Library:Notify("ERROR: " .. tostring(err), 4)
notyuri("ERROR: " .. tostring(err))
end
end