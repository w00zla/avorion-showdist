--[[

SHOWDIST COMMAND MOD

version: 0.4
author: w00zla

file: commands/showdistjump.lua
desc: auto-included script to implement custom command /showdistjump

]]--

package.path = package.path .. ";data/scripts/lib/?.lua"

-- include libraries
require "cmd.showdistcommon"


-- called when command is received
function execute(sender, commandName, ...)
	local player = Player(sender)
	
	local args = {...}	
	if #args > 0 then
	
		-- make sure entity script is attached for later invokes
		local script = "cmd/" .. commandName .. ".lua"
		if not player:hasScript(script) then
			player:addScriptOnce(script)
		end
		
		-- parse command args
		local location = string.lower(args[1])
		local param = table.concat(args, " ", 2)	
		
		-- execute player entity script function
		player:invokeFunction(script, "executeCommand", commandName, location, param)
		
	else
		player:sendChatMessage("Server", 0, "Missing location for '" .. commandName .. "' command!")
	end
		
    return 0, "", ""
end


-- called when??
function getDescription()
    return "Shows notifications about distance to center of galaxy, home sector and other locations after each jump"
end


-- called by /help command
function getHelp()
    return [[
Shows distance to registered locations after each jump as notifications.
Multiple locations can be registered which will all be shown after jumps.
Usage:
/showdistjump center
/showdistjump home
/showdistjump home <PLAYER>
/showdistjump sector <XXX:YYY>
/showdistjump sector <XXX:YYY> <NAME>
/showdistjump off
Parameter:
<PLAYER> = name or index of existing player
<XXX:YYY> = coordinates value (like "321:456" or "12:-34") 
<NAME> = name value (like "Trade1" or "SomeSector", no spaces)
]]
end
