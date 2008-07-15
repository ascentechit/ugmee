--[[
	Title: Hook

	This overrides garry's default hook system. We need this better hook system for any serious development.
	We're implementing hook priorities. hook.Add() now takes an additional parameter of type number between -20 and 20.
	0 is default (so we remain backwards compatible). -20 and 20 are read only (ignores returned values). 
	Hooks are called in order from -20 on up.
]]


-- Globals that we are going to use
local pairs = pairs
local unpack = unpack
local ErrorNoHalt = ErrorNoHalt
local pcall = pcall
local tostring = tostring
local concommand = concommand
local PrintTable = PrintTable
local CLIENT = CLIENT
local type = type

-- Grab all previous hooks from the pre-existing hook module.
local OldHooks = hook.GetTable()

-----------------------------------------------------------
--   Name: hook
--   Desc: For scripts to hook onto Gamemode events
-----------------------------------------------------------
module( "hook" )


-- Local variables
local Hooks = {}


-- Exposed Functions

--[[
	Function: hook.GetTable

	Returns:

		The table filled with all the hooks
]]
function GetTable()
	return Hooks
end

--[[
	Function: hook.Add

	Our new and improved hook.Add function.
	Read the file description for more information on how the hook priorities work.

	Parameters:

		event_name - The name of the event (IE "PlayerInitialSpawn").
		name - The unique name of your hook.
			This is only so that if the file is reloaded, it can be unhooked (or you can unhook it yourself).
		func - The function callback to call
		priority - *(Optional, defaults to 0)* Priority from -20 to 20. Remember that -20 and 20 are read-only.
]]
function Add( event_name, name, func, priority )
	if not Hooks[ event_name ] then
		Hooks[ event_name ] = {}
		for i=-20, 20 do
			Hooks[ event_name ][ i ] = {}
		end
	end

	priority = priority or 0

	Hooks[ event_name ][ priority ][ name ] = func
	Hooks[ event_name ][ tostring( name ) ] = func -- Keep the classic style too so we won't break anything
end

--[[
	Function: hook.Remove

	Parameters:

		event_name - The name of the event (IE "PlayerInitialSpawn").
		name - The unique name of your hook. Use the same name you used in hook.Add()
]]
function Remove( event_name, name )
	for i=-20, 20 do
		if Hooks[ event_name ][ i ][ name ] then
			Hooks[ event_name ][ i ][ name ] = nil
		end
	end
	Hooks[ event_name ][ tostring( name ) ] = nil
end

--[[
	Function: hook.Call

	Normally, you don't want to call this directly. Use gamemode.Call() instead.

	Parameters:

		name - The name of the event
		gm - The gamemode table
		... - Any other params to pass
]]
function Call( name, gm, ... )

	local b, retval
	local HookTable = Hooks[ name ]

	if HookTable then
		for i=-20, 20 do
			for k, v in pairs( HookTable[ i ] ) do
				if not v then
					ErrorNoHalt( "ERROR: Hook '" .. tostring( k ) .. "' tried to call a nil function!\n" )
					ErrorNoHalt( "Removing Hook '" .. tostring( k ) .. "'\n" )
					HookTable[ i ][ k ] = nil -- remove this hook
					break

				else
					-- Call hook function
					b, retval = pcall( v, unpack( arg ) )

					if not b then
							ErrorNoHalt( "ERROR: Hook '" .. tostring( k ) .. "' Failed: " .. tostring( retval ) .. "\n" )
							ErrorNoHalt( "Removing Hook '" .. tostring( k ) .. "'\n" )
							HookTable[ i ][ k ] = nil -- remove this hook

					else
						-- Allow hooks to override return values if it's within the limits (-20 and 20 are read only)
						if retval ~= nil and i > -20 and i < 20 then
							return retval
						end
					end
				end
			end
		end
	end

	local GamemodeFunction = gm[ name ]
	if not GamemodeFunction then return nil	end
	
	if ( type( GamemodeFunction ) ~= "function" ) then
		Msg( "Calling Non Function!? ", GamemodeFunction, "\n" )
	end	

	-- This calls the actual gamemode function - after all the hooks have had chance to override
	b, retval = pcall( GamemodeFunction, gm, unpack( arg ) )

	if not b then
		gm[ name .. "_ERRORCOUNT" ] = gm[ name .. "_ERRORCOUNT" ] or 0
		gm[ name .. "_ERRORCOUNT" ] = gm[ name .. "_ERRORCOUNT" ] + 1
		ErrorNoHalt( "ERROR: GAMEMODE:'" .. tostring( name ) .. "' Failed: " .. tostring( retval ) .. "\n" )

		return nil
	end

	return retval
end

--**************************************
--  DEBUG CONSOLE COMMAND FOR LUA CODERS
--**************************************

local function DumpHooks()
	PrintTable( Hooks )
end


if ( CLIENT ) then
	concommand.Add( "dump_hooks_cl", DumpHooks )
else
	concommand.Add( "dump_hooks", DumpHooks )
end

for event_name, t in pairs( OldHooks ) do
	for name, func in pairs( t ) do
		Add( event_name, name, func, 0 )
	end
end
