--[[
	Title: Client side file generator

	Run this to generate the client files. Output to data/_cl_<version>, but with all extensions as .lua instead of .txt
]]

local outfolder = "_cl_" .. string.format( "%.2f", ULib.VERSION )

local infolder = "../lua/ULib/shared"
local files = file.FindInLua( infolder .. "/" .. "*.lua" )
for _, f in ipairs( files ) do
	local filename = f:sub( 1, -5 ) -- strip ".lua"
	local data = ULib.stripComments( file.Read( infolder .. "/" .. f ), "--", "--[[", "]]" )
	file.Write( outfolder .. "/" .. filename .. ".txt", data )
end

local infolder = "../lua/ULib/client"
local files = file.FindInLua( infolder .. "/" .. "*.lua" )
for _, f in ipairs( files ) do
	local filename = f:sub( 1, -5 ) -- strip ".lua"
	local data = ULib.stripComments( file.Read( infolder .. "/" .. f ), "--", "--[[", "]]" )
	file.Write( outfolder .. "/" .. filename .. ".txt", data )
end