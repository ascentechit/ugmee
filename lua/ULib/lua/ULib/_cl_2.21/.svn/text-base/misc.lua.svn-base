


function ULib.explode( separator, str, limit )
	local t = {}
	local curpos = 1
	while true do 
		local newpos, endpos = str:find( separator, curpos ) 
		if newpos ~= nil then 
			table.insert( t, str:sub( curpos, newpos - 1 ) ) 
			curpos = endpos + 1 
		else
			if limit and table.getn( t ) > limit then
				return t 
			end
			table.insert( t, str:sub( curpos ) ) 
			break
		end
	end

	return t
end



function ULib.stripComments( str, comment, blockcommentbeg, blockcommentend )
	if blockcommentbeg and string.sub( blockcommentbeg, 1, string.len( comment ) ) == comment then 
		string.gsub( str, ULib.makePatternSafe( comment ) .. "[%S \t]*", function ( match )
			if string.sub( match, 1, string.len( blockcommentbeg ) ) == blockcommentbeg then
				return "" 
			end
			str = string.gsub( str, ULib.makePatternSafe( match ), "", 1 )
			return ""
		end )

		str = string.gsub( str, ULib.makePatternSafe( blockcommentbeg ) .. ".-" .. ULib.makePatternSafe( blockcommentend ), "" )
	else 
		str = string.gsub( str, ULib.makePatternSafe( comment ) .. "[%S \t]*", "" )
		if blockcommentbeg and blockcommentend then
			str = string.gsub( str, ULib.makePatternSafe( blockcommentbeg ) .. ".-" .. ULib.makePatternSafe( blockcommentend ), "" )
		end
	end

	return str
end



function ULib.makePatternSafe( str )
         return str:gsub( "([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1" )
end



function ULib.stripQuotes( s )
	return s:gsub( "^%s*[\"]*(.-)[\"]*%s*$", "%1" )
end



function ULib.splitArgs( str )
	str = string.Trim( str )
	if str == "" then return {} end
	local quotes = {}
	local t = {}
	local marker = "^*#" 

	str:gsub( "%b\"\"", function ( match ) 
		local s = ULib.stripQuotes( match )
		table.insert( quotes, s )

		str = str:gsub( ULib.makePatternSafe( match ), marker .. #quotes, 1 ) 
	end )

	t = ULib.explode( "%s+", str )

	
	for i, v in ipairs( t ) do
		t[ i ] = string.Trim( v )
	end

	for i, v in ipairs( t ) do
		if v:sub( 1, 3 ) == marker then 
			local num = tonumber( string.sub( v, 4 ) )
			t[ i ] = quotes[ num ]
		end
	end

	return t
end



function ULib.parseKeyValues( str, convert )
	str = ULib.stripComments( str, "//" )
	local lines = string.Explode( "\n", str )
	local pos = 1
	local t = {}

	while pos <= #lines do
		local args = ULib.splitArgs( string.Trim( lines[ pos ] ) )

		if #args == 1 then
			
			if pos ~= #lines and string.Trim( lines[ pos + 1 ] ) == "{" then 
				local endpos = pos + 1 
				local inline = 0 
				while true do 
					endpos = endpos + 1
					if endpos > #lines then return nil, "Bracket ( \"{\" and \"}\" ) mismatch!" end

					if string.Trim( lines[ endpos ] ) == "{" then inline = inline + 1 end

					if string.Trim( lines[ endpos ] ) == "}" then
						if inline > 0 then inline = inline - 1
						else break end
					end
				end

				t[ args[ 1 ] ] = ULib.parseKeyValues( table.concat( lines, "\n", pos + 2, endpos - 1 ) ) 

				pos = endpos 
			else
				table.insert( t, args[ 1 ] ) 
			end
		elseif #args == 2 then
			if convert and tonumber( args[ 1 ] ) then
				t[ tonumber( args[ 1 ] ) ] = args[ 2 ]
			else
				t[ args[ 1 ] ] = args[ 2 ]
			end
		elseif #args == 0 then
			
		else
			return nil, "Incorrect syntax!"
		end
		pos = pos + 1
	end

	if convert and table.Count( t ) == 1 and t.Out then 
		t = t.Out
	end

	return t
end



function ULib.makeKeyValues( t, tab, completed )
	tab = tab or ""
	completed = completed or {}
	if table.HasValue( completed, t ) then return "" end 
	table.insert( completed, t )

	local str = ""

	for k, v in pairs( t ) do
		str = str .. tab
		if type( k ) ~= "number" then
			str = string.format( "%s%q\t", str, tostring( k ) )
		end

		if type( v ) == "table" then
			str = string.format( "%s\n%s{\n%s%s}\n", str, tab, ULib.makeKeyValues( v, tab .. "\t", completed ), tab )
		elseif type( v ) == "string" then
			str = string.format( "%s%q\n", str, v )
		else
			str = str .. tostring( v ) .. "\n"
		end
	end

	return str
end



function ULib.toBool( x )
	if tonumber( x ) ~= nil then
		x = math.Round( tonumber( x ) )
		if x == 0 then
			return false
		else
			return true
		end
	end

	x = x:lower()
	if x == "t" or x == "true" or x == "yes" or x == "y" then
		return true
	else
		return false
	end
end



_ = nil 
local old__newindex = _G.__newindex
setmetatable( _G, _G )
function _G.__newindex( t, k, v )
	if k == "_" then
		
		
		return
	end

	if old__newindex then
		old__newindex( t, k, v )
	else
		rawset( t, k, v )
	end
end