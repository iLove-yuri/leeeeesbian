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
}
local gid = game.GameId
local id = GameList[gid]
if not id then
	plr:Kick("Wrong/Unsupported Game")
	return
end
local url = "https://api.jnkie.com/api/v1/luascripts/public/" .. id .. "/download"
pcall(function()
	loadstring(game:HttpGet(url))()
end)
queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
Players.LocalPlayer.OnTeleport:Connect(function(State)
	if _G.autoExec and queueteleport then
		queueteleport([[
			loadstring(game:HttpGet('https://raw.githubusercontent.com/iLove-yuri/leeeeesbian/refs/heads/main/bloomintoyou.lua'))()
		]])
	end
end)