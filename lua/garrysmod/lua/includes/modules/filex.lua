local file = file

module( "filex" )

function Append( filename, str )

	if ( file.IsDir( filename ) ) then return end
	
	local write_str = ""
	if ( file.Exists( filename ) ) then
		write_str = file.Read( filename ) .. str
	else
		write_str = write_str .. str
	end
	
	return file.Write( filename, write_str )
	
end
