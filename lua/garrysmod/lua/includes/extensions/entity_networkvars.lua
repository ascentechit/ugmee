
//
// In old times this used to actually handle the networked vars,
//  but now it just saves/restores them. The actual work is done 
//  in the engine.
//

// saverestore doesn't exist in menu lua
if (!saverestore) then return end

local function Save( save )

	// Note: BuildNetworkedVarsTable should only ever be called when saving
	// It is quite slow, and should definitiely not be used to select and find
	// networked vars.
	
	local NetworkVars = BuildNetworkedVarsTable()
	saverestore.WriteTable( NetworkVars, save )

end

local function Restore( restore )

	local NetworkVars = saverestore.ReadTable( restore )
	
	// First load the global vars. They have an index of 0.
	local Globals = NetworkVars[ 0 ]
	// Remove it from the table so we don't process it again.
	NetworkVars[ 0 ] = nil
	
	if ( Globals ) then
		for k, v in pairs( Globals ) do
			SetGlobalVar( k, v )
		end
	end	
	
	// Now load the entity vars.
	for ent, enttab in pairs( NetworkVars ) do
		for k, v in pairs( enttab ) do
			ent:SetNetworkedVar( k, v )
		end
	end	

end

saverestore.AddSaveHook( "NetworkedVars", Save )
saverestore.AddRestoreHook( "NetworkedVars", Restore )
