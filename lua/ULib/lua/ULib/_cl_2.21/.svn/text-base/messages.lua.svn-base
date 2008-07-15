



function ULib.tsay( ply, msg, wait, wasValid )
	if wait then timer.Simple( FrameTime()*0.5, ULib.tsay, ply, msg, false, ply and ply:IsValid() ) return end 

	if SERVER and ply and not ply:IsValid() then 
		if wasValid then 
			return
		end		
		Msg( msg .. "\n" )
		return
	end

	if CLIENT then
		LocalPlayer():ChatPrint( msg ) 
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



function ULib.error( s )
	if CLIENT then
		Msg( "[LC ULIB ERROR] " .. s .. "\n" )
	else
		Msg( "[LS ULIB ERROR] " .. s .. "\n" )
	end
end



function ULib.debugFunctionCall( name, ... )
	local args = { ... }

        Msg( "Function '" .. name .. "' called. Parameters:\n" )
	for k, v in ipairs( args ) do
		local value = ULib.serialize( v )
		Msg( "[PARAMETER " .. k .. "]: Type=" .. type( v ) .. "\tValue=(" .. value .. ")\n" )
	end
end