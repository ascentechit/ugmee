
// Please don't edit this file!

// Redirect call from the engine to the module (todo: change engine)
function engineConsoleCommand( player, command, arguments )
	return concommand.Run( player, command, arguments )
end


function engineCommandComplete( command, arguments )
	return concommand.AutoComplete( command, arguments )
end



local AddConsoleCommand = AddConsoleCommand
local string = string


/*---------------------------------------------------------
   Name: concommand
   Desc: A module to take care of the registration and calling
         of Lua console commands.
---------------------------------------------------------*/
module("concommand")

local CommandList 	= {}
local CompleteList 	= {}


/*---------------------------------------------------------
   Name: concommand.Add( name, func, completefunc )
   Desc: Register a new console command
---------------------------------------------------------*/
function Add( name, func, completefunc )
	local LowerName = string.lower( name )
	CommandList[ LowerName ] = func
	CompleteList[ LowerName ] = completefunc
	AddConsoleCommand( name )
end

/*---------------------------------------------------------
   Name: concommand.Remove( name )
   Desc: Removes a console command
---------------------------------------------------------*/
function Remove( name )
	local LowerName = string.lower( name )
	CommandList[ LowerName ] = nil
	CompleteList[ LowerName ] = nil
end


/*---------------------------------------------------------
   Name: concommand.Run( )
   Desc: Called by the engine when an unknown console command is run
---------------------------------------------------------*/
function Run( player, command, arguments )

	local LowerCommand = string.lower( command )

	if ( CommandList[ LowerCommand ] != nil ) then
		CommandList[ LowerCommand ]( player, command, arguments )
		return true
	end

	if ( player:IsValid() ) then
		player:ChatPrint( "Unknown Command: '" .. command .. "'\n" )
	end
	
	return false;
end

/*---------------------------------------------------------
   Name: concommand.AutoComplete( )
   Desc: Returns a table for the autocompletion
---------------------------------------------------------*/
function AutoComplete( command, arguments )

	local LowerCommand = string.lower( command )

	if ( CompleteList[ LowerCommand ] != nil ) then
		return CompleteList[ LowerCommand ]( command, arguments )
	end
	
end

