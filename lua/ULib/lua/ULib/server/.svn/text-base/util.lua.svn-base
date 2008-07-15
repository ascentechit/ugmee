--[[
	Title: Utilities

	Has some useful server utilities
]]

--[[
	Function: sendLuaFunction

	Makes sending function calls a breeze. Will automatically quotes strings, tostring bools, etc.

	Parameters:

		ply - The player to send to, set to nil to send to everyone.
		fn - The function to call (Must be a string!)
		... - Any extra number of arguments.
]]
function ULib.sendLuaFunction( ply, fn, ... )
	if not ply or not ply:IsValid() then return end
	
	local args = { ... }
	umsg.Start( "ULibLuaFn", ply )
		umsg.String( fn )
		ULib.umsgSend( args )
	umsg.End()
end

--[[
	Function: umsgSend

	Makes sending umsgs a blast. You don't have to bother knowing what type you're sending, just use ULib.umsgRcv() on the client.

	Parameters:

		v - The type to send
]]
function ULib.umsgSend( v )
	local tv = type( v )

	if tv == "string" then
		umsg.Char( ULib.TYPE_STRING )
		umsg.String( v )
	elseif tv == "number" then
		if math.fmod( v, 1 ) ~= 0 then -- It's a float
			umsg.Char( ULib.TYPE_FLOAT )
			umsg.Float( v )
		else
			if v <= 127 and v >= -127 then
				umsg.Char( ULib.TYPE_CHAR )
				umsg.Char( v )
			elseif v < 32767 and v > -32768 then
				umsg.Char( ULib.TYPE_SHORT )
				umsg.Short( v )
			else
				umsg.Char( ULib.TYPE_LONG )
				umsg.Long( v )
			end
		end
	elseif tv == "boolean" then
		umsg.Char( ULib.TYPE_BOOLEAN )
		umsg.Bool( v )
	elseif tv == "Entity" or tv == "Player" then
		umsg.Char( ULib.TYPE_ENTITY )
		umsg.Entity( v )
	elseif tv == "Vector" then
		umsg.Char( ULib.TYPE_VECTOR )
		umsg.Vector( v )
	elseif tv == "Angle" then
		umsg.Char( ULib.TYPE_ANGLE )
		umsg.Angle( v )
	elseif tv == "table" then
		umsg.Char( ULib.TYPE_TABLE_BEGIN )
		for key, value in pairs( v ) do
			ULib.umsgSend( key )
			ULib.umsgSend( value )
		end
		umsg.Char( ULib.TYPE_TABLE_END )
	elseif tv == "nil" then
		umsg.Char( ULib.TYPE_NIL )
	else
		ULib.error( "Unknown type passed to umsgSend -- " .. tv )
	end
end


--[[
	Function: play3DSound

	Plays a 3D sound, the further away from the point the player is, the softer the sound will be.

	Parameters:

		sound - The sound to play, relative to the sound folder.
		vector - The point to play the sound at.
		volume - *(Optional, defaults to 1)* The volume to make the sound.
		pitch - *(Optional, defaults to 1)* The pitch to make the sound, 1 = normal.
]]
function ULib.play3DSound( sound, vector, volume, pitch )
	volume = volume or 100
	pitch = pitch or 100

	local ent = ents.Create( "info_null" )
	if not ent:IsValid() then return end
	ent:SetPos( vector )
	ent:Spawn()
	ent:Activate()
	ent:EmitSound( sound, volume, pitch )
end

--[[
	Function: nameCheck

	Checks all players' names at regular intervals to detect name changes. Calls ULibPlayerNameChanged if the name changed. *DO NOT CALL DIRECTLY*

	Revisions:
	
		2.20 - Initial
]]
function ULib.nameCheck()
	local players = player.GetAll()
	for _, ply in ipairs( players ) do
		if not ply.ULibLastKnownName then ply.ULibLastKnownName = ply:Nick() end
		
		if ply.ULibLastKnownName ~= ply:Nick() then
			gamemode.Call( "ULibPlayerNameChanged", ply, ply.ULibLastKnownName, ply:Nick() )
			ply.ULibLastKnownName = ply:Nick()
		end
	end
end
timer.Create( "ULibNameCheck", 3, 0, ULib.nameCheck )


--[[
	Function: isDedicatedServer

	The normal GM10 bind is broken, this fixes it.
]]
function isDedicatedServer() -- The normal GM10 function isn't working, let's define a hack
	return GetConVarString( "sensitivity" ) == "" -- This doesn't exist on a ded server, but exists on a listen server
end

local meta = FindMetaTable( "Player" )


-- Here's a quick patch so dedicated servers aren't spammed with messages about using IsListenServerHost()
if isDedicatedServer() then
	-- Return if there's nothing to add on to
	if not meta then return end

	function meta:IsListenServerHost()
	        return false
	end
end
