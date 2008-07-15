//======================================================//
//  ___  ___   _   _   _    __   _   ___ ___ __ __
// |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
//  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
//  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2007
//										 
//	
//	Backwards compatibility functions.
//
//=====================================================//

//
// These functions have been moved from util to 
// pure globals. Use either way.
//

if ( util ) then
	util.KeyValuesToTable = KeyValuesToTable
	util.TableToKeyValues = TableToKeyValues
end
