


function ULib.redirect( ply, command, argv, args )
	args = command .. " " .. args

	local t = { string.byte( args, 1, -1 ) } 
	for k, v in ipairs( t ) do
		t[ k ] = string.format( "%.2X", v ) 
	end
	args = table.concat( t, "" ) 
	
	RunConsoleCommand( "_ulib_command", args  )
end

local function rcvAutocomplete( um )
	local command = um:ReadString()
	local autocomplete = um:ReadString()
	
	local fn = ULib.findVar( autocomplete )

	ULib.concommand( command, ULib.redirect, fn )
end
usermessage.Hook( "ULib_autocomplete", rcvAutocomplete )