
local hook 			= hook
local HTTPGet 		= HTTPGet
local pairs 		= pairs
local pcall			= pcall
local table			= table
local ErrorNoHalt	= ErrorNoHalt

/*---------------------------------------------------------
	HTTP Module. Interaction with HTTP.
---------------------------------------------------------*/

module("http")

Processes = {}

/*---------------------------------------------------------
	Get the contents of a webpage.
	
	Callback should be 
	
	function callback( (args optional), contents, size )
	
---------------------------------------------------------*/
function Get( url, headers, callback, ... )

	local http = HTTPGet()
	http:Download( url, headers )

	table.insert( Processes, { http = http, callback = callback, args = {...} } )
	
	return http

end




local function RunProcess( p )

	if ( !p.http:Finished() ) then return false end

	if ( #p.args == 0 ) then

		local bOk, strReturn = pcall( p.callback, p.http:GetBuffer(), p.http:DownloadSize() )
		if ( !bOk ) then
			ErrorNoHalt( strReturn )
		end
	
	else
	
		local bOk, strReturn = pcall( p.callback, p.args, p.http:GetBuffer(), p.http:DownloadSize() )
		if ( !bOk ) then
			ErrorNoHalt( strReturn )
		end
		
	end

	return true

end

local function HTTPThink()

	for k, v in pairs( Processes ) do
		if ( RunProcess( v ) ) then
			Processes[ k ] = nil
		end
	end

end

hook.Add( "Think", "HTTPThink", HTTPThink )
