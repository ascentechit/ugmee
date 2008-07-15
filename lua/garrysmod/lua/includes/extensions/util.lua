
// Backwards compatibility
utilx = util

// Return if there's nothing to add on to
if (!util) then return end


/*---------------------------------------------------------
   Name:	IsValidPhysicsObject
   Params: 	<ent> <num>
   Desc:	Returns true if physics object is valid, false if not
---------------------------------------------------------*/   
function util.IsValidPhysicsObject( ent, num )

	// Make sure the entity is valid
	if ( !ent || (!ent:IsValid() && !ent:IsWorld()) ) then return false end

	// This is to stop attaching to walking NPCs.
	// Although this is possible and `works', it can severly reduce the 
	// performance of the server.. Plus they don't pay attention to constraints
	// anyway - so we're not really losing anything.
	
	local MoveType = ent:GetMoveType()
	if ( !ent:IsWorld() && MoveType != MOVETYPE_VPHYSICS ) then return false end

	local Phys = ent:GetPhysicsObjectNum( num )
	return Phys:IsValid()

end

/*---------------------------------------------------------
   Name: GetPlayerTrace( ply, dir )
   Desc: Returns a generic trace table for the player
		 (dir is optional, defaults to the player's aim)
---------------------------------------------------------*/
function util.GetPlayerTrace( ply, dir )

	dir = dir or ply:GetAimVector()

	local trace = {}
	
	trace.start = ply:EyePos()
	trace.endpos = trace.start + (dir * 4096 * 4)
	trace.filter = ply
	
	return trace
	
end


/*---------------------------------------------------------
   Name: QuickTrace( origin, offset, filter )
   Desc: Quick trace
---------------------------------------------------------*/
function util.QuickTrace( origin, dir, filter )

	local trace = {}
	
	trace.start = origin
	trace.endpos = origin + dir
	trace.filter = filter
	
	return util.TraceLine( trace )
	
end


/*---------------------------------------------------------
   Name: tobool( in )
   Desc: Turn variable into bool
---------------------------------------------------------*/
function util.tobool( val )
	return tobool( val )
end


/*---------------------------------------------------------
   Name: LocalToWorld( ent, lpos, bone )
   Desc: Convert the local position on an entity to world pos
---------------------------------------------------------*/
function util.LocalToWorld( ent, lpos, bone )
	_bone = bone or 0
	if (ent:EntIndex() == 0) then
		return lpos
	else
		if (ent:GetPhysicsObjectNum(_bone) ~= nil && ent:GetPhysicsObjectNum(_bone):IsValid()) then
			return ent:GetPhysicsObjectNum(_bone):LocalToWorld(lpos)
		else
			return ent:LocalToWorld(lpos)
		end
	end
	return nil
end
