--[[
	Title: Messages

	Handles messaging like logging, debug, etc.
]]


--[[
	Function: tsay

	Prints a message in talk say as well as in the user's consoles.

	Parameters:

		ply - The player to print to, set to nil to send to everyone. (Ignores this param if called on client)
		msg - The message to print.
		wait - *(Optional, defaults to false)* Wait one frame before posting. (Useful to use from things like chat hooks)
		wasValid - *(INTERNAL USE ONLY)* This is flagged on waiting if the player *was* valid.
		
	Revisions:
	
		v2.10 - Initial
]]
function ULib.tsay( ply, msg, wait, wasValid )
	if wait then timer.Simple( FrameTime()*0.5, ULib.tsay, ply, msg, false, ply and ply:IsValid() ) return end -- Call next frame

	if SERVER and ply and not ply:IsValid() then -- Server console
		if wasValid then -- This means we had a valid player that left, so do nothing
			return
		end		
		Msg( msg .. "\n" )
		return
	end

	if CLIENT then
		LocalPlayer():ChatPrint( msg ) -- At the time of writing, this doesn't work. Let's hope it's fixed!
		LocalPlayer():EmitSound( Sound( "common/talk.wav" ) )
		return
	end

	if ply then
		ply:ChatPrint( msg )
		umsg.Start( "ulib_sound", ply )
			umsg.String( Sound( "common/talk.wav" ) )
		umsg.End()
	else
		local players = player.GetAll()
		for _, player in ipairs( players ) do
			player:ChatPrint( msg )
		end
		umsg.Start( "ulib_sound" )
			umsg.String( Sound( "common/talk.wav" ) )
		umsg.End()
	end
end


--[[
	Function: csay

	Prints a message in center of the screen as well as in the user's consoles.

	Parameters:

		ply - The player to print to, set to nil to send to everyone. (Ignores this param if called on client)
		msg - The message to print.
		color - *(Optional)* The amount of red to use for the text.
		duration - *(Optional)* The amount of time to show the text.
		fade - *(Optional, defaults to 0.5)* The length of fade time
		
	Revisions:
	
		v2.10 - Added fade parameter. Fixed it sending the message multiple times.
]]
function ULib.csay( ply, msg, color, duration, fade )
	if CLIENT then
		ULib.csayDraw( msg, color, duration )
		Msg( msg .. "\n" )
		return
	end

	if ply then
		ULib.sendLuaFunction( ply, "ULib.csayDraw", msg, color, duration, fade )
		ply:PrintMessage( HUD_PRINTCONSOLE, msg .. "\n" )
	else
		local players = player.GetAll()
		for _, ply in ipairs( players ) do
			ULib.sendLuaFunction( ply, "ULib.csayDraw", msg, color, duration, fade )
			ply:PrintMessage( HUD_PRINTCONSOLE, msg .. "\n" )
		end
	end
end


--[[
	Function: console

	Prints a message in the user's consoles.

	Parameters:

		ply - The player to print to, set to nil to send to everyone. (Ignores this param if called on client)
		msg - The message to print.
]]
function ULib.console( ply, msg )
	if CLIENT or (ply and not ply:IsValid()) then
		Msg( msg .. "\n" )
		return
	end

	if ply then
		ply:PrintMessage( HUD_PRINTCONSOLE, msg .. "\n" )
	else
		local players = player.GetAll()
		for _, player in ipairs( players ) do
			player:PrintMessage( HUD_PRINTCONSOLE, msg .. "\n" )
		end
	end
end


--[[
	Function: error

	Gives an error to console.

	Parameters:

		s - The string to use as the error message
]]
function ULib.error( s )
	if CLIENT then
		Msg( "[LC ULIB ERROR] " .. s .. "\n" )
	else
		Msg( "[LS ULIB ERROR] " .. s .. "\n" )
	end
end


--[[
	Function: debugFunctionCall

	Prints a function call, very useful for debugging.

	Parameters:

		name - The name of the function called
		... - all arguments to the function
]]
function ULib.debugFunctionCall( name, ... )
	local args = { ... }

        Msg( "Function '" .. name .. "' called. Parameters:\n" )
	for k, v in ipairs( args ) do
		local value = ULib.serialize( v )
		Msg( "[PARAMETER " .. k .. "]: Type=" .. type( v ) .. "\tValue=(" .. value .. ")\n" )
	end
end