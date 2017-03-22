--[[

SHOWDIST COMMAND MOD

version: 0.4
author: w00zla

file: player/cmd/showdist.lua
desc: player entity script for /showdist command

]]--

if onServer() then -- make this script run server-side only

package.path = package.path .. ";data/scripts/lib/?.lua"

-- include libraries
require "cmd.showdistcommon"


-- called when script is attached to entity or when entity is loaded
function initialize(commandName, location, param)

	local player = Player()
	
    if location == "center" then		
		showCenterDistance(player)
	
	elseif location == "home" then
		-- parse optional playername
		local playerindex = parseHomeLocationParameter(player, param) 
		if playerindex then
			showHomeDistance(player, Player(playerindex))
		end 
	elseif location == "sector" then
		-- parse details for user-defined sector
		local secCoords, name = parseSectorLocationParameter(player, param)
		if secCoords then
			showCoordsDistance(player, secCoords.x, secCoords.y, name)
		end
	else
		player:sendChatMessage("Server", 0, "Unknown location for '" .. commandName .. "' command!")
	end
	
	terminate() -- this will remove the script from the entity
end


-- show distance to center/core as chat message
function showCenterDistance(player)
	
	local dist = getCurrentCenterDistance()
	local distLabel = getSectorsDistanceLabel(dist)
	player:sendChatMessage("Server", 0, string.format("Center Distance: %i %s", dist, distLabel))

end


-- show distance to any players home sector as chat message
function showHomeDistance(player, targetplayer)
	
	local dist
	local distLabel
	local msg

	if targetplayer.index == player.index then
		-- current player's home
		dist = getCurrentHomeDistance()
		distLabel = getSectorsDistanceLabel(dist)
		msg = string.format("Home Distance: %i %s", dist, distLabel)
	else
		-- other player's home
		dist = getPlayerHomeDistance(targetplayer)
		distLabel = getSectorsDistanceLabel(dist)
		msg = string.format("Home of '%s' Distance: %i %s", player.name, dist, distLabel)
	end

	player:sendChatMessage("Server", 0, msg)

end


-- show distance to user-defined sector as chat message
function showCoordsDistance(player, x, y, name)

	local dist = getCurrentCoordsDistance(x, y)
	local distLabel = getSectorsDistanceLabel(dist)
	player:sendChatMessage("Server", 0, string.format("Sector '%s' Distance: %i %s", name, dist, distLabel))

end


end