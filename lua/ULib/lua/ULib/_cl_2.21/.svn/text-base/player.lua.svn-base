

local overcomeimmunityaccess = "overcomeimmunity" 
if SERVER then
	timer.Simple( FrameTime() * 0.5, function() ULib.ucl.registerAccess( overcomeimmunityaccess, ULib.ACCESS_SUPERADMIN ) end ) 
	
end



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

	local user = string.lower( identifier ) 

	for _, player in ipairs( players ) do
		if CLIENT or player:IsConnected() then
			local temp = string.find( string.lower( player:Nick() ), user, 1, true ) 
			if temp then
				if player == ply or ignore_immunity or not ULib.ucl.query( player, ULib.ACCESS_IMMUNITY ) or ( ply and (not ply:IsValid() or ULib.ucl.query( ply, overcomeimmunityaccess )) ) then 
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



function ULib.getUser( identifier, ignore_immunity, ply )
	local result
	local dup 
	local immune 

	local user = string.lower( identifier ) 

	local players = player.GetAll()
	for _, player in ipairs( players ) do
		if CLIENT or player:IsConnected() then
			local temp = string.find( string.lower( player:Nick() ), user, 1, true ) 
			if temp then  
				if result then
					dup = true 
				end

				if player == ply or ignore_immunity or not ULib.ucl.query( player, ULib.ACCESS_IMMUNITY ) or ( ply and (not ply:IsValid() or ULib.ucl.query( ply, overcomeimmunityaccess )) ) then 
					result = player
				else
					immune = true
				end
			end
		end
	end

	if dup then 
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

		if exactmatch == ply or ignore_immunity or not ULib.ucl.query( exactmatch, ULib.ACCESS_IMMUNITY ) or ( ply and (not ply:IsValid() or ULib.ucl.query( ply, overcomeimmunityaccess )) ) then 
			return exactmatch
		else
			immune = true
		end
	end

	if immune then 
		return nil, "That user has immunity!"
	end

	if result then return result end

	return false, "No target found!"
end

