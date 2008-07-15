
module( "team", package.seeall )

local TeamInfo = {}
local DefaultColor = Color(255, 255, 100, 255)

TeamInfo[TEAM_CONNECTING] 	= { Name = "Joining/Connecting", 	Color = DefaultColor, 	Score = 0, 	Joinable = false }
TeamInfo[TEAM_UNASSIGNED] 	= { Name = "Unassigned", 			Color = DefaultColor, 	Score = 0, 	Joinable = false }
TeamInfo[TEAM_SPECTATOR] 	= { Name = "Spectator", 			Color = DefaultColor, 	Score = 0, 	Joinable = true }

/*------------------------------------------------------------

	Call this to set up your team. It should be called in
	a shared file. This system assumes that your teams are
	static. If you want to have dynamic teams you need to 
	code this yourself.
	
	id should be a number. It's best to do something like
	
	TEAM_TERRORISTS = 2
	
	at the top of your code somewhere so you can reference
	teams via a variable rather than a number.
	
------------------------------------------------------------*/   
function SetUp( id, name, color, joinable )

	if ( joinable == nil ) then joinable = true end
	
	TeamInfo[id] = { Name = name, Color = color, Score = 0, Joinable = joinable }
	
end


function GetAllTeams()
	return TeamInfo // copyof?
end

function Joinable( id )
	if ( !TeamInfo[id] ) then return false end
	return TeamInfo[id].Joinable
end

function GetSpawnPoint( id )
	if ( !TeamInfo[id] ) then return end
	return TeamInfo[id].SpawnPointName
end

function SetSpawnPoint( id, ent_name )
	if ( !TeamInfo[id] ) then return end
	TeamInfo[id].SpawnPointName = ent_name
end

function TotalDeaths(index)
	local score = 0
	for id,pl in pairs( player.GetAll() ) do
		if (pl:Team() == index) then
			score = score + pl:Deaths()
		end
	end
	return score
end

function TotalFrags(index)
	local score = 0
	for id,pl in pairs( player.GetAll() ) do
		if (pl:Team() == index) then
			score = score + pl:Frags()
		end
	end
	return score
end

function NumPlayers(index)
	return #GetPlayers(index)
end

function GetPlayers(index)
	local TeamPlayers = {}
	
	for id,pl in pairs( player.GetAll() ) do
		if (pl:Team() == index) then
			table.insert(TeamPlayers, pl)
		end
	end
	
	return TeamPlayers
end

function GetScore(index)

	return GetGlobalInt( "Team."..tostring(index)..".Score", 0 )
	
end

function GetName( index )

	if (!TeamInfo[index]) then return "" end
	return TeamInfo[index].Name
	
end

function GetColor( index )

	if (!TeamInfo[index]) then return DefaultColor end
	return TeamInfo[index].Color
	
end

function SetScore(index, score)

	return SetGlobalInt( "Team."..tostring(index)..".Score", score )

end

function AddScore(index, score)

	SetScore( index, GetScore( index ) + score )

end
