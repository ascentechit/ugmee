--[[
	Title: Gamemode Hooks

	Declares our base custom hooks. Use these all you want! They'll come in handy. :)
]]

function init()
--[[
	Function: GAMEMODE:ULibPlayerReady

	This hook is called when the player object has been initialized on the client (LocalPlayer() equates to a valid ent).

	Parameters:

		ply - The player that has created their player object.
			
	Revisions:

		v2.20 - Initial	
]]
function GAMEMODE:ULibPlayerReady( ply )
end

--[[
	Function: GAMEMODE:ULibPlayerULibLoaded

	This hook is called when the player has initialized ULib on their client (ULib equates to a table on the client now).

	Parameters:

		ply - The player that has initialized ULib.
			
	Revisions:

		v2.20 - Initial	
]]
function GAMEMODE:ULibPlayerULibLoaded( ply )
end

--[[
	Function: GAMEMODE:ULibPlayerLoaded

	This hook is called when the player has initialized their client-side lua.

	Parameters:

		ply - The player that has initialized their lua.
			
	Revisions:

		v2.20 - Initial	
]]
function GAMEMODE:ULibPlayerLoaded( ply )
end

--[[
	Function: GAMEMODE:ULibPlayerNameChanged

	This hook is called when the player's name changes.

	Parameters:

		ply - The player that changed their name.
		oldnick - The player's old nick.
		newnick - The player's new nick.
			
	Revisions:

		v2.20 - Initial	
]]
function GAMEMODE:ULibPlayerNameChanged( ply, oldnick, newnick )
end

end
hook.Add( "Initialize", "ULibInitGameHooks", init )
