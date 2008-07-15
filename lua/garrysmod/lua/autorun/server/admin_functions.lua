
/*---------------------------------------------------------
   Name:	KickId2
   Desc:	Allows admins to use the kickid2 command to kick people.
---------------------------------------------------------*/   
local function KickId( player, command, arguments )

	if ( !player:IsAdmin() ) then return end
	
	local id = arguments[1]
	local reason = arguments[2] or "Kicked"
	
	game.ConsoleCommand( Format( "kickid %i %s (%s)\n", id, reason, player:Nick() ) )
	
end

concommand.Add( "kickid2", KickId )


/*---------------------------------------------------------
   Name:	BanId2
   Desc:	Allows admins to use the kickid2 command to kick people.
---------------------------------------------------------*/   
local function BanID( player, command, arguments )

	if ( !player:IsAdmin() ) then return end
	
	local length 	= arguments[1]
	local id 		= arguments[2]
	
	game.ConsoleCommand( Format( "banid %i %i\n", length, id ) )
	
end

concommand.Add( "banid2", BanID )