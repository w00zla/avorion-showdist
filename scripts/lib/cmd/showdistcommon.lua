--[[

SHOWDIST COMMAND MOD

version: 0.4
author: w00zla

file: lib/cmd/showdistcommon.lua
desc: library script for /showdist commands

]]--

package.path = package.path .. ";data/scripts/lib/?.lua"

-- include libraries

require("utility")
require("stringutility")


-- validate parameters for "sector" location
function parseSectorLocationParameter(player, param)

	if param == nil or param == "" then
		player:sendChatMessage("Server", 0, "A coordinates parameter is required for location of type 'sector'!")
		return
	end

	local coordsVal
	local name
	
	-- split parameter into coordinates and name parts if it contains a space
	local idx = string.find(param, " ")
	if idx then
		coordsVal = string.sub(param, 1, idx - 1)
		name = string.sub(param, idx)
	else
		coordsVal = param
		name = param		
	end
	
	-- get real valid coordinates
	local coords = parseCoordinates(coordsVal)
	
	if not coords then
		player:sendChatMessage("Server", 0, "The defined parameter is not a valid coordinates value!")
	end
	
	return coords, name
end

-- validate parameters for "home" location
function parseHomeLocationParameter(player, param)

	local playerindex
	if param and param ~= "" then

		-- get valid player index for defined playername or entity index
		playerindex = getPlayerIndex(param)
		
		if not playerindex then
			player:sendChatMessage("Server", 0, string.format("No player with name or index '%s' was found!", param))
			return
		end
	
	else
		playerindex = player.index	
	end
	
	return playerindex
end


-- parse "XXX:YYY" style string for sector coordinates
function parseCoordinates(coords)
	local coordX, coordY = string.match(coords, "([%d%-]+):([%d%-]+)")
	if coordY and coordX then
		if validateCoordinates(coordX, coordY) then		
			return vec2(coordX, coordY)
		end
	end
end


-- check if defined coordinates are valid for the game
function validateCoordinates(x, y)

	local x = tonumber(x)
	local y = tonumber(y)

	-- galaxy is a static 500x500 grid
	if x == nil or x > 500 or x < -499 then
		return false
	elseif y == nil or y > 500 or y < -499 then
		return false
	end

	return true
end


-- calculate distance to galaxy center
function getCurrentCenterDistance()

	local vecSector = vec2(Sector():getCoordinates())
	local dist = length(vecSector)

	return dist

end


-- calculate distance to player home-sector
function getCurrentHomeDistance()

	local vecSector = vec2(Sector():getCoordinates())
	local vecHome = vec2(Player():getHomeSectorCoordinates())
	local dist = distance(vecSector, vecHome)

	return dist

end


-- calculate distance to defined player's home-sector
function getPlayerHomeDistance(player)

	local vecSector = vec2(Sector():getCoordinates())
	local vecHome = vec2(player:getHomeSectorCoordinates())
	local dist = distance(vecSector, vecHome)

	return dist

end


-- calculate distance to given sector coordinates
function getCurrentCoordsDistance(x, y)

	local vecSector = vec2(Sector():getCoordinates())
	local vecCoords = vec2(x, y)
	local dist = distance(vecSector, vecCoords)

	return dist

end


-- had to be done ;P
function getSectorsDistanceLabel(dist)

	if not tonumber(dist) then
		return ""
	elseif dist == 1 or dist == -1 then
		return "sctr"
	end
	return "sctrs"
	
end


-- returns player index if any player with given name or index is found, otherwise nil
function getPlayerIndex(playername)

	-- check if an entity index was passed
	local faction = Galaxy():findFaction(playername)
	if faction then
		if faction.isPlayer  then
			-- argument is already a player index
			return playername
		else
			return -- return nil since its an non-player index
		end
	end
	
	-- get indices and names for all existing players
	local galaxyPlayers = Galaxy():getPlayerNames()
	
	if type(galaxyPlayers) == "string" then
		-- only one player, assume singleplayer game
		if galaxyPlayers == playername then
			return Player().index
		end
	else
		for index, name in pairs(galaxyPlayers) do
			if playername:lower() == name:lower() then
				return index
			end
		end
	end

	return -- return nil since no player was found
end
