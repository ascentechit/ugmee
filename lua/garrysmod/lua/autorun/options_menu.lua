
//
// The server only runs this file so it can send it to the client
//

if ( SERVER ) then AddCSLuaFile( "options_menu.lua" ) return end

//
// The PlayerOptionsModel defines which models will 
// appear on the player model menu. It doesn't define
// which models are valid. Just which choices will appear.
//
// Look at player_manager to see how to define which models
// are valid.
//

list.Set( "PlayerOptionsModel", "kleiner", 		"models/player/Kleiner.mdl" )
list.Set( "PlayerOptionsModel", "mossman", 		"models/player/mossman.mdl" )
list.Set( "PlayerOptionsModel", "alyx", 		"models/player/alyx.mdl" )
list.Set( "PlayerOptionsModel", "barney", 		"models/player/barney.mdl" )
list.Set( "PlayerOptionsModel", "breen", 		"models/player/breen.mdl" )
list.Set( "PlayerOptionsModel", "odessa", 		"models/player/odessa.mdl" )
list.Set( "PlayerOptionsModel", "zombie", 		"models/player/classic.mdl" )
list.Set( "PlayerOptionsModel", "charple", 		"models/player/charple01.mdl" )
list.Set( "PlayerOptionsModel", "combine", 		"models/player/combine_soldier.mdl" )
list.Set( "PlayerOptionsModel", "prison", 		"models/player/combine_soldier_prisonguard.mdl" )
list.Set( "PlayerOptionsModel", "super", 		"models/player/combine_super_soldier.mdl" )
list.Set( "PlayerOptionsModel", "police", 		"models/player/police.mdl" )
list.Set( "PlayerOptionsModel", "gman", 		"models/player/gman_high.mdl" )
list.Set( "PlayerOptionsModel", "stripped", 	"models/player/soldier_stripped.mdl" )
list.Set( "PlayerOptionsModel", "fzombie", 		"models/player/Zombiefast.mdl" )

list.Set( "PlayerOptionsModel",  "female1",		"models/player/Group01/female_01.mdl" )
list.Set( "PlayerOptionsModel",  "female2",		"models/player/Group01/female_02.mdl" )
list.Set( "PlayerOptionsModel",  "female3",		"models/player/Group01/female_03.mdl" )
list.Set( "PlayerOptionsModel",  "female4",		"models/player/Group01/female_04.mdl" )
list.Set( "PlayerOptionsModel",  "female5",		"models/player/Group01/female_06.mdl" )
list.Set( "PlayerOptionsModel", "female6",		"models/player/Group01/female_07.mdl" )
list.Set( "PlayerOptionsModel", "female7",		"models/player/Group03/female_01.mdl" )
list.Set( "PlayerOptionsModel", "female8",		"models/player/Group03/female_02.mdl" )
list.Set( "PlayerOptionsModel", "female9",		"models/player/Group03/female_03.mdl" )
list.Set( "PlayerOptionsModel", "female10",		"models/player/Group03/female_04.mdl" )
list.Set( "PlayerOptionsModel", "female11",		"models/player/Group03/female_06.mdl" )
list.Set( "PlayerOptionsModel", "female12",		"models/player/Group03/female_07.mdl" )

list.Set( "PlayerOptionsModel", "male1",		"models/player/Group01/male_01.mdl" )
list.Set( "PlayerOptionsModel", "male2",		"models/player/Group01/male_02.mdl" )
list.Set( "PlayerOptionsModel", "male3",		"models/player/Group01/male_03.mdl" )
list.Set( "PlayerOptionsModel", "male4",		"models/player/Group01/male_04.mdl" )
list.Set( "PlayerOptionsModel", "male5",		"models/player/Group01/male_05.mdl" )
list.Set( "PlayerOptionsModel", "male6",		"models/player/Group01/male_06.mdl" )
list.Set( "PlayerOptionsModel", "male7",		"models/player/Group01/male_07.mdl" )
list.Set( "PlayerOptionsModel",  "male8",		"models/player/Group01/male_08.mdl" )
list.Set( "PlayerOptionsModel",  "male9",		"models/player/Group01/male_09.mdl" )

list.Set( "PlayerOptionsModel", "male10",		"models/player/Group03/male_01.mdl" )
list.Set( "PlayerOptionsModel", "male11",		"models/player/Group03/male_02.mdl" )
list.Set( "PlayerOptionsModel", "male12",		"models/player/Group03/male_03.mdl" )
list.Set( "PlayerOptionsModel", "male13",		"models/player/Group03/male_04.mdl" )
list.Set( "PlayerOptionsModel", "male14",		"models/player/Group03/male_05.mdl" )
list.Set( "PlayerOptionsModel", "male15",		"models/player/Group03/male_06.mdl" )
list.Set( "PlayerOptionsModel", "male16",		"models/player/Group03/male_07.mdl" )
list.Set( "PlayerOptionsModel", "male17",		"models/player/Group03/male_08.mdl" )
list.Set( "PlayerOptionsModel", "male18",		"models/player/Group03/male_09.mdl" )

// Todo: If owns ep1 or 2
list.Set( "PlayerOptionsModel", "zombine", 		"models/player/zombie_soldier.mdl" )

// Todo: If owns ep2 (Fix eyes first)
//list.Set( "PlayerOptionsModel", "magnusson", 		"models/player/magnusson.mdl" )

//
//
//
local function PlayerModel( CPanel )

	local PanelSelect = CPanel:PanelSelect()
	PanelSelect:SetAutoSize( true )
	
	for name, model in pairs( list.Get( "PlayerOptionsModel" ) ) do
	
		local icon = vgui.Create( "SpawnIcon" )
		icon:SetModel( model )
		icon:SetSize( 64, 64 )
		icon:SetTooltip( name )
		
		PanelSelect:AddPanel( icon, { cl_playermodel = name } )
	
	end

	// Work it out so we have 2 per row
	//local NumRows = Format( "%i", (table.Count(ModelList)+1) / 2 )
	
	//local params = { Options = {}, ConVar = "cl_playermodel", Label = "#PlayerModel", Height = "100", Width = "100", Rows = NumRows }
	
	//for k, v in pairs( ModelList ) do
	//	params.Options[ k ] = { Material = v, Value = k, cl_playermodel = k }
	//end
	
	//CPanel:AddControl( "MaterialGallery", params )

end


local function PlayerSettings( CPanel )

	CPanel:AddControl( "Header", { Text = "#Player Settings" }  )

	// Name is now set via Steam Community
	//CPanel:AddControl( "TextBox", { Label = "#Name", 			Command = "name", 			WaitForEnter = "1" }  )
	
	CPanel:AddControl( "TextBox", { Label = "#Location", 		Command = "cl_location", 	WaitForEnter = "1" }  )
	CPanel:AddControl( "TextBox", { Label = "#Website", 		Command = "cl_website",		WaitForEnter = "1" }  )
	CPanel:AddControl( "TextBox", { Label = "#EmailAddress", 	Command = "cl_email", 		WaitForEnter = "1" }  )
	CPanel:AddControl( "TextBox", { Label = "#AIMName", 		Command = "cl_aim", 		WaitForEnter = "1" }  )
	CPanel:AddControl( "TextBox", { Label = "#MSNName", 		Command = "cl_msn", 		WaitForEnter = "1" }  )
	CPanel:AddControl( "TextBox", { Label = "#GTalkName", 		Command = "cl_gtalk", 		WaitForEnter = "1" }  )
	CPanel:AddControl( "TextBox", { Label = "#XFireName", 		Command = "cl_xfire", 		WaitForEnter = "1" }  )
	
	CPanel:AddControl( "Slider", { Label = "#Screenshot Quality",	Type = "Integer", 	Command = "jpeg_quality", 	Min = "0", 		Max = "100" }  )
	
	CPanel:AddControl( "CheckBox", { Label = "#ShowHints", 		Command = "cl_showhints" }  )
	
end


local function PerformanceOptions( CPanel )

	CPanel:AddControl( "Header", { Text = "#Performance Tweaks" }  )
	
	CPanel:AddControl( "Slider", 	{ Label = "#Max Decals",	Type = "Integer", 	Command = "r_decals", 	Min = "0", 		Max = "4096" }  )
	CPanel:AddControl( "Slider", 	{ Label = "#Model LOD",	Type = "Integer", 	Command = "r_lod", 	Min = "-1", 	Max = "5" }  )
	
	CPanel:AddControl( "CheckBox", 	{ Label = "#Shadows",	Command = "r_shadows" }  )	
	
	CPanel:AddControl( "CheckBox", 	{ Label = "#DrawDetailProps", 	Command = "r_drawdetailprops" }  )	
	CPanel:AddControl( "Slider", 	{ Label = "#DetailDistance",	Type = "Integer", 	Command = "cl_detaildist", 	Min = "64", 	Max = "4096" }  )	

end

local function HideOptions( CPanel )

	CPanel:AddControl( "Header", { Text = "#Hide Options" }  )

	CPanel:AddControl( "CheckBox", { Label = "#DrawThrusterEffects", 	Command = "cl_drawthrusterseffects" }  )
	CPanel:AddControl( "CheckBox", { Label = "#DrawHoverBalls", 		Command = "cl_drawhoverballs" }  )
	CPanel:AddControl( "CheckBox", { Label = "#DrawCameras", 			Command = "cl_drawcameras" }  )
	CPanel:AddControl( "CheckBox", { Label = "#DrawPhysgunBeams", 		Command = "physgun_drawbeams" }  )

end

local function VisualOptions( CPanel )

	CPanel:AddControl( "Header", { Text = "#Visual Tweaks" }  )

	CPanel:AddControl( "Slider", { Label = "#Net Graph",	Type = "Integer", 	Command = "net_graph", 		Min = "0", 		Max = "3" }  )
	CPanel:AddControl( "Slider", { Label = "#Show FPS",		Type = "Integer", 	Command = "cl_showfps", 	Min = "0", 		Max = "2" }  )

	CPanel:AddControl( "CheckBox", { Label = "#Show_Low_Res_Textures",	Command = "mat_showlowresimage" }  )	
	CPanel:AddControl( "CheckBox", { Label = "#Wireframe",				Command = "mat_wireframe" }  )	

end
	
local function FogOptions( CPanel )

	CPanel:AddControl( "Header", { Text = "#Fog Options" }  )
	
	local params = { Label = "#Fog_Presets", MenuButton = "1", Folder = "fog", Options = {}, CVars = {} }
	
	params.Options[ "#Default" ] = {	fog_start =				"-1",
								fog_startskybox =		"-1",
								fog_end =				"-1",
								fog_endskybox =			"-1",
								fog_color_r =			"255",
								fog_color_g =			"255",
								fog_color_b =			"255" }
								
	params.CVars = { "fog_start",
						"fog_startskybox",
						"fog_end",
						"fog_endskybox",
						"fog_color_r",
						"fog_color_g",
						"fog_color_b" }
	
	CPanel:AddControl( "ComboBox", params )
	
	CPanel:AddControl( "CheckBox", { Label = "#Fog_Override",	Command = "fog_override" }  )	
	local Slider = CPanel:AddControl( "Slider", { Label = "#Fog_Start", Type = "Float", Command = "fog_start", Min = "0", Max = "10000" }  )
	
	// Update the skybox convar too
	function Slider:OnValueChanged( newval )
		RunConsoleCommand( "fog_startskybox", newval )
	end
	
	local Slider = CPanel:AddControl( "Slider", { Label = "#Fog_End", Type = "Float", Command = "fog_end", Min = "0", Max = "10000" }  )
	
	// Update the skybox convar too
	function Slider:OnValueChanged( newval )
		RunConsoleCommand( "fog_endskybox", newval )
	end
	
	CPanel:AddControl( "Color", { Label = "#Fog_Color", Red = "fog_color_r", Green = "fog_color_g", Blue = "fog_color_b", ShowAlpha = "0", ShowHSV = "1", ShowRGB = "1", Multiplier = "255" }  )

end
	
/*
// Tool Menu
*/
local function PopulateOptionMenus()

	spawnmenu.AddToolMenuOption( "Options", "Player", "Settings", "#Settings", "", "", PlayerSettings )
	spawnmenu.AddToolMenuOption( "Options", "Player", "Model", "#Model", "", "", PlayerModel )
	
	spawnmenu.AddToolMenuOption( "Options", "Performance", "Tweaks", "#Tweaks", "", "", PerformanceOptions )
	
	spawnmenu.AddToolMenuOption( "Options", "Visuals", 	"Hiding",	"#Hiding", 	"", "", HideOptions )
	spawnmenu.AddToolMenuOption( "Options", "Visuals", 	"Fog", 		"#Fog", 	"", "", FogOptions )

end

hook.Add( "PopulateToolMenu", "PopulateOptionMenus", PopulateOptionMenus )

/* 
// Categories
*/
local function CreateOptionsCategories()

	spawnmenu.AddToolCategory( "Options", 	"Player", 		"#Player" )
	spawnmenu.AddToolCategory( "Options", 	"Performance", 	"#Performance" )
	spawnmenu.AddToolCategory( "Options", 	"Visuals", 		"#Visuals" )

end	

hook.Add( "AddToolMenuCategories", "CreateOptionsCategories", CreateOptionsCategories )

