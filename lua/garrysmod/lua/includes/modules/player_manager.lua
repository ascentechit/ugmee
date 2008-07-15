
local hook = hook
local player = player
local pairs = pairs
local Msg = Msg

module("player_manager")


// If a player doesn't have a valid model set they will use this one by default
local DefaultPlayerModel = "models/player/Kleiner.mdl"

// Stores a table of valid player models
local ModelList = {}

/*---------------------------------------------------------
   Utility to add models to the acceptable model list
---------------------------------------------------------*/
function AddValidModel( name, model )
	ModelList[ name ] = model
end


/*---------------------------------------------------------
   Translate the simple name of a model 
   into the full model name
---------------------------------------------------------*/
function TranslatePlayerModel( name )

	if ( ModelList[ name ] != nil ) then
		return ModelList[ name ]
	end
	
	return DefaultPlayerModel
end


/*---------------------------------------------------------
   Compile a list of valid player models
---------------------------------------------------------*/
AddValidModel( "alyx",		"models/player/alyx.mdl" )
AddValidModel( "barney",	"models/player/barney.mdl" )	
AddValidModel( "breen",		"models/player/breen.mdl" )		
AddValidModel( "combine",	"models/player/combine_soldier.mdl" )				
AddValidModel( "prison",	"models/player/combine_soldier_prisonguard.mdl" )
AddValidModel( "super",		"models/player/combine_super_soldier.mdl" )				
AddValidModel( "eli",		"models/player/eli.mdl" )			
AddValidModel( "gman",		"models/player/gman_high.mdl" )		
AddValidModel( "kleiner",	"models/player/Kleiner.mdl" )
AddValidModel( "scientist",	"models/player/Kleiner.mdl" )
AddValidModel( "monk",		"models/player/monk.mdl" )		
AddValidModel( "mossman",	"models/player/mossman.mdl" )	
AddValidModel( "gina",		"models/player/mossman.mdl" )
AddValidModel( "odessa",	"models/player/odessa.mdl" )		
AddValidModel( "police",	"models/player/police.mdl" )		
AddValidModel( "zombie",	"models/player/classic.mdl" )
AddValidModel( "burnt",		"models/player/charple01.mdl" )	
AddValidModel( "corpse",	"models/player/corpse1.mdl" )
AddValidModel( "charple",	"models/player/charple01.mdl" )
AddValidModel( "zombine",	"models/player/zombie_soldier.mdl" )
//AddValidModel( "magnusson",	"models/player/magnusson.mdl" )
AddValidModel( "fzombie",	"models/player/Zombiefast.mdl" )
AddValidModel( "stripped",	"models/player/soldier_stripped.mdl" )

AddValidModel( "female1",		"models/player/Group01/female_01.mdl" )
AddValidModel( "female2",		"models/player/Group01/female_02.mdl" )
AddValidModel( "female3",		"models/player/Group01/female_03.mdl" )
AddValidModel( "female4",		"models/player/Group01/female_04.mdl" )
AddValidModel( "female5",		"models/player/Group01/female_06.mdl" )
AddValidModel( "female6",		"models/player/Group01/female_07.mdl" )
AddValidModel( "female7",		"models/player/Group03/female_01.mdl" )
AddValidModel( "female8",		"models/player/Group03/female_02.mdl" )
AddValidModel( "female9",		"models/player/Group03/female_03.mdl" )
AddValidModel( "female10",		"models/player/Group03/female_04.mdl" )
AddValidModel( "female11",		"models/player/Group03/female_06.mdl" )
AddValidModel( "female12",		"models/player/Group03/female_07.mdl" )

AddValidModel( "male1",		"models/player/Group01/male_01.mdl" )
AddValidModel( "male2",		"models/player/Group01/male_02.mdl" )
AddValidModel( "male3",		"models/player/Group01/male_03.mdl" )
AddValidModel( "male4",		"models/player/Group01/male_04.mdl" )
AddValidModel( "male5",		"models/player/Group01/male_05.mdl" )
AddValidModel( "male6",		"models/player/Group01/male_06.mdl" )
AddValidModel( "male7",		"models/player/Group01/male_07.mdl" )
AddValidModel( "male8",		"models/player/Group01/male_08.mdl" )
AddValidModel( "male9",		"models/player/Group01/male_09.mdl" )

AddValidModel( "male10",		"models/player/Group03/male_01.mdl" )
AddValidModel( "male11",		"models/player/Group03/male_02.mdl" )
AddValidModel( "male12",		"models/player/Group03/male_03.mdl" )
AddValidModel( "male13",		"models/player/Group03/male_04.mdl" )
AddValidModel( "male14",		"models/player/Group03/male_05.mdl" )
AddValidModel( "male15",		"models/player/Group03/male_06.mdl" )
AddValidModel( "male16",		"models/player/Group03/male_07.mdl" )
AddValidModel( "male17",		"models/player/Group03/male_08.mdl" )
AddValidModel( "male18",		"models/player/Group03/male_09.mdl" )