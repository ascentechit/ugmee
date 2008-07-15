
/*---------------------------------------------------------
   Name: string.ToTable( string )
---------------------------------------------------------*/
function string.ToTable ( str )

	local tab = {}
	
	for i=1, string.len( str ) do
		table.insert( tab, string.sub( str, i, i ) )
	end
	
	return tab

end

/*---------------------------------------------------------
   Name: explode(seperator ,string)
   Desc: Takes a string and turns it into a table
   Usage: string.explode( " ", "Seperate this string")
---------------------------------------------------------*/
function string.Explode ( seperator, str )

	if ( seperator == "" ) then
		return string.ToTable( str )
	end

	local tble={}	
	local ll=0
	
	while (true) do
	
		l = string.find( str, seperator, ll, true )
		
		if (l != nil) then
			table.insert(tble, string.sub(str,ll,l-1)) 
			ll=l+1
		else
			table.insert(tble, string.sub(str,ll))
			break
		end
		
	end
	
	return tble
	
end

/*---------------------------------------------------------
   Name: implode(seperator ,Table)
   Desc: Takes a table and turns it into a string
   Usage: string.implode( " ", {"This", "Is", "A", "Table"})
---------------------------------------------------------*/
function string.Implode(seperator,Table) return 
	table.concat(Table,seperator) 
end


/*---------------------------------------------------------
   Name: GetExtensionFromFilename(path)
   Desc: Returns extension from path
   Usage: string.GetExtensionFromFilename("garrysmod/lua/modules/string.lua")
---------------------------------------------------------*/
function string.GetExtensionFromFilename(path)
	local ExplTable = string.ToTable( path )
	for i = table.getn(ExplTable), 1, -1 do
		if ExplTable[i] == "." then return string.sub(path, i+1)end
		if ExplTable[i] == "/" or ExplTable[i] == "\\" then return "" end
	end
	return ""
end
/*---------------------------------------------------------
   Name: GetPathFromFilename(path)
   Desc: Returns path from filepath
   Usage: string.GetPathFromFilename("garrysmod/lua/modules/string.lua")
---------------------------------------------------------*/
function string.GetPathFromFilename(path)
	local ExplTable = string.ToTable( path )
	for i = table.getn(ExplTable), 1, -1 do
		if ExplTable[i] == "/" or ExplTable[i] == "\\" then return string.sub(path, 1, i) end
	end
	return ""
end
/*---------------------------------------------------------
   Name: GetFileFromFilename(path)
   Desc: Returns file with extension from path
   Usage: string.GetFileFromFilename("garrysmod/lua/modules/string.lua")
---------------------------------------------------------*/
function string.GetFileFromFilename(path)
	local ExplTable = string.ToTable( path )
	for i = table.getn(ExplTable), 1, -1 do
		if ExplTable[i] == "/" or ExplTable[i] == "\\" then return string.sub(path, i) end
	end
	return ""
end

/*-----------------------------------------------------------------
   Name: FormattedTime( TimeInSeconds, Format )
   Desc: Given a time in seconds, returns formatted time
         If 'Format' is not specified the function returns a table 
         conatining values for hours, mins, secs, ms

   Examples: string.FormattedTime( 123.456, "%02i:%02i:%02i")  ==> "02:03:45"
             string.FormattedTime( 123.456, "%02i:%02i")       ==> "02:03"
             string.FormattedTime( 123.456, "%2i:%02i")        ==> " 2:03"
             string.FormattedTime( 123.456 )        		==> {h = 0, m = 2, s = 3, ms = 45}
-----------------------------------------------------------------*/

function string.FormattedTime( TimeInSeconds, Format )
	if not TimeInSeconds then TimeInSeconds = 0 end

	local i = math.floor( TimeInSeconds )
	local h,m,s,ms	=	( i/3600 ),
				( i/60 )-( math.floor( i/3600 )*3600 ),
				TimeInSeconds-( math.floor( i/60 )*60 ),
				( TimeInSeconds-i )*100

	if Format then
		return string.format( Format, m, s, ms )
	else
		return { h=h, m=m, s=s, ms=ms }
	end
end

/*---------------------------------------------------------
   Name: Old time functions
---------------------------------------------------------*/

function string.ToMinutesSecondsMilliseconds( TimeInSeconds )	return string.FormattedTime( TimeInSeconds, "%02i:%02i:%02i")	end
function string.ToMinutesSeconds( TimeInSeconds )		return string.FormattedTime( TimeInSeconds, "%02i:%02i")	end



function string.Left(str, num)
	return string.sub(str, 1, num)
end

function string.Right(str, num)
	return string.sub(str, -num)
end



function string.Replace(str, tofind, toreplace)
	local start = 1
	while (true) do
		local pos = string.find(str, tofind, start, true)
	
		if (pos == nil) then
			break
		end
		
		local left = string.sub(str, 1, pos-1)
		local right = string.sub(str, pos + #tofind)
		
		str = left .. toreplace .. right
		start = pos + #toreplace
	end
	return str
end

/*---------------------------------------------------------
   Name: Trim(s)
   Desc: Removes leading and trailing spaces from a string.
		 Optionally pass char to trim that character from the ends instead of space
---------------------------------------------------------*/
function string.Trim( s, char )
	if (char==nil) then char = "%s" end
	return string.gsub(s, "^".. char.."*(.-)"..char.."*$", "%1")
end

/*---------------------------------------------------------
   Name: TrimRight(s)
   Desc: Removes leading and trailing spaces from a string.
		 Optionally pass char to trim that character from the ends instead of space
---------------------------------------------------------*/
function string.TrimRight( s, char )
	
	if (char==nil) then char = " " end	
	
	if ( string.sub( s, -1 ) == char ) then
		s = string.sub( s, 0, -2 )
		s = string.TrimRight( s, char )
	end
	
	return s
	
end

/*---------------------------------------------------------
   Name: TrimLeft(s)
   Desc: Removes leading and trailing spaces from a string.
		 Optionally pass char to trim that character from the ends instead of space
---------------------------------------------------------*/
function string.TrimLeft( s, char )

	if (char==nil) then char = " " end	
	
	if ( string.sub( s, 1 ) == char ) then
		s = string.sub( s, 1 )
		s = string.TrimLeft( s, char )
	end
	
	return s

end

