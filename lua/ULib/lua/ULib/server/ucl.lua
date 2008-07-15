--[[
	Title: UCL

	ULib's Access Control List
]]

local ucl = ULib.ucl -- Make it easier for us to refer to


--[[
	Section: Format

	This section will tell you how to format your strings/files for UCLs.

	Format of admin account in users.txt--
	"<account_name>"
	{
		"id" "<name|ip|steamid|clantag>"
		"type" "<name|ip|steamid|clantag>"
		"pass" "<password>"
		"pass_req" "<0|1>"
		"groups"
		{
			"superadmin"
			"immunity"
		}
		"allow"
		{
			"ulx kick"
			"ulx ban"
		}
		"deny"
		{
			"ulx cexec"
		}
	}

	Format of group in groups.txt--
	"<group_name>"
	{
		"allow"
		{
			"ulx kick"
			"ulx ban"
		}
		"deny"
		{
			"ulx cexec"
		}
		"inherit_from"
		{
			"admin"
		}
	}
]]


local function ucl_initialspawn( ply )
	ucl.authed[ ply ] = nil
	ucl.awaitingauth[ ply ] = nil
	ucl.probe( ply )
end
hook.Add( "PlayerInitialSpawn", "ucl_initialspawn", ucl_initialspawn )

local function ucl_disconnect( ply )
	ucl.authed[ ply ] = nil
	ucl.awaitingauth[ ply ] = nil
end
hook.Add( "PlayerDisconnected", "routeUserDisconnect", userDisconnect )


--[[
	Function: ucl.addGroup

	Adds a new group to the UCL.

	Parameters:

		name - A string of the group name. (IE: superadmin)
		acl - *(Optional, defaults to empty table)* The ACL for the group.
		write - *(Optional, defaults to false)* Write this new or changed group to the file.
		inherit_from - *(Optional, default to empty table)* A table of groups to inherit from.

	Revisions:

		v2.10 - acl is now an options parameter, added inherit_from
]]
function ucl.addGroup( name, acl, write, inherit_from )
	ucl.groups[ name ] = ucl.groups[ name ] or {}
	acl = acl or {}
	ucl.groups[ name ].allow = acl.allow or {}
	ucl.groups[ name ].deny = acl.deny or {}
	ucl.groups[ name ].inherit_from = inherit_from or {}

	if write then
		local groups = ULib.parseKeyValues( file.Read( ULib.UCL_GROUPS ), true )
		groups[ name ] = acl
		file.Write( ULib.UCL_GROUPS, ULib.makeKeyValues( groups ) )
	end
end

--[[
	Function: ucl.removeGroup

	Removes a group from the UCL.

	Parameters:

		name - A string of the group name. (IE: superadmin)
		write - *(Optional, defaults to false)* Write this new or changed group to the file.

	Revisions:

		v2.10 - Initial
]]
function ucl.removeGroup( name, write )
	if not ucl.groups[ name ] then
		ULib.error( "removeGroup was passed a non-existant group " .. tostring( name ) )
		return
	end
	
	ucl.groups[ name ] = nil
	
	local players = player.GetAll()
	for _, ply in ipairs( players ) do
		if table.HasValue( ply:GetGroups( true ), name ) then
			local newgroups = {}
			for _, group in ipairs( ply:GetGroups( true ) ) do
				if group ~= name then
					table.insert( newgroups, group )
				end
			end
			-- Now we'll reprobe all users that had this group. Other users who have this group that aren't connected right now will have the group dropped next connect.
			local info = ULib.ucl.authed[ ply ]
			ucl.addUser( info.account, info.type, info.id, newgroups, {allow=info.allow, deny=info.deny} , info.pass, info.pass_req, true )
		end
	end	

	if write then
		local groups = ULib.parseKeyValues( file.Read( ULib.UCL_GROUPS ), true )
		groups[ name ] = nil
		file.Write( ULib.UCL_GROUPS, ULib.makeKeyValues( groups ) )
	end
end


--[[
	Function: ucl.addUser

	Adds a new user to the UCL.

	Parameters:

		account - The unique user account name. Has no effect on access, just for reference.
		typ - The string type of this account. Valid options are steamid, ip, clantag, and name.
		id - The ID (steamid, name, etc).
		groups - A table of groups this user belongs to.
		acl - *(Optional, defaults to {})* The ACL for this user.
		pass - *(Optional, defaults to "")* The password for this user.
		pass_req - *(Optional, defaults to false)* Whether or not the user can stay in the server without the correct password.
		write - *(Optional, defaults to false)* Write this new or changed user to the file.
		
	Revisions:
	
		3.10 - No longer makes a group if it doesn't exist
]]
function ucl.addUser( account, typ, id, groups, acl, pass, pass_req, write )
	acl = acl or {}
	pass = pass or ""

	if not account or type( account ) ~= "string" or
	   not typ or type( typ ) ~= "string" or
	   not id or type( id ) ~= "string" or
	   not groups or type( groups ) ~= "table" or
	   not acl or type( acl ) ~= "table" or
	   not pass or type( "pass" ) ~= "string" then
		ULib.error( "Bad user passed to addUser! User account name was " .. tostring( account ) )
		return
	end

	typ = string.lower( typ ) -- Error catching

	if typ ~= "name" and typ ~= "clantag" and typ ~= "ip" and typ ~= "steamid" then
		ULib.error( "Invalid user type: " .. typ .. " for account: " .. account )
		return
	end

	ucl.users[ account ] = {
		type = typ,
		id = id,
		groups = groups,
		allow = acl.allow or {},
		deny = acl.deny or {},
		pass = pass,
		pass_req = pass_req,
	}
	
	-- We're going to make sure they're only adding valid groups.
	local t = {}
	for _, group in ipairs( groups ) do
		if ucl.groups[ group ] then
			table.insert( t, group )
		end
	end	
	groups = t

	-- Handle adding the user if they're connected
	if typ == "name" then
		local players = player.GetAll()
		for _, player in ipairs( players ) do
			if player:IsConnected() and player:Nick() == id then
				ucl.probe( player, false, true )
				break
			end
		end
	elseif typ == "clantag" then
		local users = ULib.getUsers( id, true )
		if users then -- If there's users
			for _, player in ipairs( users ) do
				ucl.probe( player, false, true )
			end
		end
	elseif typ == "ip" then
		local players = player.GetAll()
		for _, player in ipairs( players ) do
			if player:IsConnected() then
				local ip = string.gsub( player:IPAddress(), "^(.-):(.+)$", "%1" ) -- Strip the port
				if ip == id then
					ucl.probe( player, false, true )
					break
				end
			end
		end
	elseif typ == "steamid" then
		local players = player.GetAll()
		for _, player in ipairs( players ) do
			if player:IsConnected() and player:SteamID() == id then
				ucl.probe( player, false, true )
				-- We're not breaking in case they add ID_LAN
			end
		end
	end

	if write then
		local users = ULib.parseKeyValues( file.Read( ULib.UCL_USERS ), true )
		users[ account ] = ucl.users[ account ]
		file.Write( ULib.UCL_USERS, ULib.makeKeyValues( users ) )
	end
end


--[[
	Function: ucl.removeUser

	Removes a user from the UCL object "obj". Also removes them from the authed list.

	Parameters:

		account - The unique user account name. Has no effect on access, just for reference.
		write - *(Optional, defaults to false)* Write this deletion to the file.
]]
function ucl.removeUser( account, write )
	if not ucl.users[ account ] then
		ULib.error( "removeUser was passed a non-existant account " .. tostring( account ) )
		return
	end

	local typ = ucl.users[ account ].type
	local id = ucl.users[ account ].id
	ucl.users[ account ] = nil

	if typ == "name" then
		local players = player.GetAll()
		for _, player in ipairs( players ) do
			if player:IsConnected() and player:Nick() == id then
				ucl.probe( player, false, true )
				break
			end
		end
	elseif typ == "clantag" then
		local users = ULib.getUsers( id, true )
		if users then -- If there's users
			for _, player in ipairs( users ) do
				ucl.probe( player, false, true )
			end
		end
	elseif typ == "ip" then
		local players = player.GetAll()
		for _, player in ipairs( players ) do
			if player:IsConnected() then
				local ip = string.gsub( player:IPAddress(), "^(.-):(.+)$", "%1" ) -- Strip the port
				if ip == id then
					ucl.probe( player, false, true )
					break
				end
			end
		end
	elseif typ == "steamid" then
		local players = player.GetAll()
		for _, player in ipairs( players ) do
			if player:IsConnected() and player:SteamID() == id then
				ucl.probe( player, false, true )
				-- We're not breaking in case they add ID_LAN
			end
		end
	end

	if write then
		local users = ULib.parseKeyValues( file.Read( ULib.UCL_USERS ), true )
		users[ account ] = nil
		file.Write( ULib.UCL_USERS, ULib.makeKeyValues( users ) )
	end
end


--[[
	Function: ucl.probe

	Probes the user to assign access appropriately.
	*DO NOT CALL THIS DIRECTLY, UCL HANDLES IT.*

	Parameters:

		ply - The player object to probe.
		check - *(Optional, defaults to false)* Only checks if they have some sort of access, won't take any action.
			Useful to see if they might have any rights before they're fully connected/setup. Will return user
			access table or nil.
		force - *(Optional, defaults to false)* Forces a new probe.
]]
function ucl.probe( ply, check, force )
	if not check and not force and ( ucl.authed[ ply ] or ucl.awaitingauth[ ply ] ) then return end -- They've already been probed

	local steamid = ply:SteamID()
	local name = ply:Nick()
	local ip = string.gsub( ply:IPAddress(), "^(.-):(.+)$", "%1" ) -- Strip the port

	-- Let's make some quick lookup tables
	local ips = {}
	local steamids = {}
	local names = {}
	local clantags = {}
	for _, v in pairs( ucl.users ) do
		if v.type == "ip" then ips[ v.id ] = v
		elseif v.type == "steamid" then steamids[ v.id ] = v
		elseif v.type == "name" then names[ v.id ] = v
		elseif v.type == "clantag" then clantags[ v.id ] = v end
	end

	local match = ULib.DEFAULT_GRANT_ACCESS

	-- Let's figure out if they have any access
	if steamids[ steamid ] then
		match = steamids[ steamid ]
	elseif ips[ ip ] then
		match = ips[ ip ]
	elseif names[ name ] then
		match = names[ name ]
	elseif ply:IsListenServerHost() then -- Allow this to be overridden by everything except clantag
		match = ULib.LISTEN_ACCESS
	else
		for tag, v in ipairs( clantags ) do
			if string.find( name, tag ) then
				match = v
				break
			end
		end
	end

	if check then
		return match
	end

	-- Now let's allocate access properly
	if match then -- If they have some sort of access
		local account = ply:Nick() -- Let's grab the account name, defaulting to the nick
		for name, v in pairs( ucl.users ) do
			if v == match then
				account = name
				break
			end
		end

		match = table.Copy( match ) -- We'll want to add some custom information
		
		-- Make sure we're only adding valid groups.
		local groups = {}
		for _, group in ipairs( match.groups ) do
			if ucl.groups[ group ] then
				table.insert( groups, group )
			end
		end
		match.groups = groups

		if table.Count( match.groups ) == 0 then
			match = table.Copy( ULib.DEFAULT_GRANT_ACCESS ) -- All invalid groups or some other error, default to this.
		end
		
		match.uniqueid = ply:UniqueID()
		match.account = account

		if match.pass and match.pass ~= "" then -- If there's a password, put them on the awaiting list.
			local passtimeout = GetConVarNumber( "ulib_passtimeout" )
			passtimeout = passtimeout * 60 -- Convert to minutes

			if match.login_time and match.login_time + passtimeout > os.time() then -- If they still have an active password from a previous map change
				ply:ChatPrint( "[UCL] Access set." ) -- Not using tsay because ULib might not be loaded client side yet
				ucl.authed[ ply ] = match
				ucl.callCallbacks( ply )
				local timeago = os.time() - match.login_time -- How long ago did they login in?
				timer.Simple( passtimeout - timeago, ucl.passTimeout, ply, match.pass )
				return  -- They have access, we're done.
			end

			ucl.awaitingauth[ ply ] = match -- They don't have an active password, put them on the backburner

			if util.tobool( match.pass_req ) then -- If the password is required, we have special steps.
				local passtime = GetConVarNumber( "ulib_passtimeout" )

				ULib.tsay( ply, "[UCL] You *MUST* enter your user password using the command \"_pw\" within " .. passtime .. " seconds, or be kicked." )
				timer.Simple( passtime, ucl.checkAuth, ply )
			else
				ULib.tsay( ply, "[UCL] Please enter your user password using the command \"_pw\" to claim your admin access." )
			end

		else -- If they don't need a password, they're set!
			match.pass = nil
			ply:ChatPrint( "[UCL] Access set." ) -- Not using tsay because ULib might not be loaded client side yet
			ucl.authed[ ply ] = match
			ucl.callCallbacks( ply ) -- Let others know they got access.
		end

	else -- They have no access, let's tell our callback.
		ucl.callCallbacks( ply )
	end
end


--[[
	Function: ucl.checkPass

	The callback for "_pw". *DO NOT CALL DIRECTLY*.

	Parameters:

		ply - The player to check
		command - The command
		argv - The argv
		args - The password
]]
function ucl.checkPass( ply, command, argv, args )
	if not ucl.awaitingauth[ ply ] then
		if ucl.authed[ ply ] then
			ULib.console( ply, "[UCL] You are already authenticated." )
			return
		else
			ULib.console( ply, "[UCL] Why are you trying to enter a password when you have no access at all?" )
			return
		end
	end

	local pass = ULib.stripQuotes( args )

	if pass == ucl.awaitingauth[ ply ].pass then -- They got the right pass.
		ucl.authed[ ply ] = ucl.awaitingauth[ ply ]

		-- TODO: Add a handler for saving login time.

		local passtimeout = GetConVarNumber( "ulib_passtimeout" )
		passtimeout = passtimeout * 60 -- Convert to minutes
		timer.Simple( passtimeout, ucl.passTimeout, ply, pass ) -- Add a timer for their password timeout

		ucl.awaitingauth[ ply ] = nil -- They are now authed, take them off awaiting.
		ucl.authed[ ply ].pass = nil

		ULib.console( ply, "[UCL] Correct password, thank you!" )

		ucl.callCallbacks( ply ) -- Let others know they got access
	else
		ULib.console( ply, "[UCL] Incorrect password, please try again." )
	end
end


--[[
	Function: ucl.checkAuth

	The callback to make sure users enter their password within the time limit. *DO NOT CALL DIRECTLY*.

	Parameters:

		ply - The player.
]]
function ucl.checkAuth( ply )
	if not ply:IsValid() or not ply:IsConnected() then
		ucl.awaitingauth[ ply ] = nil
		ucl.authed[ ply ] = nil
	end

	if not ucl.awaitingauth[ ply ] or ply:UniqueID() ~= ucl.awaitingauth[ ply ].uniqueid then
		return -- They already authed or a different player
	end

	local name = ply:Nick()
	ULib.console( ply, "[UCL] Password timeout, good bye." )
	ULib.kick( ply )
	ULib.tsay( _, "[UCL] " .. name .. " was kicked due to password timeout." )
end


--[[
	Function: ucl.passTimeout

	The callback to time out user's passwords. *DO NOT CALL DIRECTLY*.

	Parameters:

		ply - The player.
		pass - Their pass.
]]
function ucl.passTimeout( ply, pass )
	if not ply:IsValid() or not ply:IsConnected() then
		ucl.awaitingauth[ ply ] = nil
		ucl.authed[ ply ] = nil
	end

	if not ucl.authed[ ply ] or ucl.authed[ ply ].uniqueid ~= ply:UniqueID() then
		return -- Return if they're disconnected or a different player
	end

	ULib.tsay( ply, "[UCL] Your password has timed out, please enter your user password using the command \"_pw\" to reclaim your admin access." )
	ucl.awaitingauth[ ply ] = ucl.authed[ ply ]
	ucl.authed[ ply ] = nil

	ucl.awaitingauth[ ply ].pass = pass -- Set them back up to get auth
end

-- This is holding our already registered access strings so we don't register them again.
local registered

-- This is a little utility function to write a group access (used by registerAccess). This should also mark the end of the load phase.
local function writeGroup( group )
	if group then
		ucl.addGroup( group, ucl.groups[ group ], true, ucl.groups[ group ].inherit_from ) -- Write it
	end
	
	if registered then
		file.Write( ULib.UCL_REGISTERED, ULib.makeKeyValues( registered ) )
		registered = nil -- So we're not making now useless information take up memory.
	end
end

--[[
	Function: ucl.registerAccess

	Register an access string defaulting to certain groups. This function is completely optional,
	it just makes it so you don't have to manually add every access string to groups.txt. Will only
	give access to the group once.

	Parameters:

		access - The access string. (IE, "ulx slap")
		groups - Either a string of a group or a table of groups to give the default access to.
]]
function ucl.registerAccess( access, groups )
	access = access:lower()
	if type( groups ) == "string" then
		groups = { groups }
	end

	registered = registered or ULib.parseKeyValues( file.Read( ULib.UCL_REGISTERED ) or "" ) or {}
	timer.Create( "WriteReg", 1, 1, writeGroup ) -- We're doing this whether or not we have a new one so we can clear the var 'registered'

	if not table.HasValue( registered, access ) then
		table.insert( registered, access )

		for _, group in ipairs( groups ) do
			if not ucl.groups[ group ] then
				ucl.addGroup( group )
			end

			local allows = ucl.groups[ group ].allow
			table.insert( allows, access )

			timer.Create( group .. "Write", 1, 1, writeGroup, group ) -- We're doing this whether or not we have a new one so we can clear the var 'registered'
		end
	end
end


---------------------
--//Initial Setup//--
---------------------

ULib.concommand( "_pw", ucl.checkPass )


-- Now let's load our database and add from the default users.txt as necessary.
do
	if not file.Exists( ULib.UCL_USERS ) or not file.Exists( ULib.UCL_GROUPS ) then
		ULib.error( "FATAL: Missing users.txt and/or groups.txt!" )
		return
	end

	local users = ULib.parseKeyValues( file.Read( ULib.UCL_USERS ), true )
	local groups = ULib.parseKeyValues( file.Read( ULib.UCL_GROUPS ), true )

	if not users or not groups then
		ULib.error( "FATAL: Unable to load users.txt and/or groups.txt" )
		return
	end

	for group, acl in pairs( groups ) do
		ucl.addGroup( group, acl, _, acl.inherit_from )
	end

	for account, info in pairs( users ) do
		ucl.addUser( account, info.type, info.id, info.groups, {allow=info.allow, deny=info.deny}, info.pass, info.pass_req )
	end
end

-- Let's probe any players that may be connected right now.
do
	local players = player.GetAll()
	for _, player in ipairs( players ) do
		if player:IsConnected() then
			ucl.probe( player )
		end
	end
end

-- Utility function to send our UCL info
local function sendUCL( acl, filter )
	local sends = {
		["ULibAllowUCL"] = "allow",
		["ULibDenyUCL"] = "deny",
	}

	for title, key in pairs( sends ) do
		if acl[ key ] then
			local t = {}
			local totalsize = 0
			for _, access in ipairs( acl[ key ] ) do -- We're going to loop until we have just under our limit, send it, then repeat.
				local len = access:len() + 1
				if len + totalsize > 235 then
					umsg.Start( title, filter )
						umsg.Char( #t )
						for _, access2 in ipairs( t ) do
							umsg.String( access2 )
						end
					umsg.End()
					t = {}
					totalsize = 0
				end
	
				totalsize = totalsize + len
				table.insert( t, access )
			end
	
			if #t > 0 then -- Send the last bit
				umsg.Start( title, filter )
					umsg.Char( #t )
					for _, access2 in ipairs( t ) do
						umsg.String( access2 )
					end
				umsg.End()
			end
		end
	end
end

--[[
	Function: ucl.initClient

	The callback to initialize client with relevant information. *DO NOT CALL DIRECTLY*.
	
	Parameters:
		
		ply - The player.
]]
function ucl.initClient( ply )	
	if ucl.authed[ ply ] then -- If they have access
		-- Send info
		local basicinfo = table.Copy( ucl.authed[ ply ] )
		basicinfo.allow = nil
		basicinfo.deny = nil

		umsg.Start( "ULibUserUCL", ply )
			umsg.Entity( ply )
			ULib.umsgSend( basicinfo )
		umsg.End()
		sendUCL( ucl.authed[ ply ], ply ) -- Send 'em their UCL

		local groups = ply:GetGroups( true )
		if groups then
			for _, groupname in ipairs( groups ) do
				if ucl.groups[ groupname ] then
					local basicinfo = table.Copy( ucl.groups[ groupname ] )
					basicinfo.allow = nil
					basicinfo.deny = nil

					umsg.Start( "ULibGroupUCL", ply )
						umsg.String( groupname )
						ULib.umsgSend( basicinfo )
					umsg.End()
					sendUCL( ucl.groups[ groupname ], ply ) -- Send them the group UCL
				end
			end
		end
		
		-- Now we're going to send some public information
		local filter = RecipientFilter()
		filter:AddAllPlayers()
		filter:RemovePlayer( ply )
		local data = { allow={}, deny={}, groups=ucl.authed[ ply ].groups }
		umsg.Start( "ULibUserUCL", filter )
			umsg.Entity( ply )
			ULib.umsgSend( data )
		umsg.End()
	end

	umsg.Start( "ULibFinishedUCL", ply )
	umsg.End()

	-- Now we'll send information on all currently connected players to the new player
	local players = player.GetAll()
	for _, ply2 in ipairs( players ) do
		if ply ~= ply2 and ucl.authed[ ply2 ] then -- If we have anything to tell them about...
			local data = { allow={}, deny={}, groups=ucl.authed[ ply2 ].groups }
			umsg.Start( "ULibUserUCL", ply )
				umsg.Entity( ply2 )
				ULib.umsgSend( data )
			umsg.End()
		end
	end
end
hook.Add( "ULibPlayerULibLoaded", "ULibInitPlayer", ucl.initClient ) -- We know that they will definitely have been probed by this time

--[[
	Variable: PASSWORD_TIME

	Default password time for authenticating
]]
local PASSWORD_TIME = 30
ULib.convar( "ulib_passtime", PASSWORD_TIME, ULib.ACCESS_ADMIN )


--[[
	Variable: PASSWORD_TIMEOUT

	Default password timeout in minutes (at which point they'll have to re-enter their password).
]]
local PASSWORD_TIMEOUT = 60
ULib.convar( "ulib_passtimeout", PASSWORD_TIMEOUT, ULib.ACCESS_ADMIN )