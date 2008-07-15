



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



function ULib.findVar( var )
	local loc = string.Explode( ".", var )
	local x = _G
	for _, v in ipairs( loc ) do
		x = x[ v ]
		if not x then return end
	end

	return x
end



function ULib.isSandbox()
	local cur = GAMEMODE
	while cur do
		if cur.Name:lower() == "sandbox" then
			return true
		end
		cur = cur.BaseClass
	end
end



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
