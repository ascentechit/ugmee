
local Msg 		= Msg
local table 	= table
local pairs 	= pairs
local pcall		= pcall

/*---------------------------------------------------------
   Name: cvar
   Desc: Callbacks when cvars change
---------------------------------------------------------*/
module( "cvars" )

local ConVars = {}


/*---------------------------------------------------------
   Name: GetConVarCallbacks
---------------------------------------------------------*/
function GetConVarCallbacks( name, CreateIfNotFound )

	local Tab = ConVars[ name ]

	if ( CreateIfNotFound && !Tab ) then
		Tab = {}
		ConVars[ name ] = Tab
	end

	return Tab
end

/*---------------------------------------------------------
   Name: OnConVarChanged
   Desc: Called by the engine
---------------------------------------------------------*/
function OnConVarChanged( name, oldvalue, newvalue )

	local Callbacks = GetConVarCallbacks( name )
	if (!Callbacks) then return end
	
	for k, v in pairs( Callbacks ) do
	
		pcall( v, name, oldvalue, newvalue )
	
	end

end


/*---------------------------------------------------------
   Name: OnConvarChanged
   Desc: Called by the engine
---------------------------------------------------------*/
function AddChangeCallback( name, func )

	local tab = GetConVarCallbacks( name, true )
	table.insert( tab, func )

end


