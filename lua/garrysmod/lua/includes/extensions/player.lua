
local meta = FindMetaTable( "Player" )

// Return if there's nothing to add on to
if (!meta) then return end

if ( !sql.TableExists( "playerpdata" ) ) then

	sql.Query( "CREATE TABLE IF NOT EXISTS playerpdata ( infoid TEXT NOT NULL PRIMARY KEY, value TEXT );" )
	
end

// This is totally in the wrong place. 
function player.GetByUniqueID( ID )

	for _, pl in pairs( player.GetAll() ) do

		if ( pl:IsValid() && pl:IsPlayer() && pl:UniqueID() == ID )	then
			return pl
		end
		
	end

	return false
end


/*---------------------------------------------------------
   Name:	DebugInfo
   Params: 	
   Desc:	Prints debug information for the player
			( this is just an example )
---------------------------------------------------------*/  
function meta:DebugInfo()

	Msg( "Name: " .. self:Name() .. "\n" )
	Msg( "Pos: " .. tostring( self:GetPos() ) .. "\n" )

end

// Helpful aliases
meta.GetName 	= meta.Nick
meta.Name 		= meta.Nick



/*---------------------------------------------------------
   Name:	ConCommand
   Params: 	
   Desc:	Overrides the default ConCommand function
---------------------------------------------------------*/ 
if ( CLIENT ) then

	local SendConCommand = meta.ConCommand
	local CommandList = nil
	
	function meta:ConCommand( command, bSkipQueue )
		
		if ( bSkipQueue ) then
			SendConCommand( self, command )
		else
			CommandList = CommandList or {}
			table.insert( CommandList, command )
		end
		
	end
	
	local function SendQueuedConsoleCommands()
	
		if (!CommandList) then return end
		
		local BytesSent = 0
		
		for k, v in pairs( CommandList ) do
		
			SendConCommand( LocalPlayer(), v )
			CommandList[ k ] = nil
			
			// Only send x bytes per tick
			BytesSent = BytesSent + v:len()
			if ( BytesSent > 128 ) then
				break
			end
		
		end
		
		// Turn the table into a nil so we can return easy
		if ( table.Count( CommandList ) == 0 ) then 
		
			CommandList = nil
			
		end
	
	end
	
	hook.Add( "Tick", "SendQueuedConsoleCommands", SendQueuedConsoleCommands )

end

//
// Can the player use +zoom/-zoom/toggle_zoom ?
//
// Player:SetCanZoom( bool )
// Player:GetCanZoom()
//
AccessorFuncNW( meta, "m_bCanZoom", "CanZoom", true, FORCE_BOOL )


//
// Can the player use +walk/-walk ?
//
// Player:SetCanWalk( bool )
// Player:GetCanWalk()
//
AccessorFuncNW( meta, "m_bCanWalk", "CanWalk", true, FORCE_BOOL )

//
// Player:SetStepSize( float )
// Player:GetStepSize()
//
AccessorFuncNW( meta, "StepSize", "StepSize", 18 )

//
// Player:SetJumpPower( float )
// Player:GetJumpPower()
//
AccessorFuncNW( meta, "JumpPower", "JumpPower", 160 )

/*---------------------------------------------------------
	GetPData
	- Saves persist data for this player
---------------------------------------------------------*/  
function meta:GetPData( name, default )

	name = Format( "%s[%s]", self:UniqueID(), name )
	local val = sql.QueryValue( "SELECT value FROM playerpdata WHERE infoid = " .. SQLStr(name) )
	if ( val == nil ) then return default end
	
	return val

end

/*---------------------------------------------------------
	SetPData
	- Set persistant data
---------------------------------------------------------*/  
function meta:SetPData( name, value )

	name = Format( "%s[%s]", self:UniqueID(), name )
	sql.Query( "DELETE FROM playerpdata WHERE infoid = " .. SQLStr(name) )
	sql.Query( "INSERT INTO playerpdata ( infoid, value ) VALUES ( "..SQLStr(name)..", "..SQLStr(value).." )" )

end
