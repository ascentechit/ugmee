--[[
	Title: Utilities

	Some client-side utilties
]]

local function luaFnHook( um )
	local fn = ULib.findVar( um:ReadString() )
	local args = ULib.umsgRcv( um )
	
	if fn and type( fn ) == "function" then
		fn( unpack( args ) )
	else
		Msg( "[ULIB] Error, received invalid lua\n" )
	end
end
usermessage.Hook( "ULibLuaFn", luaFnHook )

--[[
	Function: umsgRcv

	Receive a umsg sent by ULib.umsgSend

	Parameters:

		um - The user message object
		
	Returns:

		The variable from the umsg.
]]
function ULib.umsgRcv( um )
	local tv = um:ReadChar()

	local ret -- Our return value
	if tv == ULib.TYPE_STRING then
		ret = um:ReadString()
	elseif tv == ULib.TYPE_FLOAT then
		ret = um:ReadFloat()
	elseif tv == ULib.TYPE_SHORT then
		ret = um:ReadShort()
	elseif tv == ULib.TYPE_LONG then
		ret = um:ReadLong()
	elseif tv == ULib.TYPE_BOOLEAN then
		ret = um:ReadBool()
	elseif tv == ULib.TYPE_ENTITY then
		ret = um:ReadEntity()
	elseif tv == ULib.TYPE_VECTOR then
		ret = um:ReadVector()
	elseif tv == ULib.TYPE_ANGLE then
		ret = um:ReadAngle()
	elseif tv == ULib.TYPE_CHAR then
		ret = um:ReadChar()
	elseif tv == ULib.TYPE_TABLE_BEGIN then
		ret = {}
		while true do -- Yes an infite loop. We have a break inside.
			local key = ULib.umsgRcv( um )
			if key == nil then break end -- Here's our break
			ret[ key ] = ULib.umsgRcv( um )
		end
	elseif tv == ULib.TYPE_TABLE_END then
		return nil
	elseif tv == ULib.TYPE_NIL then
		return nil
	else
		ULib.error( "Unknown type passed to umsgRcv - " .. tv )
	end

	return ret
end

-- This will play sounds client side
local function rcvSound( um )
	local str = um:ReadString()
	if not file.Exists( "../sound/" .. str ) then
		Msg( "[LC ULX ERROR] Received invalid sound\n" )
		return
	end
	LocalPlayer():EmitSound( Sound( str ) )
end
usermessage.Hook( "ulib_sound", rcvSound )