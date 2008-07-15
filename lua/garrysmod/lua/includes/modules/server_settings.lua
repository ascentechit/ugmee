
local Msg 				= Msg
local file 				= file
local util 				= util
local pairs				= pairs
local CreateConVar		= CreateConVar
local ConVarExists		= ConVarExists
local GetConVarNumber 	= GetConVarNumber 
local FCVAR_NOTIFY		= FCVAR_NOTIFY

/*---------------------------------------------------------

	Basic Convar Accessor. Pretty defunc.
   
---------------------------------------------------------*/

module("server_settings")


/*---------------------------------------------------------
   Returns int server setting
---------------------------------------------------------*/
function Int( name, default )

	if ( !ConVarExists( name ) ) then return default end

	return GetConVarNumber( name )

end

/*---------------------------------------------------------
   Returns boolean server setting
---------------------------------------------------------*/
function Bool( name, default )

	if (default) then default = 1 else default = 0 end

	return Int( name, default ) != 0

end
