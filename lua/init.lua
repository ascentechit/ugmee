ULib = {}       

function ULib.makePatternSafe( str )
         return str:gsub( "([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1" )
end

function ULib.stripComments( str, comment, blockcommentbeg, blockcommentend )
	if blockcommentbeg and string.sub( blockcommentbeg, 1, string.len( comment ) ) == comment then -- If the first of the block comment is the linecomment ( IE: --[[ and -- ).
		string.gsub( str, ULib.makePatternSafe( comment ) .. "[%S \t]*", function ( match )
			if string.sub( match, 1, string.len( blockcommentbeg ) ) == blockcommentbeg then
				return "" -- No substitution, this is a block comment.
			end
			str = string.gsub( str, ULib.makePatternSafe( match ), "", 1 )
			return ""
		end )

		str = string.gsub( str, ULib.makePatternSafe( blockcommentbeg ) .. ".-" .. ULib.makePatternSafe( blockcommentend ), "" )
	else -- Doesn't need special processing.
		str = string.gsub( str, ULib.makePatternSafe( comment ) .. "[%S \t]*", "" )
		if blockcommentbeg and blockcommentend then
			str = string.gsub( str, ULib.makePatternSafe( blockcommentbeg ) .. ".-" .. ULib.makePatternSafe( blockcommentend ), "" )
		end
	end

	return str
end         

function ULib.explode( separator, str, limit )
	local t = {}
	local curpos = 1
	while true do -- We have a break in the loop
		local newpos, endpos = str:find( separator, curpos ) -- find the next separator in the string
		if newpos ~= nil then -- if found then..
			table.insert( t, str:sub( curpos, newpos - 1 ) ) -- Save it in our table.
			curpos = endpos + 1 -- save just after where we found it for searching next time.
		else
			if limit and table.getn( t ) > limit then
				return t -- Reached limit
			end
			table.insert( t, str:sub( curpos ) ) -- Save what's left in our array.
			break
		end
	end

	return t
end

gm = {}
gm.path = "./garrysmod/lua;./garrysmod/lua/includes"

function include( path )
	local paths = ULib.explode( ";", gm.path )
	for _, v in ipairs( paths ) do
		file = io.open( v .. "/" .. path )
		print( file, v .. "./" .. path )
		if file then
			local str = file:read( "*a" )
			assert( loadstring( ULib.stripComments( str, "//", "/*", "*/" ) ) )()
			return
		end
	end             
	print( "Couldn't include file '" .. path .. "' (File not found)" )
end

local oldRequire = require
function require( file )
	--package.path = package.path .. ";./garrysmod/lua/includes/modules/?.lua"   
	include( file )
end

function Msg( str )
	io.stdout:write( str )
end