repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.GameId ~= 0
function missing(t, f, fallback)
	if type(f) == t then return f end
	return fallback
end
cloneref = missing("function", cloneref, function(...) return ... end)
local Services = setmetatable({}, {
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
local plr = Players.LocalPlayer
local GameList = {
	[5361032378] = "5edec9b7b6816639c7dd28826e0a447498e76e4a1b8b36b47be118f60e005ef8",
	[9186719164] = "fe269a59c3cd94d6e8ffbb7115a7d008b02cf519a84b163827cbd6959ceed421",
	[4658598196] = "ac3e5a4381cadd8df883215d0ba3271f19a293109ac8f384931b3bca40446706",
	[5130394318] = "99faccc9dc541a9912abda65e8cc3d14f800787dee4b6eb5bc991d4e4fb89b4a",
	[1831550657] = "ac91a458cf3f8ec1e2600a5a3bd104f367a4a3a935764c928d311dbd90707f99",
}
local gid = game.GameId
local id = GameList[gid]
if not id then
	plr:Kick("Wrong/Unsupported Game")
	return
end
getgenv().SCRIPT_KEY = "KEYLESS"
loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/" .. id .. "/download"))()
queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
Players.LocalPlayer.OnTeleport:Connect(function(State)
	if _G.autoExec and queueteleport then
		queueteleport([[
			loadstring(game:HttpGet('https://raw.githubusercontent.com/iLove-yuri/leeeeesbian/refs/heads/main/bloomintoyou.lua'))()
		]])
	end
end)