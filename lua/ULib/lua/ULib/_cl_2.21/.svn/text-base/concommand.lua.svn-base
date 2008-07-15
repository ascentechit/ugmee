



ULib.subconcommands = {}



ULib.autocompletes = {}

local reroute 
if SERVER then
	reroute = function ( ply, command, argv, args )
		if ply:IsValid() then 
			ply:ConCommand( string.format( "%s %s\n", command, args ) )
			return
		end

		ULib.consoleCommand( "_" .. command .. " " .. args .. "\n" )
	end
end



function ULib.concommand( command, fn_call, autocomplete, groups )
	command = command:lower()
	groups = groups or ULib.ACCESS_ALL
	if SERVER then ULib.ucl.registerAccess( command, groups ) end

	local fn = function ( ply, command, argv ) 
		if ULib.autocompletes[ command:sub( 2 ) ] then command = command:sub( 2 ) end 

		local args = ""
		for k, v in ipairs( argv ) do
			if string.find( argv[ k ], "%s" ) then
				args = args .. "\"" .. argv[ k ] .. "\" "
			else
				args = args .. argv[ k ] .. " "
			end
		end
		args = string.Trim( args ) 

		args = args:gsub( " : ", ":" ) 
		args = args:gsub( " ' ", "'" ) 
		argv = ULib.splitArgs( args ) 

		if SERVER and not ULib.ucl.query( ply, command ) then
			ULib.tsay( ply, "You do not have access to this command, " .. ply:Nick() .. "." ) 
			return
		end
		PCallError( fn_call, ply, command, argv, args )
	end

	if autocomplete and SERVER and type( autocomplete ) == "string" then
		concommand.Add( "_" .. command, fn )
		if isDedicatedServer() then 
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



function ULib.begin_subconcommand( prefix, fn_call, autocomplete, groups )
	groups = groups or ULib.ACCESS_ALL
	local prefix_list = string.Explode( " ", prefix )
	local num = #prefix_list
	local t = ULib.subconcommands
	for i=1, num - 1 do 
		t = ULib.subconcommands[ prefix_list[ i ] ]
		if not t then
			ULib.error( "Recursive subcommands with prefixes that don't exist!" )
			return
		end
	end
	t[ prefix_list[ num ] ] = {}
	t = t[ prefix_list[ num ] ] 

	local f = function ( ply, command, argv, args ) 
		if argv[ 1 ] and t[ argv[ 1 ]:lower() ] then 
			local info = t[ argv[ 1 ]:lower() ]
			command = command .. " " .. argv[ 1 ]:lower()

			if not ULib.ucl.query( ply, command ) then
				ULib.tsay( ply, "You do not have access to this command, " .. ply:Nick() .. "." )
				
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
			PCallError( fn_call, ply, command, argv, args ) 
		end
	end

	if num == 1 then 
		return ULib.concommand( prefix, f, autocomplete, groups )
	else
		return ULib.add_subconcommand( table.concat( prefix_list, " ", 1, num - 1 ), prefix_list[ num ], f, groups )
	end
end



function ULib.add_subconcommand( prefix, command, fn_call, groups )
	command = command:lower()
	groups = groups or ULib.ACCESS_ALL
	if SERVER then ULib.ucl.registerAccess( prefix .. " " .. command, groups ) end

	local prefix_list = string.Explode( " ", prefix )
	local num = #prefix_list
	local t = ULib.subconcommands

	for i=1, num do 
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