--[[
	Title: Utilities

	Some utility functions. Unlike the functions in misc.lua, this file only holds HL2 specific functions.
]]


--[[
	Function: execFile

	Executes a file on the console. Use this instead of the "exec" command when the config lies outside the cfg folder.

	Parameters:

        	f - The file, relative to the data folder.
		ply - The player to execute on. Leave nil to execute on server. (Ignores this param on client)

	Returns:

		The string of the serialized variable
]]
function ULib.execFile( f, ply )
	if not file.Exists( f ) then
		ULib.error( "Called execFile with invalid file! " .. file )
		return
	end

	local f = ULib.stripComments( file.Read( f ), "//" )
	local lines = string.Explode( "\n", f )

	for _, line in ipairs( lines ) do
		line = string.Trim( line )
		if line ~= "" then
			if SERVER then
				if not ply then
					ULib.consoleCommand( line .. "\n" )
				else
					ply:ConCommand( line .. "\n" )
				end
			else
				RunConsoleCommand( unpack( ULib.splitArgs( line ) ) )
			end
		end
	end
end


--[[
	Function: serialize

	Serializes a variable. It basically converts a variable into a runnable code string. It works correctly with inline tables.

	Parameters:

		v - The variable you wish to serialize

	Returns:

		The string of the serialized variable
]]
function ULib.serialize( v )
	local t = type( v )
	local str
	if t == "string" then
		str = string.format( "%q", v )
	elseif t == "boolean" or t == "number" then
		str = tostring( v )
	elseif t == "table" then
		str = table.ToString( v )
	elseif t == "Vector" then
		str = "Vector(" .. v.x .. "," .. v.y .. "," .. v.z .. ")"
	elseif t == "Angle" then
		str = "Angle(" .. v.pitch .. "," .. v.yaw .. "," .. v.roll .. ")"
	elseif t == "table" then
		str = table.ToString( v )
	elseif t == "nil" then
		str = "nil"
	else
		ULib.error( "Passed an invalid parameter to serialize! (type: " .. t .. ")" )
		return
	end
	return str
end


--[[
	Function: findVar

	Given a string, find a var starting from the global namespace. This will correctly parse tables. IE, "ULib.serialize".

	Parameters:

		var - The variable you wish to find

	Returns:

		The variable or nil
]]
function ULib.findVar( var )
	local loc = string.Explode( ".", var )
	local x = _G
	for _, v in ipairs( loc ) do
		x = x[ v ]
		if not x then return end
	end

	return x
end


--[[
	Function: isSandbox

	Returns true if the current gamemode is sandbox or is derived from sandbox.
]]
function ULib.isSandbox()
	local cur = GAMEMODE
	while cur do
		if cur.Name:lower() == "sandbox" then
			return true
		end
		cur = cur.BaseClass
	end
end


--[[
	Function: filesInDir

	Returns files in directory.

	Parameters:

		dir - The dir to look for files in.
		recurse - *(Optional, defaults to false)* If true, searches directories recursively.
		root - *INTERNAL USE ONLY* This helps with recursive functions.

	Revisions:

		v2.10 - Initial (But dragged over from GM9 archive)
]]
local function filesInDir( dir, recurse, root )
	if not file.IsDir( dir ) then
		return nil
	end

	local files = {}
	local relDir
	if root then
		relDir = dir:gsub( root .. "[\\/]", "" )
	end
	root = root or dir

	local result = file.Find( dir .. "./*" )

	for i=1, #result do
		if file.IsDir( dir .. "./" .. result[ i ] ) and recurse then
			files = table.Add( files, filesInDir( dir .. "/" .. result[ i ], recurse, root ) )
		else
			if not relDir then
				table.insert( files, result[ i ] )
			else
				table.insert( files, relDir .. "/" .. result[ i ] )
			end
		end
	end

	return files
end
