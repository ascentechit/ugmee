

/*---------------------------------------------------------
    To easily create a colour table
---------------------------------------------------------*/
function Color( r, g, b, a )

	a = a or 255
	return { r = tonumber(r), g = tonumber(g), b = tonumber(b), a = tonumber(a) }
	
end

/*---------------------------------------------------------
	Prints a table to the console
---------------------------------------------------------*/
function PrintTable ( t, indent, done )

	done = done or {}
	indent = indent or 0

	for key, value in pairs (t) do

		Msg ( string.rep ("\t", indent) )

		if type (value) == "table" and not done [value] then

	      		done [value] = true
	      		Msg (tostring (key) .. ":" .. "\n");
	     		PrintTable (value, indent + 2, done)

	    	else

	      		Msg (tostring (key) .. "\t=\t")
	      		Msg (tostring(value) .. "\n")

	    	end

	end

end


/*---------------------------------------------------------
   Returns a random vector
---------------------------------------------------------*/
function VectorRand()

	return Vector( math.Rand(-1.0, 1.0), math.Rand(-1.0, 1.0), math.Rand(-1.0, 1.0) )
end



/*---------------------------------------------------------
   Convenience function to precache a sound
---------------------------------------------------------*/
function Sound( name )
	util.PrecacheSound( name )
	return name
end


/*---------------------------------------------------------
   Convenience function to precache a model
---------------------------------------------------------*/
function Model( name )
	util.PrecacheModel( name )
	return name
end


// Some nice globals so we don't keep creating objects for no reason

vector_origin 		= Vector( 0, 0, 0 )
vector_up	 		= Vector( 0, 0, 1 )

color_white 		= Color( 255, 	255, 	255, 	255 )
color_black 		= Color( 0, 	0, 		0, 		255 )
color_transparent 	= Color( 255, 	255, 	255, 	0 )


/*---------------------------------------------------------
   For shared files. Includes the file if clientside, 
   marks for send it if serverside.
---------------------------------------------------------*/
function IncludeClientFile( filename )
	
	if ( CLIENT ) then
		include( filename )
	else
		AddCSLuaFile( filename )
	end
	
end

// Globals..
FORCE_STRING 	= 1
FORCE_NUMBER 	= 2
FORCE_BOOL		= 3

/*---------------------------------------------------------
   AccessorFunc
   Quickly make Get/Set accessor fuctions on the specified table
---------------------------------------------------------*/
function AccessorFunc( tab, varname, name, iForce )

	tab[ "Get"..name ] = function ( self ) return self[ varname ] end

	if ( iForce == FORCE_STRING ) then
		tab[ "Set"..name ] = function ( self, v ) self[ varname ] = tostring(v) end
	return end
	
	if ( iForce == FORCE_NUMBER ) then
		tab[ "Set"..name ] = function ( self, v ) self[ varname ] = tonumber(v) end
	return end
	
	if ( iForce == FORCE_BOOL ) then
		tab[ "Set"..name ] = function ( self, v ) self[ varname ] = tobool(v) end
	return end
	
	tab[ "Set"..name ] = function ( self, v ) self[ varname ] = v end

end

/*---------------------------------------------------------
   AccessorFuncNW - FOR ENTITIES ONLY
   Quickly make Get/Set accessor fuctions on the specified entity
---------------------------------------------------------*/
function AccessorFuncNW( tab, varname, name, varDefault, iForce )

	tab[ "Get"..name ] = function ( self ) return self:GetNetworkedVar( varname, varDefault ) end

	if ( iForce == FORCE_STRING ) then
		tab[ "Set"..name ] = function ( self, v ) self:SetNetworkedVar( varname, tostring(v) ) end
	return end
	
	if ( iForce == FORCE_NUMBER ) then
		tab[ "Set"..name ] = function ( self, v ) self:SetNetworkedVar( varname, tonumber(v) ) end
	return end
	
	if ( iForce == FORCE_BOOL ) then
		tab[ "Set"..name ] = function ( self, v ) self:SetNetworkedVar( varname, tobool(v) ) end
	return end
	
	tab[ "Set"..name ] = function ( self, v ) self:SetNetworkedVar( varname, v ) end

end

/*---------------------------------------------------------
    Returns true if object is valid (is not nil and IsValid)
---------------------------------------------------------*/
function IsValid( object )

	if (!object) then return false end
	return object:IsValid()	
	
end

/*---------------------------------------------------------
    Returns true if entity is valid
---------------------------------------------------------*/
ValidEntity = IsValid


/*---------------------------------------------------------
    Utility function, automatically prints error
---------------------------------------------------------*/
function PCallError( ... )

	local errored, retval = pcall( unpack( arg ) )
	
	if ( !errored ) then
		ErrorNoHalt( retval )
		return false, retval
	end
	
	return true, retval
	
end

/*---------------------------------------------------------
    Safely remove an entity
---------------------------------------------------------*/
function SafeRemoveEntity( ent )

	if ( !ent || !ent:IsValid() || ent:IsPlayer() ) then return end
	
	ent:Remove()
	
end

/*---------------------------------------------------------
    Safely remove an entity (delayed)
---------------------------------------------------------*/
function SafeRemoveEntityDelayed( ent, timedelay )

	if (!ent || !ent:IsValid()) then return end
	
	timer.Simple( timedelay, function() SafeRemoveEntity( ent ) end )
	
end

/*---------------------------------------------------------
    Simple lerp
---------------------------------------------------------*/
function Lerp( delta, from, to )

	if ( delta > 1 ) then return to end
	if ( delta < 0 ) then return from end
	
	return from + (to - from) * delta;

end

/*---------------------------------------------------------
    Convert Var to Bool
---------------------------------------------------------*/
function tobool( val )
	if ( val == nil || val == false || val == 0 || val == "0" || val == "false" ) then return false end
	return true
end

/*---------------------------------------------------------
    Universal function to filter out crappy models by name
---------------------------------------------------------*/
function UTIL_IsUselessModel( modelname ) 

	local modelname = modelname:lower()

	if ( modelname:find( "_gesture" ) ) then return true end
	if ( modelname:find( "_anim" ) ) then return true end
	if ( modelname:find( "_gst" ) ) then return true end
	if ( modelname:find( "_pst" ) ) then return true end
	if ( modelname:find( "_shd" ) ) then return true end
	if ( modelname:find( "_ss" ) ) then return true end
	if ( modelname:find( "_posture" ) ) then return true end
	if ( modelname:find( "_anm" ) ) then return true end
	if ( modelname:find( "ghostanim" ) ) then return true end
	if ( modelname:find( "_paths" ) ) then return true end
	if ( modelname:find( "_shared" ) ) then return true end
	
	return false

end


/*---------------------------------------------------------
    Remember/Restore cursor position..
	Clientside only
	If you have a system where you hold a key to show the cursor
	Call RememberCursorPosition when the key is released and call
	RestoreCursorPosition to restore the cursor to where it was
	when the key was released.
	If you don't the cursor will appear in the middle of the screen
---------------------------------------------------------*/
local StoredCursorPos = {}

function RememberCursorPosition()

	local x, y = gui.MousePos()
	
	// If the cursor isn't visible it will return 0,0 ignore it.
	if ( x == 0 && y == 0 ) then return end
	
	StoredCursorPos.x, StoredCursorPos.y = x, y
	
end

function RestoreCursorPosition()

	if ( !StoredCursorPos.x || !StoredCursorPos.y ) then return end
	input.SetCursorPos( StoredCursorPos.x, StoredCursorPos.y )

end


/*---------------------------------------------------------
    Given a number, returns the right 'th
---------------------------------------------------------*/
function STNDRD( num )

	if ( num == 1 ) then return "st" end
	if ( num == 2 ) then return "nd" end
	if ( num == 3 ) then return "rd" end
	
	return "th"

end
