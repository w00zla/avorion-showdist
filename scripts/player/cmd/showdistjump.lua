--[[

SHOWDIST COMMAND MOD

version: 0.4
author: w00zla

file: player/cmd/showdistjump.lua
desc: player entity script for /showdistjump command

]]--

if onServer() then -- make this script run server-side only

package.path = package.path .. ";data/scripts/lib/?.lua"

-- include libraries
require "utility"
require "cmd.showdistcommon"


-- declare local fields
local registeredLocations
local subscribed


-- called when script is attached to entity or when entity is loaded
function initialize()

	registeredLocations = {}
	subscribed = false
	
end


-- called by server on galaxy/sector saving
-- given return values are persisted into galaxy database
function secure()

	if registeredLocations then
		return registeredLocations
	end
	
end


-- called by server on galaxy/sector loading
-- given arguments are persisted return values of secure() function 
function restore(locationsTable)

	registeredLocations = locationsTable
	if registeredLocations then 
		subscribeEvents(Player())
	end
	
end


-- called/invoked to register distance locations to be shown
function executeCommand(commandName, location, param)

	local player = Player()

	if location == "off" then
		-- reset vars and unregister from any callbacks
		registeredLocations = {}
		unsubscribeEvents(player)
		player:sendChatMessage("Server", 0, "Disabled all distance notifications")	
		
		terminate() -- this will remove the script from the entity
	else	
		-- save location details and register callback for player sector jumps
		if registerLocation(player, location, param) then
			subscribeEvents(player)
		else
			player:sendChatMessage("Server", 0, "Unknown location for " .. commandName .. " command!")
		end
	end
	
end


-- player entity callback called when new sector is loaded after jumps
function onSectorEntered(player, x, y)

	local player = Player(player)
	showLocationDistances(player)
	
end


-- subscribe to entity callbacks
function subscribeEvents(player)

	if not subscribed then
		player:registerCallback("onSectorEntered", "onSectorEntered")
		subscribed = true
	end

end


-- unsubscribe from entity callbacks
function unsubscribeEvents(player)

	if subscribed then
		player:unregisterCallback("onSectorEntered", "onSectorEntered")
		subscribed = false		
	end

end


-- validates and adds new locations to be shown after jumps
function registerLocation(player, location, param)

	-- store defined location details in table for later retrival
	-- and show immediate notification about location distance
	if location == "center" then		
		registeredLocations[location] = true
		player:sendChatMessage("Server", 0, "Registered Center location for distance notifications")
		showCenterDistance(player)
		
	elseif location == "home" then	
		-- parse optional playername
		local playerindex = parseHomeLocationParameter(player, param) 
		if playerindex then
			addRegisteredLocation(registeredLocations, location, playerindex)
			local targetplayer = Player(playerindex)
			player:sendChatMessage("Server", 0, string.format("Registered Home location of '%s' for distance notifications", targetplayer.name))
			showHomeDistance(player, targetplayer)
		end 
		
	elseif location == "sector" then
		-- parse details for user-defined sector
		local secCoords, name = parseSectorLocationParameter(player, param)
		if secCoords then
			local entry = { secCoords.x, secCoords.y, name }			
			addRegisteredLocation(registeredLocations, location, entry)			
			player:sendChatMessage("Server", 0, "Registered Sector '" .. param .. "' for distance notifications")
			showCoordsDistance(player, secCoords.x, secCoords.y, name)
		end
	else
		return false
	end

	return true
end


function addRegisteredLocation(loctbl, loc, entry)

	-- create additional tables and store location data there
	if not loctbl[loc] then
		loctbl[loc] = {}
	end
	table.insert(loctbl[loc], entry)

end


-- display distances to all registered locations
function showLocationDistances(player)

	if registeredLocations["center"] then
		showCenterDistance(player)
	end
	if registeredLocations["home"] then
		-- iterate through stored player home sectors
		for _, v in pairs(registeredLocations["home"]) do
			local targetplayer = Player(v)
			showHomeDistance(player, targetplayer)
		end
	end
	if registeredLocations["sector"] then
		-- iterate through stored user-defined sectors
		for _, v in pairs(registeredLocations["sector"]) do
			local secCoords = vec2(v[1], v[2])
			local name = v[3]
			showCoordsDistance(player, secCoords.x, secCoords.y, name)
		end
	end

end


-- show distance to center/core as temporary notification
function showCenterDistance(player)

	local dist = getCurrentCenterDistance()
	local distLabel = getSectorsDistanceLabel(dist)
	player:sendChatMessage("", 3, string.format("Center Distance: %i %s", dist, distLabel))

end


-- show distance to any players home sector as temporary notification
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
	
	player:sendChatMessage("", 3, msg)

end


-- show distance to user-defined sector as temporary notification
function showCoordsDistance(player, x, y, name)

	local dist = getCurrentCoordsDistance(x, y)
	local distLabel = getSectorsDistanceLabel(dist)
	player:sendChatMessage("", 3, string.format("Sector '%s' Distance: %i %s", name, dist, distLabel))

end


end