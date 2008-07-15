local function initULib( um )
	ULib = { VERSION=um:ReadFloat(), DEVELOPER_MODE=um:ReadBool() }

	if not ULib.DEVELOPER_MODE then
		local folder = "ULib/_cl_" .. string.format( "%.2f", ULib.VERSION )
		include( folder .. "/defines.lua" )
		include( folder .. "/misc.lua" )
		include( folder .. "/util.lua" )
		include( folder .. "/tables.lua" )
		include( folder .. "/messages.lua" )
		include( folder .. "/player.lua" )
		include( folder .. "/cl_util.lua" )
		include( folder .. "/autocomplete.lua" )
		include( folder .. "/draw.lua" )
		include( folder .. "/concommand.lua" )
		include( folder .. "/sh_ucl.lua" )
	else
		include( "ULib/shared/defines.lua" )
		include( "ULib/shared/misc.lua" )
		include( "ULib/shared/util.lua" )
		include( "ULib/shared/tables.lua" )
		include( "ULib/shared/messages.lua" )
		include( "ULib/shared/player.lua" )
		include( "ULib/client/cl_util.lua" )
		include( "ULib/client/autocomplete.lua" )
		include( "ULib/client/draw.lua" )
		include( "ULib/shared/concommand.lua" )
		include( "ULib/shared/sh_ucl.lua" )
	end

	Msg( string.format( "This server is running ULib version %.2f.\n", ULib.VERSION ) )
	
	--Shared modules
	local files = file.FindInLua( "ULib/modules/*.lua" )
	if #files > 0 then
		for _, file in ipairs( files ) do
			Msg( "[ULIB] Loading SHARED module: " .. file .. "\n" )
			include( "ULib/modules/" .. file )
		end
	end
	
	--Client modules
	local files = file.FindInLua( "ULib/modules/client/*.lua" )
		if #files > 0 then
			for _, file in ipairs( files ) do
				Msg( "[ULIB] Loading CLIENT module: " .. file .. "\n" )
				include( "ULib/modules/client/" .. file )
			end
		end	
	
	RunConsoleCommand( "ulib_cl_ulib_loaded" )	
end
usermessage.Hook( "ulib_init", initULib )

function onEntCreated( ent )
	if LocalPlayer():IsValid() then -- LocalPlayer was created and is valid now
		LocalPlayer():ConCommand( "ulib_cl_ready\n" )
		hook.Remove( "OnEntityCreated", "ULibLocalPlayerCheck" )
	end
end
hook.Add( "OnEntityCreated", "ULibLocalPlayerCheck", onEntCreated ) -- Flag server when we created LocalPlayer()

RunConsoleCommand( "ulib_cl_loaded" )