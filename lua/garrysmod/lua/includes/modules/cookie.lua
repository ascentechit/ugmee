
if ( !sql.TableExists( "cookies" ) ) then

	sql.Query( "CREATE TABLE IF NOT EXISTS cookies ( key TEXT NOT NULL PRIMARY KEY, value TEXT );" )
	
end


module( "cookie", package.seeall )

/*---------------------------------------------------------
   Get a String Value
---------------------------------------------------------*/
function GetString( name, default )

	name = SQLStr( name )

	local val = sql.QueryValue( "SELECT value FROM cookies WHERE key = " .. name )
	if (!val) then return default end
	
	return val
	
end


/*---------------------------------------------------------
   Get a Number Value
---------------------------------------------------------*/
function GetNumber( name, default )

	name = SQLStr( name )

	local val = sql.QueryValue( "SELECT value FROM cookies WHERE key = " .. name )
	if (!val) then return default end
	
	return tonumber( val )
	
end

/*---------------------------------------------------------
   Delete a Value
---------------------------------------------------------*/
function Delete( name )

	name = SQLStr( name )
	sql.Query( "DELETE FROM cookies WHERE key = " .. name )
	
end

/*---------------------------------------------------------
   Set a Value
---------------------------------------------------------*/
function Set( name, value )

	Delete( name )
	
	name = SQLStr( name )
	value = SQLStr( value )

	sql.Query( "INSERT INTO cookies ( key, value ) VALUES ( "..name..", "..value.." )" )
	
end




/*---------------------------------------------------------
   ClearCookies
---------------------------------------------------------*/
local function ClearCookies( ply, command, arguments )   

	sql.Query( "DELETE FROM cookies" )

end     

concommand.Add( "lua_cookieclear", ClearCookies )  


/*---------------------------------------------------------
   ClearCookies
---------------------------------------------------------*/
local function SpewCookies( ply, command, arguments )   

	local res = sql.Query( "SELECT key, value FROM cookies LIMIT 200" )
	
	for k, v in ipairs( res ) do
	
		MsgN( v['key'], " = ", v['value'] )
	
	end

end     

concommand.Add( "lua_cookiespew", SpewCookies ) 