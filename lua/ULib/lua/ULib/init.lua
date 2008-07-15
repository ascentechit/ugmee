if not ULib then
	ULib = {}
	
	if file.Exists( "../lua/includes/modules/gm_ulib.dll" ) then
		require( "ulib" ) -- Lua engine load
		if not ULib.pluginLoaded() then -- It stays loaded across maps so use this to check
			game.ConsoleCommand( "plugin_load ../../../gmodbeta2007/lua/includes/modules/gm_ulib\n" ) -- So we don't have to bother with a .vdf file
		end
	end
	
	if not ULib.consoleCommand then ULib.consoleCommand = game.ConsoleCommand end -- In case they remove our module or it doesn't load

	Msg( "///////////////////////////////\n" )
	Msg( "//      Ulysses Library      //\n" )
	Msg( "///////////////////////////////\n" )
	Msg( "// Loading...                //\n" )

	Msg( "//  shared/defines.lua       //\n" )
	include( "ULib/shared/defines.lua" )
	Msg( "//  server/hook.lua          //\n" )
	include( "ULib/server/hook.lua" )
	Msg( "//  server/gamemode_hooks.lua//\n" )
	include( "ULib/server/gamemode_hooks.lua" )	
	Msg( "//  shared/misc.lua          //\n" )
	include( "ULib/shared/misc.lua" )
	Msg( "//  shared/util.lua          //\n" )
	include( "ULib/shared/util.lua" )
	Msg( "//  shared/table.lua         //\n" )
	include( "ULib/shared/tables.lua" )
	Msg( "//  shared/player.lua        //\n" )
	include( "ULib/shared/player.lua" )
	Msg( "//  server/player.lua        //\n" )
	include( "ULib/server/player.lua" )
	Msg( "//  shared/messages.lua      //\n" )
	include( "ULib/shared/messages.lua" )
	Msg( "//  shared/concommand.lua    //\n" )
	include( "ULib/shared/concommand.lua" )
	Msg( "//  server/concommand.lua    //\n" )
	include( "ULib/server/concommand.lua" )
	Msg( "//  server/util.lua          //\n" )
	include( "ULib/server/util.lua" )
	Msg( "//  shared/sh_ucl.lua        //\n" )
	include( "ULib/shared/sh_ucl.lua" )
	Msg( "//  server/ucl.lua           //\n" )
	include( "ULib/server/ucl.lua" )
	Msg( "//  server/phys.lua          //\n" )
	include( "ULib/server/phys.lua" )
	Msg( "//  server/player_ext.lua    //\n" )
	include( "server/player_ext.lua" )
	Msg( "//  server/entity_ext.lua    //\n" )
	include( "server/entity_ext.lua" )
	Msg( "// Load Complete!            //\n" )
	Msg( "///////////////////////////////\n" )

	AddCSLuaFile( "ULib/cl_init.lua" )
	AddCSLuaFile( "autorun/ulib_init.lua" )
	if not ULib.DEVELOPER_MODE then
		local folder = "ULib/_cl_" .. string.format( "%.2f", ULib.VERSION )
		local files = file.FindInLua( folder .. "/" .. "*.lua" )
		for _, file in ipairs( files ) do
			if file ~= "_generator.lua" then
				AddCSLuaFile( folder .. "/" .. file )
			end
		end
	else
		local folder = "ULib/shared"
		local files = file.FindInLua( folder .. "/" .. "*.lua" )
		for _, file in ipairs( files ) do
			AddCSLuaFile( folder .. "/" .. file )
		end
		
		local folder = "ULib/client"
		local files = file.FindInLua( folder .. "/" .. "*.lua" )
		for _, file in ipairs( files ) do
			AddCSLuaFile( folder .. "/" .. file )
		end
	end

	--Shared modules
	local files = file.FindInLua( "ULib/modules/*.lua" )
	if #files > 0 then
		for _, file in ipairs( files ) do
			Msg( "[ULIB] Loading SHARED module: " .. file .. "\n" )
			include( "ULib/modules/" .. file )
			AddCSLuaFile( "ULib/modules/" .. file )
		end
	end
	
	--Server modules
	local files = file.FindInLua( "ULib/modules/server/*.lua" )
	if #files > 0 then
		for _, file in ipairs( files ) do
			Msg( "[ULIB] Loading SERVER module: " .. file .. "\n" )
			include( "ULib/modules/server/" .. file )
		end
	end
	
	--Client modules
	local files = file.FindInLua( "ULib/modules/client/*.lua" )
	if #files > 0 then
		for _, file in ipairs( files ) do
			Msg( "[ULIB] Loading CLIENT module: " .. file .. "\n" )
			AddCSLuaFile( "ULib/modules/client/" .. file )
		end
	end	

	local function openULib( ply )
		umsg.Start( "ulib_init", ply )
			umsg.Float( ULib.VERSION )
			umsg.Bool( ULib.DEVELOPER_MODE )
		umsg.End()
	end
	hook.Add( "ULibPlayerReady", "OpenULib", openULib )
	-- We use ULibPlayerReady instead of ULibPlayerLoaded
	-- because otherwise when clULibLoaded (below) is 
	-- called from a listen server, the ply is nil.
	
	local function clReady( ply )
		gamemode.Call( "ULibPlayerReady", ply )
	end
	concommand.Add( "ulib_cl_ready", clReady ) -- Called when the c-side player object is ready
	
	local function clULibLoaded( ply )
		gamemode.Call( "ULibPlayerULibLoaded", ply )
	end
	concommand.Add( "ulib_cl_ulib_loaded", clULibLoaded ) -- Called when they've initialized the c-side ULib	
	
	local function clLoaded( ply )
		gamemode.Call( "ULibPlayerLoaded", ply )
	end
	concommand.Add( "ulib_cl_loaded", clLoaded ) -- Called when they've initialized the c-side lua
end

--[[hook.Add( "Initialize", "ULibNameFix", function()
	local meta = FindMetaTable( "Player" )
	function meta:Nick() return self:GetInfo( "name" ) end
end )
]]