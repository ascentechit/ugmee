
require("hook")

// Globals that we need 
local gmod 		= gmod
local pairs 	= pairs
local Msg 		= Msg
local hook 		= hook
local table		= table


/*---------------------------------------------------------
   Name: gamemode
   Desc: A module to manage gamemodes
---------------------------------------------------------*/
module("gamemode")

local GameList = {}

/*---------------------------------------------------------
   Name: RegisterGamemode( table, string )
   Desc: Used to register your gamemode with the engine
---------------------------------------------------------*/
function Register( t, name, derived )

	local CurrentGM = gmod.GetGamemode()
	
	// Is this already registered
	// If we're reloading we want to keep any data
	if ( Get( name ) != nil && CurrentGM != nil ) then
		t = table.Inherit( t, CurrentGM )
	end

	// This gives the illusion of inheritence
	if ( name != "base" ) then
		Msg("Registering gamemode '".. name .."' derived from '".. derived .."'\n")
		t = table.Inherit( t, Get( derived ) )
	end

	GameList[ name ] = t	

end

/*---------------------------------------------------------
   Name: Get( string )
   Desc: Get a gamemode by name.
---------------------------------------------------------*/
function Get( name )
	return GameList[ name ]
end

/*---------------------------------------------------------
   Name: Call( name, args )
   Desc: Calls a gamemode function
---------------------------------------------------------*/
function Call( name, ... )

	local CurrentGM = gmod.GetGamemode()
	
	// If the gamemode function doesn't exist just return false
	if (CurrentGM && CurrentGM[ name] == nil) then return false end
	
	return hook.Call( name, CurrentGM, ... )
	
end

