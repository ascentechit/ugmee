--[[
	Title: Miscellaneous

	Some utility functions. Unlike the functions in util.lua, this file only holds non-HL2 specific functions.
]]

--[[
	Function: explode

	Split a string by a separator.

	Parameters:

		separator - The separator string.
		str - A string.
		limit - *(Optional)* Max number of elements in the table

	Returns:

		A table of str split by separator, nil and error message otherwise.

	Revisions:

		v2.10 - Initial (dragged over from a GM9 archive though)
]]
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


--[[
	Function: stripComments

	Strips comments from a string

	Parameters:

		str - The string to stip comments from
		comment - The comment string. If it's found, whatever comes after it on that line is ignored. ( IE: "//" )
		blockcommentbeg - *(Optional)* The block comment begin string. ( IE: "/*" )
		blockcommentend - *(Optional, must be specified if above parameter is)* The block comment end string. ( IE: "*/" )

	Returns:

		The string with the comments stripped, nil and error otherwise.

	Revisions:

		v2.02 - Fixed block comments in more complicated files.
]]
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


--[[
	Function: makePatternSafe

	Makes a string safe for pattern usage, like in string.gsub(). Basically replaces all keywords with % and keyword.

	Parameters:

		str - The string to make pattern safe

	Returns:

		The pattern safe string
]]
function ULib.makePatternSafe( str )
         return str:gsub( "([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1" )
end


--[[
	Function: stripQuotes

	Trims leading and tailing quotes from a string

	Parameters:

		s - The string to strip

	Returns:

		The stripped string
]]
function ULib.stripQuotes( s )
	return s:gsub( "^%s*[\"]*(.-)[\"]*%s*$", "%1" )
end


--[[
	Function: splitArgs

	This is similar to string.Explode( " ", str ) except that it will also obey quotation marks.

	Parameters:

		str - The string to split from

	Returns:

		A table containing the individual arguments

	Example:

		:ULib.splitArgs( "This is a \"Cool sentence to\" make \"split up\"" )

		returns...

		{ "This", "is", "a", "Cool sentence to", "make", "split up" }

	Revisions:

		v2.10 - Can now handle tabs and trims strings before returning.
]]
function ULib.splitArgs( str )
	str = string.Trim( str )
	if str == "" then return {} end
	local quotes = {}
	local t = {}
	local marker = "^*#" -- This is used as a placeholder

	str:gsub( "%b\"\"", function ( match ) -- We're finding the quote groups first.
		local s = ULib.stripQuotes( match )
		table.insert( quotes, s )

		str = str:gsub( ULib.makePatternSafe( match ), marker .. #quotes, 1 ) -- We aren't sure where in the table this should be placed, so let's leave a marker.
	end )

	t = ULib.explode( "%s+", str )

	-- Now trim 'em
	for i, v in ipairs( t ) do
		t[ i ] = string.Trim( v )
	end

	for i, v in ipairs( t ) do
		if v:sub( 1, 3 ) == marker then -- Now we can read our marker into the correct place in the table.
			local num = tonumber( string.sub( v, 4 ) )
			t[ i ] = quotes[ num ]
		end
	end

	return t
end


--[[
	Function: parseKeyValues

	Parses a keyvalue formatted string into a table.

	Parameters:

		str - The string to parse.
		convert - *(Optional, defaults to false)* Setting this to true will convert garry's keyvalues to a better form. This has two effects.
		  First, it will remove the "Out"{} wrapper. Second, it will convert any keys that equate to a number to a number.

	Returns:

		The table, nil and error otherwise. *If you find you're missing information from the table, the file format might be incorrect.*

	Example format:
:test
:{
:	"howdy"   "bbq"
:
:	foo
:	{
:		"bar"   "false"
:	}
:
:}

	Revisions:

		v2.10 - Initial (but tastefully stolen from a GM9 version)
]]
function ULib.parseKeyValues( str, convert )
	str = ULib.stripComments( str, "//" )
	local lines = string.Explode( "\n", str )
	local pos = 1
	local t = {}

	while pos <= #lines do
		local args = ULib.splitArgs( string.Trim( lines[ pos ] ) )

		if #args == 1 then
			-- First thing's first. If we hit a table, find where it ends and pass it back into ourselves.
			if pos ~= #lines and string.Trim( lines[ pos + 1 ] ) == "{" then -- Beginning a new table
				local endpos = pos + 1 -- Keep track of endpos. This is the line we're working with right now. We'll bump it up when we move along.
				local inline = 0 -- Keep track of how many recursing tables we're into.
				while true do -- We have breaks inside
					endpos = endpos + 1
					if endpos > #lines then return nil, "Bracket ( \"{\" and \"}\" ) mismatch!" end

					if string.Trim( lines[ endpos ] ) == "{" then inline = inline + 1 end

					if string.Trim( lines[ endpos ] ) == "}" then
						if inline > 0 then inline = inline - 1
						else break end
					end
				end

				t[ args[ 1 ] ] = ULib.parseKeyValues( table.concat( lines, "\n", pos + 2, endpos - 1 ) ) -- Pass the whole section (minus the brakcets) back into ourselves

				pos = endpos -- Now we can move up
			else
				table.insert( t, args[ 1 ] ) -- If it's not a table, it must be an ordered pair.
			end
		elseif #args == 2 then
			if convert and tonumber( args[ 1 ] ) then
				t[ tonumber( args[ 1 ] ) ] = args[ 2 ]
			else
				t[ args[ 1 ] ] = args[ 2 ]
			end
		elseif #args == 0 then
			-- Empty string, ignore.
		else
			return nil, "Incorrect syntax!"
		end
		pos = pos + 1
	end

	if convert and table.Count( t ) == 1 and t.Out then -- If we caught a stupid garry-wrapper
		t = t.Out
	end

	return t
end


--[[
	Function: makeKeyValues

	Makes a key values string from a table.

	Parameters:

		t - The table to make the keyvalues from. This can only contain tables, numbers, and strings.
		tab - *Only for internal use*, this helps make inline tables look better.
		completed - A list of table values that have already been parsed, this is *only for internal use* to make sure we don't hit an infinite loop.

	Returns:

		The string, nil and error otherwise.

	Notes:

		If you use numbers as keys in the table, just the values will be used.

	Example table format:
:{ test = { howdy = "bbq", foo = { bar = "false" } } }

	Example return format:
:test
:{
:	"howdy"   "bbq"
:
:	foo
:	{
:		"bar"   "false"
:	}
:
:}

	Revisions:

		v2.10 - Initial (but tastefully stolen from a GM9 version)
]]
function ULib.makeKeyValues( t, tab, completed )
	tab = tab or ""
	completed = completed or {}
	if table.HasValue( completed, t ) then return "" end -- We've already done this table.
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


--[[
	Function: toBool

	Converts a string or number to a bool

	Parameters:

		x - The string or number

	Returns:

		The bool

	Revisions:

		v2.10 - Initial
]]
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


-- This wonderful bit of following code will make sure that no rogue coder can screw us up by changing the value of '_'
_ = nil -- Make sure we're starting out right.
local old__newindex = _G.__newindex
setmetatable( _G, _G )
function _G.__newindex( t, k, v )
	if k == "_" then
		-- If you care enough to fix bad scripts uncomment this following line.
		-- error( "attempt to modify global variable '_'", 2 )
		return
	end

	if old__newindex then
		old__newindex( t, k, v )
	else
		rawset( t, k, v )
	end
end