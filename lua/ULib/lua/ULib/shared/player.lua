--[[
	Title: Player

	Has useful player-related functions.
]]

local overcomeimmunityaccess = "overcomeimmunity" -- Access string needed for overcoming immunity
if SERVER then
	timer.Simple( FrameTime() * 0.5, function() ULib.ucl.registerAccess( overcomeimmunityaccess, ULib.ACCESS_SUPERADMIN ) end ) 
	-- Give superadmins access by default. Wait a tick for files to load.
end


--[[
	Function: getUsers

	Finds users matching an identifier.

	Parameters:

		identifier - A string of the user you'd like to target. IE, a partial player name.
		ignore_immunity - *(Optional, defaults to false)* If true, users with immunity will be returned.
		enable_keywords - *(Optional, defaults to false)* If true, the keyword "<ALL>" will be activated. (May enable team keywords in future versions)
		ply - *(Optional)* Player needing getUsers, this allows immune users to target themselves.

	Returns:

		A table of userids (false and message if none found).
]]
function ULib.getUsers( identifier, ignore_immunity, enable_keywords, ply )
	local result = {}
	local players = player.GetAll()

	if enable_keywords then
		if string.upper( identifier ) == "<ALL>" or identifier == "*" then
			for _, player in ipairs( players ) do
				if player:IsConnected() and ( player == ply or ignore_immunity or not ULib.ucl.query( player, ULib.ACCESS_IMMUNITY ) ) then
					table.insert( result, player )
				end
			end
			return result
		end
	end

	local user = string.lower( identifier ) -- We want to make this a case insensitive search

	for _, player in ipairs( players ) do
		if CLIENT or player:IsConnected() then
			local temp = string.find( string.lower( player:Nick() ), user, 1, true ) -- No special characters.
			if temp then
				if player == ply or ignore_immunity or not ULib.ucl.query( player, ULib.ACCESS_IMMUNITY ) or ( ply and (not ply:IsValid() or ULib.ucl.query( ply, overcomeimmunityaccess )) ) then -- If we're ignoring immunity or if they don't have immunity.
					table.insert( result, player )
				end
			end
		end
	end

	if #result < 1 then
		return false, "No target found or target has immunity!"
	end

	return result
end


--[[
	Function: getUser

	Finds a user matching an identifier.

	Parameters:

		identifier - A string of the user you'd like to target. IE, a partial player name. Also recognizes a userid string.
		ignore_immunity - *(Optional, defaults to false)* If true, users with immunity will be returned.
		ply - *(Optional)* Player needing getUsers, this allows immune users to target themselves.

	Returns:

		The resulting userid target, false and message if no user found.
]]
function ULib.getUser( identifier, ignore_immunity, ply )
	local result
	local dup -- If we have two or more matches
	local immune -- If we hit a user with immunity

	local user = string.lower( identifier ) -- We want to make this a case insensitive search

	local players = player.GetAll()
	for _, player in ipairs( players ) do
		if CLIENT or player:IsConnected() then
			local temp = string.find( string.lower( player:Nick() ), user, 1, true ) -- No special characters.
			if temp then  -- We have a match
				if result then
					dup = true -- Duplicate
				end

				if player == ply or ignore_immunity or not ULib.ucl.query( player, ULib.ACCESS_IMMUNITY ) or ( ply and (not ply:IsValid() or ULib.ucl.query( ply, overcomeimmunityaccess )) ) then -- If we're ignoring immunity or if they don't have immunity.
					result = player
				else
					immune = true
				end
			end
		end
	end

	if dup then -- If there is more than one match, we have to match the name exactly or error
		local exactmatch
		for _, player in ipairs( players ) do
			if CLIENT or player:IsConnected() then
				if string.lower( player:Nick() ) == user then
					exactmatch = player
				end
			end
		end

		if not exactmatch then
			return nil, "Found multiple targets! Please choose a better string for the target. (IE, the whole name)"
		end

		if exactmatch == ply or ignore_immunity or not ULib.ucl.query( exactmatch, ULib.ACCESS_IMMUNITY ) or ( ply and (not ply:IsValid() or ULib.ucl.query( ply, overcomeimmunityaccess )) ) then -- If we're ignoring immunity or if they don't have immunity.
			return exactmatch
		else
			immune = true
		end
	end

	if immune then -- Immune player
		return nil, "That user has immunity!"
	end

	if result then return result end

	return false, "No target found!"
end

