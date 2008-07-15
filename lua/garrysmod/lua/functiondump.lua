
// Outputs functions and stuff in wiki format

OUTPUT = ""

if ( SERVER ) then
	xside = file.Read( "ClientFunctions.txt" )
else
	xside = file.Read( "ServerFunctions.txt" )
end

xside = xside or ""

local function XSide( class, name )
	if ( string.find( xside, class .. "." .. name ) ) then return "[[SHARED|SHD]]" end
	if ( string.find( xside, class .. ":" .. name ) ) then return "[[SHARED|SHD]]" end
	
	if ( SERVER ) then return "[[SERVER|SRV]]" end
	
	return "[[CLIENT|CLI]]"
	
end


local function GetFunctions( tab )

	local functions = {}

	for k, v in pairs( tab ) do

		if ( type(v) == "function" ) then
		
			table.insert( functions, tostring(k) )
		
		end
	
	end
	
	table.sort( functions )
	return functions

end


local function DoMetaTable( name )
	
	OUTPUT = OUTPUT .. "\n\r==[["..name.."]] ([[Object]])==\n\r"
	func = GetFunctions( _R[ name ] )
	
	if ( type(_R[ name ]) != "table" ) then
		Msg("Error: _R["..name.."] is not a table!\n")
	end
	
	for k, v in pairs( func ) do
		OUTPUT = OUTPUT .. XSide( name, v ) .. " [["..name.."]]:[["..name.."."..v.."|"..v.."]]<br />\n"
	end
	
end

local function DoLibrary( name )
	
	OUTPUT = OUTPUT .. "\n\r==[["..name.."]] ([[Library]])==\n\r"
	
	if ( type(_G[ name ]) != "table" ) then
		Msg("Error: _G["..name.."] is not a table!\n")
	end
	
	func = GetFunctions( _G[ name ] )
	for k, v in pairs( func ) do
		OUTPUT = OUTPUT .. XSide( name, v ) .. " [["..name.."]].[["..name.."."..v.."|"..v.."]]<br />\n"
	end
	
end

local Ignores = { "mathx", "stringx", "_G", "_R", "_E", "GAMEMODE", "g_SBoxObjects", "tablex", "color_black",
				  "color_white", "utilx", "_LOADLIB", "_LOADED", "color_transparent", "filex", "func", "DOF_Ents", 
				  "Morph", "_ENT" }

local t ={}

for k, v in pairs(_G) do
	if ( type(v) == "table" && type(k) == "string" && !table.HasValue( Ignores, k ) ) then
		table.insert( t, tostring(k) )
	end
end

table.sort( t )
for k, v in pairs( t ) do
    Msg("Library: "..v.."\n")
	DoLibrary( v )
end


local t = {}

for k, v in pairs(_R) do
	if ( type(v) == "table" && type(k) == "string" && !table.HasValue( Ignores, k )  ) then
		table.insert( t, tostring(k) )
	end
end

table.sort( t )
for k, v in pairs( t ) do
	Msg("MetaTable: "..v.."\n")
	DoMetaTable( v )
end


if ( SERVER ) then
	file.Write( "ServerFunctions.txt", OUTPUT )
else
	file.Write( "ClientFunctions.txt", OUTPUT )
end

