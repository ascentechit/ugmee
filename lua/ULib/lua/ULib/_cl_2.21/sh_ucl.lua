


ULib.ucl = {}
local ucl = ULib.ucl 




ucl.users = {}
ucl.groups = {}
ucl.authed = {}
ucl.awaitingauth = {}
ucl.callbacks = {}





function ucl.query( ply, access, hide )
	if SERVER and (not ply:IsValid() or (not hide and ply:IsListenServerHost())) then return true end 
	access = access:lower() 

	
	local denies = { ucl.authed[ ply ].deny }
	local allows = { ucl.authed[ ply ].allow }

	
	for _, v in ipairs( ucl.authed[ ply ].groups ) do
		if ucl.groups[ v ] then
			table.insert( denies, ucl.groups[ v ].deny )
			table.insert( allows, ucl.groups[ v ].allow )
		end
	end

	
	local othergroups = ply:GetGroups( true )
	for _, group in ipairs( othergroups ) do
		if not table.HasValue( ucl.authed[ ply ].groups, group ) then 
			if ucl.groups[ group ] then 
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

	
	return false
end





local meta = FindMetaTable( "Player" )
if not meta then return end


function meta:IsAdmin()
	if self:IsSuperAdmin() then return true end
	if self:IsUserGroup( "admin" ) then return true end

	return false
end


function meta:IsSuperAdmin()
	
	if SERVER and self:IsListenServerHost() then return true end

	return self:IsUserGroup( "superadmin" )
end


function meta:IsUserGroup( name )
	if name == ULib.ACCESS_ALL then return true end 
	if name == ULib.ACCESS_NONE then return false end 

	if not ucl.authed[ self ] then return false end

	local groups = self:GetGroups( true )
	return table.HasValue( groups, name )
end


function meta:GetGroups( do_chain )
	if not ucl.authed[ self ] or not ucl.authed[ self ].groups then return nil end 

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


function meta:SetUserGroup( group )
	if CLIENT then return end 

	if not ULib.UCL_LOAD_DEFAULT then return end 
	if not ucl.groups[ group ] then ucl.addGroup( group, _, true ) end 

	if not ucl.authed[ self ] then ucl.probe( self ) end

	if table.HasValue( ucl.authed[ self ].groups ) then return end 

	table.insert( ucl.authed[ self ].groups, group )
end


function meta:query( access, hide )
	return ULib.ucl.query( self, access, hide )
end






function ucl.callCallbacks( ply )
	for _, fn in ipairs( ucl.callbacks ) do
		local hasAccess = not not ucl.authed[ ply ] 
		PCallError( fn, ply, hasAccess )
	end
end



function ucl.addAccessCallback( fn )
	table.insert( ucl.callbacks, fn )
end

if CLIENT then 

	local curTable 

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