
if ( g_MapList ) then return end

local MapPatterns = {}

MapPatterns[ "^de_" ] = "Counter-Strike"
MapPatterns[ "^cs_" ] = "Counter-Strike"
MapPatterns[ "^es_" ] = "Counter-Strike"

MapPatterns[ "^cp_" ] = "Team Fortress 2"
MapPatterns[ "^ctf_" ] = "Team Fortress 2"
MapPatterns[ "^tc_" ] = "Team Fortress 2"
MapPatterns[ "^pl_" ] = "Team Fortress 2"

MapPatterns[ "^dod_" ] = "Day Of Defeat"

MapPatterns[ "^d1_" ] = "Half-Life 2"
MapPatterns[ "^d2_" ] = "Half-Life 2"
MapPatterns[ "^d3_" ] = "Half-Life 2"
MapPatterns[ "credits" ] = "Half-Life 2"

MapPatterns[ "^ep1_" ] = "Half-Life 2: Episode 1"
MapPatterns[ "^ep2_" ] = "Half-Life 2: Episode 2"
MapPatterns[ "^ep3_" ] = "Half-Life 2: Episode 3"

MapPatterns[ "^escape_" ] = "Portal"
MapPatterns[ "^testchmb_" ] = "Portal"

MapPatterns[ "^gm_" ] = "Garry's Mod"

MapPatterns[ "^c0a" ] = "Half-Life: Source"
MapPatterns[ "^c1a" ] = "Half-Life: Source"
MapPatterns[ "^c2a" ] = "Half-Life: Source"
MapPatterns[ "^c3a" ] = "Half-Life: Source"
MapPatterns[ "^c4a" ] = "Half-Life: Source"
MapPatterns[ "^c5a" ] = "Half-Life: Source"
MapPatterns[ "^t0a" ] = "Half-Life: Source"

MapPatterns[ "boot_camp" ] = "Half-Life: Source Deathmatch"
MapPatterns[ "bounce" ] = "Half-Life: Source Deathmatch"
MapPatterns[ "crossfire" ] = "Half-Life: Source Deathmatch"
MapPatterns[ "datacore" ] = "Half-Life: Source Deathmatch"
MapPatterns[ "frenzy" ] = "Half-Life: Source Deathmatch"
MapPatterns[ "rapidcore" ] = "Half-Life: Source Deathmatch"
MapPatterns[ "stalkyard" ] = "Half-Life: Source Deathmatch"
MapPatterns[ "snarkpit" ] = "Half-Life: Source Deathmatch"
MapPatterns[ "subtransit" ] = "Half-Life: Source Deathmatch"
MapPatterns[ "undertow" ] = "Half-Life: Source Deathmatch"
MapPatterns[ "lambda_bunker" ] = "Half-Life: Source Deathmatch"

MapPatterns[ "dm_" ] = "Half-Life 2 Deathmatch"

//
// Load patterns from the gamemodes
//
local GameModes = GetGamemodes()

for k, gm in pairs( GetGamemodes() ) do

	local info = file.Read( "../gamemodes/"..gm.Name.."/info.txt" )
	local info = KeyValuesToTable( info )
	local Name = info.name or "Unnammed Gamemode"
	local Patterns = info.mappattern or {}
	
	for k, pattern in pairs( Patterns ) do
		MapPatterns[ pattern ] = Name
	end
	
end

local IgnoreMaps = { "background", "^test_", "^styleguide", "^devtest" }

matNoIcon = Material( "maps/noicon" )

g_MapList = {}
g_MapListCategorised = {}

for k, v in pairs( file.Find( "../maps/*.bsp" ) ) do

	local Ignore = false
	for _, ignore in pairs( IgnoreMaps ) do
		if ( string.find( v, ignore ) ) then
			Ignore = true
		end
	end
	
	// Don't add useless maps
	if ( !Ignore ) then
	
		local Mat = nil
		local Category = "Other"
		local name = string.gsub( v, ".bsp", "" ) 
	
		// Find any material this map has
		if ( file.Exists( "../materials/maps/"..name..".vmt" ) ) then
			Mat = Material( "maps/"..name )
		else
			Mat = matNoIcon
		end
		
		for pattern, category in pairs( MapPatterns ) do
			if ( string.find( v, pattern ) ) then
				Category = category
			end
		end

		g_MapList[ v ] = { Material = Mat, Name = name, Category = Category }
					 
	end

end

for k, v in pairs( g_MapList ) do

	g_MapListCategorised[ v.Category ] = g_MapListCategorised[ v.Category ] or {}
	g_MapListCategorised[ v.Category ][ v.Name ] = v

end
