
local function FindInTable( tab, find, parents, depth )

	depth = depth or 0
	parents = parents or ""
	
	if ( depth > 3 ) then return end
	depth = depth + 1
	
	for k, v in pairs ( tab ) do
	
		if ( type(k) == "string" ) then
		
			if ( k && k:lower():find( find:lower() ) ) then

				Msg("\t", parents, k, " - (", type(v), " - ", v, ")\n")
			
			end
			
			// Recurse
			if ( type(v) == "table" &&
				k != "_R" &&
				k != "_E" &&
				k != "_G" &&
				k != "_M" &&
				k != "_LOADED" &&
				k != "__index" ) then
				
				local NewParents = parents .. k .. ".";
				FindInTable( v, find, NewParents, depth )
			
			end
		
		end
	
	end

end


/*---------------------------------------------------------
   Name:	Find
---------------------------------------------------------*/   
local function Find( ply, command, arguments )

	if ( ply && !ply:IsAdmin() ) then return end
	if ( !arguments[1] ) then return end
	
	if ( SERVER ) then 	Msg("Finding '", arguments[1], "' SERVERSIDE:\n") else
						Msg("Finding '", arguments[1], "' CLIENTSIDE:\n") end
	
	FindInTable( _G, arguments[1] )
	FindInTable( _R, arguments[1] )
	
	Msg("\n")
	
	if ( SERVER && ply ) then
		ply:ConCommand( "lua_find_cl " .. tostring(arguments[1]) .. "\n" );
	end
	
end

if ( SERVER ) then
	concommand.Add( "lua_find", Find )
else
	concommand.Add( "lua_find_cl", Find )
end


if ( CLIENT ) then

	local function EntInfo( player, command, arguments )
	
		local tr = player:GetEyeTrace()
		if ( ValidEntity( tr.Entity ) ) then
		
			Msg("Class: ", tr.Entity:GetClass(), "\n")
			Msg("Model: ", tr.Entity:GetModel(), "\n")
		
		end
	
	end

	concommand.Add( "ent_printinfo", EntInfo )
	
end
