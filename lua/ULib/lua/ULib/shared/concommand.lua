--[[
	Title: Concommand

	Has some functions to make concommands and variables easier.
]]


--[[
	Table: subconcommands

	Used to support sub concommands
]]
ULib.subconcommands = {}


--[[
	Table: autocompletes

	Used to hold autocompletes, to send to clients.
]]
ULib.autocompletes = {}

local reroute -- This function is for dedicated servers so they can use concommand using autocomplete
if SERVER then
	reroute = function ( ply, command, argv, args )
		if ply:IsValid() then -- exploit attempt, just route the command back to them.
			ply:ConCommand( string.format( "%s %s\n", command, args ) )
			return
		end

		ULib.consoleCommand( "_" .. command .. " " .. args .. "\n" )
	end
end


--[[
	Function: concommand

	This function helps you set up a ULib-controlled concommand.

	Parameters:

		command - The console command. IE, "ulx_kick".
		fn_call - The function to call when the command's called.
		autocomplete - The function to call for autocomplete.
			(*Server only:* If you specify a string of a client function for this parameter,
			ULib will use it for autocomplete. This is useful since autocomplete MUST be
			implemented client-side.)
		groups - *(Optional, defaults to ULib.ACCESS_ALL)* Either a string or table of groups that have default access.
			This is passed to <ULib.ucl.registerAccess()>. Only matters on the server
			
	Revisions:

		v2.10 - Added the parameter groups. Large internal access handling changes.			
]]
function ULib.concommand( command, fn_call, autocomplete, groups )
	command = command:lower()
	groups = groups or ULib.ACCESS_ALL
	if SERVER then ULib.ucl.registerAccess( command, groups ) end

	local fn = function ( ply, command, argv ) -- This function will handle the command callback
		if ULib.autocompletes[ command:sub( 2 ) ] then command = command:sub( 2 ) end -- Take off "_"

		local args = ""
		for k, v in ipairs( argv ) do
			if string.find( argv[ k ], "%s" ) then
				args = args .. "\"" .. argv[ k ] .. "\" "
			else
				args = args .. argv[ k ] .. " "
			end
		end
		args = string.Trim( args ) -- Remove that last space we added

		args = args:gsub( " : ", ":" ) -- Valve error correction.
		args = args:gsub( " ' ", "'" ) -- Valve error correction.
		argv = ULib.splitArgs( args ) -- We're going to go ahead and reparse argv to fix the errors.

		if SERVER and not ULib.ucl.query( ply, command ) then
			ULib.tsay( ply, "You do not have access to this command, " .. ply:Nick() .. "." ) -- Print their name to intimidate them :)
			return
		end
		PCallError( fn_call, ply, command, argv, args )
	end

	if autocomplete and SERVER and type( autocomplete ) == "string" then
		concommand.Add( "_" .. command, fn )
		if isDedicatedServer() then -- We need to add the normal command to deds
			ULib.concommand( command, reroute )
		end

		ULib.autocompletes[ command ] = { cl=autocomplete, sv=fn }
		local rp = RecipientFilter()
		rp:AddAllPlayers()
		umsg.Start( "ULib_autocomplete", rp )
			umsg.String( command )
 			umsg.String( autocomplete )
		umsg.End()
	else
		concommand.Add( command, fn, autocomplete )
	end
end


--[[
	Function: begin_subconcommand

	This function will help you set up subset concommands. For example, instead of using "ulx_kick", "ulx_slay", you may want to use a more conventional format like "ulx kick" and "ulx slay".
	This function helps you acheive that. Call <BEGIN_SUBCONCOMMAND()> first to define the "catch all" function if they specify an unknown parameter of the command by itself ( IE, "ulx" using the examples above ).
	Then, call <ADD_SUBCONCOMMAND()> to add the subconcommands.

	Parameters:

		prefix - The console command prefix. IE, "ulx".
		fn_call - The default function to call. This is the fallback if an unknown subcommand is passed, or no additional arguments.
		autocomplete - The function to call for autocomplete. *Only works for base subconcommands*.
			(*Server only:* If you specify a string of a client function for this parameter,
			ULib will use it for autocomplete. This is useful since autocomplete MUST be
			implemented client-side.)
		groups - *(Optional, defaults to ULib.ACCESS_ALL)* Either a string or table of groups that have default access.
			This is passed to <ULib.ucl.registerAccess()>. Only matters on the server
			
	Revisions:

		v2.10 - Added the parameter groups. Large internal access handling changes.
]]
function ULib.begin_subconcommand( prefix, fn_call, autocomplete, groups )
	groups = groups or ULib.ACCESS_ALL
	local prefix_list = string.Explode( " ", prefix )
	local num = #prefix_list
	local t = ULib.subconcommands
	for i=1, num - 1 do -- Get to the table list we need
		t = ULib.subconcommands[ prefix_list[ i ] ]
		if not t then
			ULib.error( "Recursive subcommands with prefixes that don't exist!" )
			return
		end
	end
	t[ prefix_list[ num ] ] = {}
	t = t[ prefix_list[ num ] ] -- This will make it easier to handle

	local f = function ( ply, command, argv, args ) -- This function will handle the command callback
		if argv[ 1 ] and t[ argv[ 1 ]:lower() ] then -- If the subcommand exists
			local info = t[ argv[ 1 ]:lower() ]
			command = command .. " " .. argv[ 1 ]:lower()

			if not ULib.ucl.query( ply, command ) then
				ULib.tsay( ply, "You do not have access to this command, " .. ply:Nick() .. "." )
				-- Print their name to intimidate them :)
				return
			end

			table.remove( argv, 1 )
			if not string.find( args, "%s" ) then
				args = ""
			else
				args = args:gsub( "^%S+%s+(.*)$", "%1" )
			end

			info.fn( ply, command, argv, args )
		else
			PCallError( fn_call, ply, command, argv, args ) -- Fallback on default function.
		end
	end

	if num == 1 then -- If it's not recursive
		return ULib.concommand( prefix, f, autocomplete, groups )
	else
		return ULib.add_subconcommand( table.concat( prefix_list, " ", 1, num - 1 ), prefix_list[ num ], f, groups )
	end
end


--[[
	Function: add_subconcommand

	See <begin_subconcommand()>.

	Parameters:

		prefix - The console command prefix. IE, "ulx".
		command - The subconcommand. IE, "kick" if you want something like "ulx kick" for the final command.
		fn_call - The function to call when the command's called.
		groups - *(Optional, defaults to ULib.ACCESS_ALL)* Either a string or table of groups that have default access.
			This is passed to <ULib.ucl.registerAccess()>. Only matters on the server
			
	Revisions:

		v2.10 - Added the parameter groups. Large internal access handling changes.			
]]
function ULib.add_subconcommand( prefix, command, fn_call, groups )
	command = command:lower()
	groups = groups or ULib.ACCESS_ALL
	if SERVER then ULib.ucl.registerAccess( prefix .. " " .. command, groups ) end

	local prefix_list = string.Explode( " ", prefix )
	local num = #prefix_list
	local t = ULib.subconcommands

	for i=1, num do -- Get to the table list we need
		t = t[ prefix_list[ i ] ]
		if not t then
			ULib.error( "Command doesn't exist!" )
			return
		end
	end

	t[ command ] = t[ command ] or {}
	t[ command ].fn = fn_call

	return true
end