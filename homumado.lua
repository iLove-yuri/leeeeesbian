repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.GameId ~= 0
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

local CoreGui = Services.CoreGui
local HttpService = Services.HttpService
local TextService = Services.TextService
local Lighting = Services.Lighting
local Players = Services.Players
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService
local Workspace = Services.Workspace
local plr = Players.LocalPlayer
local list = {
	{gid = {"9866884975", "1831550657", "10337069275", "10161576677"}, id = "1b1251046fd4407c1d8f7e90cb337aeb", keyless = false}, -- sail boat, cos, ice tycoon, flag
	{gid = {"7359962123"}, id = "f3cdf28dc70b1249611f4d9e92b15c4e", keyless = false}, -- aac
	{gid = {"10277874067", "8978470369", "9870850309", "10258087043", "7613921865"}, id = "245e817ec11f0591898dbef698f5a598", keyless = false}, -- gambling, castle, bubble, r, ae
	{gid = {"9219838330", "10334731049", "6749892429", "7990186056", "7300616172"}, id = "d310529bba1c9560607c620cc8664b89", keyless = false}, -- pml, spm, eve, tower, purge
	{gid = {"9980077437", "5691634893", "10002454638", "10384841418", "10231871497", "10253235584"}, id = "d8e39dd7c8bfa5015a2c48dc361d656f", keyless = false}, -- rng, overdrive, vut, squishy, drill, base
	{gid = {"10111742174", "9584946743", "10053091404", "10368005384"}, id = "74b4e982b9b980d106fc43e8ca53f248", keyless = false}, -- 🧱, ii, pf
	{gid = {"7037673488", "10040426659", "8161187430", "10255492538", "10356701370" }, id = "3781eb1fc444bef291a013c0e69f7c2a", keyless = false}, -- skeleton, ti, qua,li, stealbase
	{gid = {"9965411707", "8500639466","10273193868", "9734147105", "8079278639"}, id = "79c4f538aba5d702cd1b7795737a36d1", keyless = false}, -- ni, cu, ma, s, u
}
local gid = tostring(game.GameId)
local game_config
for _, entry in ipairs(list) do
	for _, id in ipairs(entry.gid) do
		if id == gid then
			game_config = entry
			break
		end
	end
	if game_config then break end
end
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
    AAC = "https://ads.luarmor.net/get_key?for=AAC-iugtlcjdSYXB",
    LinkvertiseURL = "https://ads.luarmor.net/get_key?for=Yuri-ODPllbErcWEJ",
    WorkinkURL = "https://ads.luarmor.net/get_key?for=Lesbian-pCiCBJScuyDv",
    DiscordURL = "https://discord.gg/VgsVeUxBY",
}
local luarmor_api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
luarmor_api.script_id = script_id
if is_key_less then
    pcall(function()
        luarmor_api.load_script()
    end)
    return
end

if isfile(config.KeyFile) then
    local savedKey = readfile(config.KeyFile):gsub("%s", "")
    local success, result = pcall(function()
        return luarmor_api.check_key(savedKey)
    end)
    if success and result.code == "KEY_VALID" then
        script_key = savedKey
        pcall(function()
            luarmor_api.load_script()
        end)
        return
    elseif success and result.code == "KEY_HWID_LOCKED" then
        delfile(config.KeyFile)
        plr:Kick("Key is locked to a different HWID. Reset your HWID and re-run.")
        return
    else
        delfile(config.KeyFile)
        plr:Kick("Saved key is invalid or expired. Re-run the script to get a new one.")
        return
    end
end
local Yuri = loadstring(game:HttpGet("https://raw.githubusercontent.com/iLove-yuri/debug/refs/heads/main/homutop.lua"))()
local function validateKey(key, notify, screenGui)
	local cleanedKey = key:gsub("%s", "")
	if #cleanedKey ~= 32 then
		notify("Invalid key format (must be 32 characters)", Color3.fromRGB(255, 60, 60))
		return false
	end
	notify("Validating key...", Color3.fromRGB(220, 220, 220))
	local success, result = pcall(function()
		return luarmor_api.check_key(cleanedKey)
	end)
	if not success then
		notify("Network error. Check your connection.", Color3.fromRGB(255, 60, 60))
		return false
	end
	if result.code == "KEY_VALID" then
		if not isfolder("yuri") then
			makefolder("yuri")
		end
		writefile(config.KeyFile, cleanedKey)
		script_key = cleanedKey
		screenGui:Destroy()
		pcall(function()
			luarmor_api.load_script()
		end)
		return true
	else
		notify("Invalid or expired key", Color3.fromRGB(255, 60, 60))
		return false
	end
end
Yuri.new({
    TweenService = TweenService,
    UserInputService = UserInputService,
    CoreGui = CoreGui,
    TextService = TextService,
    config = config,
    scriptKey = script_key,
    onCheckKey = validateKey,
})
queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
Players.LocalPlayer.OnTeleport:Connect(function(State)
	if _G.autoExec and queueteleport then
		TeleportCheck = true
		queueteleport([[
			loadstring(game:HttpGet('https://raw.githubusercontent.com/iLove-yuri/leeeeesbian/refs/heads/main/homumado.lua'))()
		]])
	end
end)
