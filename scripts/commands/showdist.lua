--[[

SHOWDIST COMMAND MOD

version: 0.4
author: w00zla

file: commands/showdist.lua
desc: auto-included script to implement custom command /showdist

]]--

package.path = package.path .. ";data/scripts/lib/?.lua"

-- include libraries
require "cmd.showdistcommon"


-- called when command is received
function execute(sender, commandName, ...)
	local player = Player(sender)
	
	local args = {...}	
	if args[1] then
		-- parse command args
		local location = string.lower(args[1])
		local param = table.concat(args, " ", 2)	

		-- attach and execute player entity script once
		player:addScriptOnce("cmd/" .. commandName .. ".lua", commandName, location, param)
	else
		player:sendChatMessage("Server", 0, "Missing location for '" .. commandName .. "' command!")
	end
		
    return 0, "", ""
end


-- called when??
function getDescription()
    return "Shows distance to center of galaxy, home sector and other locations"
end


-- called by /help command
function getHelp()
    return [[
Shows distance of player to defined location in chat window.
Usage:
/showdist center
/showdist home
/showdist home <PLAYER>
/showdist sector <XXX:YYY>
/showdist sector <XXX:YYY> <NAME>
Parameter:
<PLAYER> = name or index of existing player
<XXX:YYY> = coordinates value (like "321:456" or "12:-34") 
<NAME> = name value (like "Trade1" or "SomeSector", no spaces)
]]
end
