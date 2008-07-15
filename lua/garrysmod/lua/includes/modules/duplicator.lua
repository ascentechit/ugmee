


/*---------------------------------------------------------
   Duplicator module, 
   to add new constraints or entity classes use...
   
   duplicator.RegisterConstraint( "name", funct, ... )
   duplicator.RegisterEntityClass( "class", funct, ... )
   
---------------------------------------------------------*/

module( "duplicator", package.seeall )

ConstraintType 	= ConstraintType or {} 
	
/*---------------------------------------------------------
   Register a constraint to be duplicated
---------------------------------------------------------*/
function RegisterConstraint( _name_ , _function_, ... )	

	ConstraintType[ _name_ ] 	= {}
	
	ConstraintType[ _name_ ].Func = _function_;
	ConstraintType[ _name_ ].Args = {...}
	
end


EntityClasses	= EntityClasses or {}

/*---------------------------------------------------------
   Register an entity's class, to allow it to be duplicated
---------------------------------------------------------*/
function RegisterEntityClass( _name_ , _function_, ... )

	EntityClasses[ _name_ ] 		= {}
	
	EntityClasses[ _name_ ].Func 	= _function_
	EntityClasses[ _name_ ].Args 	= {...}
	
end

/*---------------------------------------------------------
   Returns an entity class factory
---------------------------------------------------------*/
function FindEntityClass( _name_ )

	if ( !_name_ ) then return end
	return EntityClasses[ _name_ ]

end

/*---------------------------------------------------------

---------------------------------------------------------*/
BoneModifiers 				= BoneModifiers or {}
EntityModifiers				= EntityModifiers or {}

function RegisterBoneModifier( _name_, _function_ )		BoneModifiers[ _name_ ] 			= _function_ end
function RegisterEntityModifier( _name_, _function_ )	EntityModifiers[ _name_ ] 			= _function_ end

if (!SERVER) then return end

/*---------------------------------------------------------
   Applies generic every-day entity stuff for ent from table data.
---------------------------------------------------------*/
function DoGeneric( ent, data )

	if ( !data ) then return end
	if ( data.Model ) then ent:SetModel( data.Model ) end
	if ( data.Angle ) then ent:SetAngles( data.Angle ) end
	if ( data.Pos ) then ent:SetPos( data.Pos ) end
	if ( data.Skin ) then ent:SetSkin( data.Skin ) end

end


/*---------------------------------------------------------
   Applies bone data, generically. 
---------------------------------------------------------*/
function DoGenericPhysics( Entity, Player, data )

	if (!data) then return end
	if (!data.PhysicsObjects) then return end
	
	for Bone, Args in pairs( data.PhysicsObjects ) do
	
		local Phys = Entity:GetPhysicsObjectNum(Bone)
		
		if ( Phys && Phys:IsValid() ) then	

			Phys:SetPos( Args.Pos )
			Phys:SetAngle( Args.Angle )

			if ( Args.Frozen == true ) then 
				Phys:EnableMotion( false ) 
				Player:AddFrozenPhysicsObject( Entity, Phys )
			end
							
		end
		
	end

end

/*---------------------------------------------------------
   Restore's the face data
---------------------------------------------------------*/
function DoFlex( ent, Flex, Scale )

	if (!Flex) then return end
	if (!ent) then return end

	for k, v in pairs( Flex ) do
		ent:SetFlexWeight( k, v )
	end
	
	if ( Scale ) then
		ent:SetFlexScale( Scale )
	end

end

/*---------------------------------------------------------
   Generic function for duplicating stuff
---------------------------------------------------------*/
function GenericDuplicatorFunction( Player, data )

	local Entity = ents.Create( data.Class )
		DoGeneric( Entity, data )
	Entity:Spawn()
	Entity:Activate()
	
	DoGenericPhysics( Entity, Player, data )	
	
	table.Add( Entity:GetTable(), data )
	
	return Entity
	
end

/*---------------------------------------------------------
	Automates the process of adding crap the EntityMods table
---------------------------------------------------------*/
function StoreEntityModifier( Entity, Type, Data )

	if (!Entity) then return end
	if (!Entity:IsValid()) then return end

	Entity.EntityMods = Entity.EntityMods or {}
	
	// Copy the data
	local NewData = Entity.EntityMods[ Type ] or {}
	table.Merge( NewData, Data )
	
	Entity.EntityMods[ Type ] = NewData

end

/*---------------------------------------------------------
	Clear entity modification
---------------------------------------------------------*/
function ClearEntityModifier( Entity, Type )

	if (!Entity) then return end
	if (!Entity:IsValid()) then return end
	
	Entity.EntityMods = Entity.EntityMods or {}
	Entity.EntityMods[ Type ] = nil

end

/*---------------------------------------------------------
	Automates the process of adding crap the BoneMods table
---------------------------------------------------------*/
function StoreBoneModifier( Entity, BoneID, Type, Data )

	if (!Entity) then return end
	if (!Entity:IsValid()) then return end

	// Copy the data
	NewData = {}
	table.Merge( NewData , Data )
	
	// Add it to the entity
	Entity.BoneMods = Entity.BoneMods or {}
	Entity.BoneMods[ BoneID ] = Entity.BoneMods[ BoneID ] or {}
	
	Entity.BoneMods[ BoneID ][ Type ] = NewData

end

/*---------------------------------------------------------
	Returns a copy of the passed entity's table
---------------------------------------------------------*/
function CopyEntTable( Ent )

	local Tab = {}

	if ( Ent.PreEntityCopy ) then
		Ent:PreEntityCopy()
	end
	
	table.Merge( Tab, Ent:GetTable() )
	
	if ( Ent.PostEntityCopy ) then
		Ent:PostEntityCopy()
	end
	
	Tab.Pos = Ent:GetPos()
	Tab.Angle = Ent:GetAngles()
	Tab.Class = Ent:GetClass()
	Tab.Model = Ent:GetModel()
	Tab.Skin = Ent:GetSkin()
	
	// Allow the entity to override the class
	// This is a hack for the jeep, since it's real class is different from the one it reports as
	// (It reports a different class to avoid compatibility problems)
	if ( Ent.ClassOverride ) then Tab.Class = Ent.ClassOverride end
	
	Tab.PhysicsObjects = Tab.PhysicsObjects or {}
	
	// Physics Objects
	local iNumPhysObjects = Ent:GetPhysicsObjectCount()
	for Bone = 0, iNumPhysObjects-1 do 
	
		local PhysObj = Ent:GetPhysicsObjectNum( Bone )
		if ( PhysObj:IsValid() ) then
		
			Tab.PhysicsObjects[ Bone ] = Tab.PhysicsObjects[ Bone ] or {}
			Tab.PhysicsObjects[ Bone ].Pos = PhysObj:GetPos()
			Tab.PhysicsObjects[ Bone ].Angle = PhysObj:GetAngle()
			Tab.PhysicsObjects[ Bone ].Frozen = !PhysObj:IsMoveable()
			
		end
	
	end
	
	// Flexes
	local FlexNum = Ent:GetFlexNum()
	for i = 0, FlexNum do
	
		Tab.Flex = Tab.Flex or {}
		Tab.Flex[ i ] = Ent:GetFlexWeight( i )
	
	end
	
	Tab.FlexScale = Ent:GetFlexScale()
	
	// Make this function on your SENT if you want to modify the
	//  returned table specifically for your entity.
	if ( Ent.OnEntityCopyTableFinish ) then
		Ent:OnEntityCopyTableFinish( Tab )
	end

	return Tab

end

/*---------------------------------------------------------
   Copy this entity, and all of its constraints and entities 
   and put them in a table.
---------------------------------------------------------*/
function Copy( Ent )

	local Ents = {}
	local Constraints = {}
	
	GetAllConstrainedEntitiesAndConstraints( Ent, Ents, Constraints )
	
	local EntTables = {}
	for k, v in pairs(Ents) do
		EntTables[ k ] = CopyEntTable( v )
	end
	
	local ConstraintTables = {}
	for k, v in pairs(Constraints) do
		table.insert( ConstraintTables, v )
	end
	
	return EntTables, ConstraintTables

end


/*---------------------------------------------------------
   Create an entity from a table.
---------------------------------------------------------*/
function CreateEntityFromTable( Player, EntTable )

	local EntityClass = FindEntityClass( EntTable.Class )
	
	// This class is unregistered. Instead of failing try using a generic
	// Duplication function to make a new copy..
	if (!EntityClass) then
	
		return GenericDuplicatorFunction( Player, EntTable )
	
	end
		
	// Build the argument list
	local ArgList = {}
		
	for iNumber, Key in pairs( EntityClass.Args ) do

		local Arg = nil
	
		// Translate keys from old system
		if ( Key == "pos" || Key == "position" ) then Key = "Pos" end
		if ( Key == "ang" || Key == "Ang" || Key == "angle" ) then Key = "Angle" end
		if ( Key == "model" ) then Key = "Model" end
		
		Arg = EntTable[ Key ]
		
		// Special keys
		if ( Key == "Data" ) then Arg = EntTable end
		
		// If there's a missing argument then unpack will stop sending at that argument
		if ( Arg == nil ) then Arg = false end
		
		ArgList[ iNumber ] = Arg
		
	end
		
	
	// Create and return the entity
	return EntityClass.Func( Player, unpack(ArgList) )
	
end


/*---------------------------------------------------------
  Make a constraint from a constraint table
---------------------------------------------------------*/
function CreateConstraintFromTable( Constraint, EntityList )

	local Factory = ConstraintType[ Constraint.Type ]
	if ( !Factory ) then return end
	
	local Args = {}
	for k, Key in pairs( Factory.Args ) do
	
		local Val = Constraint[ Key ]
		
		for i=1, 6 do 
			if ( Constraint.Entity[ i ] ) then
				if ( Key == "Ent"..i ) then	
					Val = EntityList[ Constraint.Entity[ i ].Index ] 
					if ( Constraint.Entity[ i ].World ) then
						Val = GetWorldEntity()
					end
				end
				if ( Key == "Bone"..i ) then Val = Constraint.Entity[ i ].Bone end
				if ( Key == "LPos"..i ) then Val = Constraint.Entity[ i ].LPos end
				if ( Key == "WPos"..i ) then Val = Constraint.Entity[ i ].WPos end
				if ( Key == "Length"..i ) then Val = Constraint.Entity[ i ].Length end
			end
		end
		
		// If there's a missing argument then unpack will stop sending at that argument
		if ( Val == nil ) then Val = false end
		
		table.insert( Args, Val )
	
	end
	
	local Entity = Factory.Func( unpack(Args) )
	
	return Entity

end

/*---------------------------------------------------------
   Given entity list and constranit list, create all entities
   and return their tables
---------------------------------------------------------*/
function Paste( Player, EntityList, ConstraintList )

	local CreatedEntities = {}
	
	//
	// Create the Entities
	//
	for k, v in pairs( EntityList ) do
	
		CreatedEntities[ k ] = CreateEntityFromTable( Player, v )
		
		if ( CreatedEntities[ k ] ) then
		
			CreatedEntities[ k ].BoneMods = table.Copy( v.BoneMods )
			CreatedEntities[ k ].EntityMods = table.Copy( v.EntityMods )
			CreatedEntities[ k ].PhysicsObjects = table.Copy( v.PhysicsObjects )
			
		else
		
			CreatedEntities[ k ] = nil
		
		end
		
	end
	
	//
	// Apply modifiers to the created entities
	//
	for EntID, Ent in pairs( CreatedEntities ) do	
	
		ApplyEntityModifiers ( Player, Ent )
		ApplyBoneModifiers ( Player, Ent )
	
		if ( Ent.PostEntityPaste ) then
			Ent:PostEntityPaste( Player, Ent, CreatedEntities )
		end
	
	end
	
	
	local CreatedConstraints = {}
	
	//
	// Create constraints
	//
	for k, Constraint in pairs( ConstraintList ) do
	
		local Entity = CreateConstraintFromTable( Constraint, CreatedEntities )
		
		if ( Entity && Entity:IsValid() ) then
			table.insert( CreatedConstraints, Entity )
		end
	
	end


	return CreatedEntities, CreatedConstraints
	
end


/*---------------------------------------------------------
  Applies entity modifiers
---------------------------------------------------------*/
function ApplyEntityModifiers( Player, Ent )

	if ( !Ent ) then return end
	if ( !Ent.EntityMods ) then return end

	for Type, ModFunction in pairs( EntityModifiers ) do
	
		if ( Ent.EntityMods[ Type ] ) then
	
			ModFunction( Player, Ent, Ent.EntityMods[ Type ] )
			
		end
	end

end


/*---------------------------------------------------------
  Applies Bone Modifiers
---------------------------------------------------------*/
function ApplyBoneModifiers( Player, Ent )

	if ( !Ent ) then return end
	if ( !Ent.PhysicsObjects ) then return end
	if ( !Ent.BoneMods ) then return end
	
	// For each modifier
	for Type, ModFunction in pairs( BoneModifiers ) do
		
		// For each of the entity's bones
		for Bone, Args in pairs( Ent.PhysicsObjects ) do
		
			if ( Ent.BoneMods[ Bone ] && Ent.BoneMods[ Bone ][ Type ] ) then 
			
				local PhysObject = Ent:GetPhysicsObjectNum( Bone )
			
				if ( Ent.PhysicsObjects[ Bone ] ) then
					ModFunction( Player, Ent, Bone, PhysObject, Ent.BoneMods[ Bone ][ Type ] )
				end
			
			end
		
		end
		
	end

end


/*---------------------------------------------------------
  Returns all constrained Entities and constraints
  This is kind of in the wrong place. No not call this 
  from outside of this code. It will probably get moved to
  constraint.lua soon.
---------------------------------------------------------*/
function GetAllConstrainedEntitiesAndConstraints( ent, EntTable, ConstraintTable )

	if ( !ent:IsValid() ) then return end

	EntTable[ ent:EntIndex() ] = ent
	
	if ( !constraint.HasConstraints( ent ) ) then return end
	
	local ConTable = constraint.GetTable( ent )
	
	for key, constraint in pairs( ConTable ) do

		local index = constraint.Constraint
		
		if ( !ConstraintTable[ index ] ) then

			// Add constraint to the constraints table
			ConstraintTable[ index ] = constraint

			// Run the Function for any ents attached to this constraint
			for key, ConstrainedEnt in pairs( constraint.Entity ) do

				GetAllConstrainedEntitiesAndConstraints( ConstrainedEnt.Entity, EntTable, ConstraintTable )
					
			end
			
		end
	end

	return EntTable, ConstraintTable
	
end

