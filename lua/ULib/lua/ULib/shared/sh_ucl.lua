--[[
	Title: Shared UCL

	Shared UCL stuff.
]]

--[[
	Table: ucl

	Holds all of the ucl variables and functions
]]
ULib.ucl = {}
local ucl = ULib.ucl -- Make it easier for us to refer to

-----------------------------------
--// Setup default information //--
-----------------------------------
ucl.users = {}
ucl.groups = {}
ucl.authed = {}
ucl.awaitingauth = {}
ucl.callbacks = {}

-------------------------------------------
--//Here's the meat of our control list//--
-------------------------------------------
--[[
	Function: ucl.query

	This function is used to see if a user has access to a command.

	Parameters:

		ply - The player to check access for
		access - The access string to check for. (IE "ulx slap", doesn't have to be a command though)
		hide - *(Optional, defaults to false)* Normally, a listen host is automatically given access to everything.
			Set this to true if you want to treat the listen host as a normal user. (Will be denied commands to no one has access to)
]]
function ucl.query( ply, access, hide )
	if SERVER and (not ply:IsValid() or (not hide and ply:IsListenServerHost())) then return true end -- Grant full access to server host.
	access = access:lower() -- Case insensitive

	-- Now let's go through all applicable allows and denies for this user.
	local denies = { ucl.authed[ ply ].deny }
	local allows = { ucl.authed[ ply ].allow }

	-- We grabbed their user allow/deny, now let's grab all the group allow/denys.
	for _, v in ipairs( ucl.authed[ ply ].groups ) do
		if ucl.groups[ v ] then
			table.insert( denies, ucl.groups[ v ].deny )
			table.insert( allows, ucl.groups[ v ].allow )
		end
	end

	-- Grab anything else from our special access chain. Note that we're only taking allows.
	local othergroups = ply:GetGroups( true )
	for _, group in ipairs( othergroups ) do
		if not table.HasValue( ucl.authed[ ply ].groups, group ) then -- Something on our special chain
			if ucl.groups[ group ] then -- If there's anything to add
				table.insert( allows, ucl.groups[ group ].allow )
			end
		end
	end

	for _, v in ipairs( denies ) do
		if table.HasValue( v, access ) then return false end
	end

	for _, v in ipairs( allows ) do
		if table.HasValue( v, access ) then return true end
	end

	-- No specific instruction, assume they don't have access.
	return false
end


------------------
--//Meta hooks//--
------------------
local meta = FindMetaTable( "Player" )
if not meta then return end

--[[
	Function: Player:IsAdmin

	This function is used to see if a user is an admin. Also returns true if they're a superadmin.
]]
function meta:IsAdmin()
	if self:IsSuperAdmin() then return true end
	if self:IsUserGroup( "admin" ) then return true end

	return false
end

--[[
	Function: Player:IsSuperAdmin

	This function is used to see if a user is a superadmin.
]]
function meta:IsSuperAdmin()
	-- Always a super admin if this is our server
	if SERVER and self:IsListenServerHost() then return true end

	return self:IsUserGroup( "superadmin" )
end

--[[
	Function: Player:IsUserGroup

	This function is used to see if a user is a speccified group. Note that we handle 'operator', 'admin',
	and 'superadmin' in an access chain. If they have a top-level access it will return true to those below.
]]
function meta:IsUserGroup( name )
	if name == ULib.ACCESS_ALL then return true end -- Everyone has default access
	if name == ULib.ACCESS_NONE then return false end -- No one has this access

	if not ucl.authed[ self ] then return false end

	local groups = self:GetGroups( true )
	return table.HasValue( groups, name )
end

--[[
	Function: Player:GetGroups

	This function is used to get all the groups a player belongs to.

	Parameters:

		do_chain - *(Optional, defaults to false)* If you don't specify this it will return strictly ucl.authed[ ply ].groups.
			Otherwise it will also return groups the player belongs to in our access chain.

	Revisions:

		v2.10 - Initial
]]
function meta:GetGroups( do_chain )
	if not ucl.authed[ self ] or not ucl.authed[ self ].groups then return nil end -- Should never hit this but check anyways

	local groups = table.Copy( ucl.authed[ self ].groups )

	local function getInherits( group, done )
		if not ucl.groups[ group ] or not ucl.groups[ group ].inherit_from then return {} end

		done = done or {}
		local groups = {}

		for _, parent in ipairs( ucl.groups[ group ].inherit_from ) do
			if not table.HasValue( done, parent ) then
				table.insert( done, parent )
				table.insert( groups, parent )
				table.Add( groups, getInherits( parent, done ) )
			end
		end

		return groups
	end

	if do_chain then
		local toAdd = {}
		for _, group in ipairs( groups ) do
			table.Add( toAdd, getInherits( group ) )
		end
		table.Add( groups, toAdd )

		if not table.HasValue( groups, ULib.ACCESS_ALL ) then table.insert( groups, ULib.ACCESS_ALL ) end
	end

	return groups
end

--[[
	Function: Player:SetUserGroup

	Set a user's group. Note that it will merely add the player to an additional group.
	This function is rendered inert by setting ULib.UCL_LOAD DEFAULT to false.
]]
function meta:SetUserGroup( group )
	if CLIENT then return end -- Following default GM10 behavior, this function does nothing on the client

	if not ULib.UCL_LOAD_DEFAULT then return end -- Ignore
	if not ucl.groups[ group ] then ucl.addGroup( group, _, true ) end -- Invalid group, so create it!

	if not ucl.authed[ self ] then ucl.probe( self ) end

	if table.HasValue( ucl.authed[ self ].groups ) then return end -- Already have it

	table.insert( ucl.authed[ self ].groups, group )
end

--[[
	Function: Player:query

	This is an alias of ULib.ucl.query()
]]
function meta:query( access, hide )
	return ULib.ucl.query( self, access, hide )
end

-----------------
--//Callbacks//--
-----------------

--[[
	Function: ucl.callCallbacks

	*Internal function, DO NOT CALL DIRECTLY.* This function calls access callbacks

	Parameters:

		ply - The player object.
]]
function ucl.callCallbacks( ply )
	for _, fn in ipairs( ucl.callbacks ) do
		local hasAccess = not not ucl.authed[ ply ] -- Double not! We want it in boolean form.
		PCallError( fn, ply, hasAccess )
	end
end


--[[
	Function: ucl.addAccessCallback

	Pass a function and it will be called when someone receives access. Parameters it passes to the function are the player and an access bool.
	This function is useful for things like passing menus to users upon access. *This is also called when a user receives NO access*.

	Parameters:

		fn - The function to call.
]]
function ucl.addAccessCallback( fn )
	table.insert( ucl.callbacks, fn )
end

if CLIENT then -- Client section

	local curTable -- Hold this so we can continue operations on it

	function ucl.rcvUserData( um )
		local ply = um:ReadEntity()
		ucl.authed[ ply ] = ULib.umsgRcv( um )
		curTable = ucl.authed[ ply ]
	end
	usermessage.Hook( "ULibUserUCL", ucl.rcvUserData )

	function ucl.rcvGroupData( um )
		local group = um:ReadString()
		ucl.groups[ group ] = ULib.umsgRcv( um )
		curTable = ucl.groups[ group ]
	end
	usermessage.Hook( "ULibGroupUCL", ucl.rcvGroupData )

	function ucl.rcvAllows( um )
		curTable.allow = curTable.allow or {}

		local num = um:ReadChar()
		for i=1, num do
			table.insert( curTable.allow, um:ReadString() )
		end
	end
	usermessage.Hook( "ULibAllowUCL", ucl.rcvAllows )

	function ucl.rcvDenies( um )
		curTable.deny = curTable.deny or {}

		local num = um:ReadChar()
		for i=1, num do
			table.insert( curTable.deny, um:ReadString() )
		end
	end
	usermessage.Hook( "ULibDenyUCL", ucl.rcvDenies )

	function ucl.rcvFinished( um )
		curTable = nil
		ucl.callCallbacks( LocalPlayer() )
	end
	usermessage.Hook( "ULibFinishedUCL", ucl.rcvFinished )

end