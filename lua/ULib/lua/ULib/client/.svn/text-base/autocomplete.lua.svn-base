--[[
	Title: Autocomplete

	*HACK WARNING*
	This file will allow us to manipulate client-side autocomplete for server-side commands.
	This file also has some helper functions for autocomplete.
]]

--[[
	Function: redirect

	This redirects any ULib-created command that has autocomplete. This is necessary because in order for a command to have autocomplete, 
		it must not be a valid command on the server. When the client uses a command with autocomplete, it calls this function which hexes
		the parameters so they won't be blocked for certain keywords and the server reinterprets and parses the command.
		
	*DO NOT CALL DIRECTLY*

	Parameters:

		ply - The player using the command
		command - The command being used
		argv - The table of arguments
		args - The string of arguments
]]
function ULib.redirect( ply, command, argv, args )
	args = command .. " " .. args

	local t = { string.byte( args, 1, -1 ) } -- Make it a table of numbers
	for k, v in ipairs( t ) do
		t[ k ] = string.format( "%.2X", v ) -- Convert to hex
	end
	args = table.concat( t, "" ) -- Now put it back together
	
	RunConsoleCommand( "_ulib_command", args  )
end

local function rcvAutocomplete( um )
	local command = um:ReadString()
	local autocomplete = um:ReadString()
	
	local fn = ULib.findVar( autocomplete )

	ULib.concommand( command, ULib.redirect, fn )
end
usermessage.Hook( "ULib_autocomplete", rcvAutocomplete )