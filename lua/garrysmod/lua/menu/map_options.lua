//=============================================================================//
//  ___  ___   _   _   _    __   _   ___ ___ __ __
// |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
//  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
//  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2007
//										 
//=============================================================================//

language.Add( "Server_Settings", "Server Settings" )
language.Add( "Server_Name:", "Server Name:" )

language.Add( "GameModeChoice", "Gamemode Choice" )
language.Add( "Override:", "Override:" )
language.Add( "Default:", "Default:" )
language.Add( "defaultgamemodehelp", "If a map doesn't have a gamemode set, we will use this gamemode. This should be 'sandbox' unless you have a good reason for changing it." )
language.Add( "overridegamemodehelp", "If this isn't blank we will always use this gamemode, no matter what. This should be blank unless you have a good reason for changing it." )

language.Add( "Max_Players:", "Max Players:" )
language.Add( "Lan_Game", "Local Network Game" )


local PANEL = {}

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Init()

	self:EnableVerticalScrollbar( true )
	
	self:SetSpacing( 10 )
	self:SetPadding( 10 )

end

function PANEL:SetupSinglePlayer()

	local GameModes = GetGamemodes()

	local GameModeSettings = vgui.Create( "DForm", self )
		GameModeSettings:SetName( "#GameModeChoice" )
	
		// Default Gamemode
		local mc = GameModeSettings:MultiChoice( "#Default:", "sv_defaultgamemode" )
		for k, v in ipairs( GameModes ) do
			mc:AddChoice( v.Name )
		end
		
		GameModeSettings:Help( "#defaultgamemodehelp" )
			
		// Gamemode Override
		local mc = GameModeSettings:MultiChoice( "#Override:", "sv_gamemodeoverride" )
		mc:AddChoice( "" )
		for k, v in ipairs( GameModes ) do
			mc:AddChoice( v.Name )
		end
		
		GameModeSettings:Help( "#overridegamemodehelp" )
		
	self:AddItem( GameModeSettings )
	
	self:AddGamemodeSettings()
	
end


function PANEL:SetupMultiPlayer()

	local ServerSettings = vgui.Create( "DForm", self )
		ServerSettings:SetName( "#Server_Settings" )
	
		ServerSettings:TextEntry( "#Server_Name:", "hostname" )
		ServerSettings:NumberWang( "#Max_Players:", "sv_maxplayers", 2, 64, 0 )
		ServerSettings:CheckBox( "#Lan_Game", "sv_lan" )
		
	self:AddItem( ServerSettings )
		
	// Add the gamemode options
	self:SetupSinglePlayer()
		
end

function PANEL:AddGamemodeSettings()

	local files = file.Find( "../settings/server_settings/*.txt" )
	for k, filename in pairs( files ) do
	
		local settings_file = file.Read( "../settings/server_settings/"..filename )
		
		if ( settings_file ) then
			local Settings = KeyValuesToTable( settings_file )
			self:AddSettings( Settings )
		end
	
	end

end

function PANEL:AddSettings( tab )

	if ( !tab ) then return end
	if ( !tab.title ) then return end
	
	local Form = vgui.Create( "DForm", self )
		self:AddItem( Form )
		Form:SetName( tab.title )
	
	// This multiple looping stuff kinda sucks
	// But I want to group the different controls
	// without breaking backwards compatibility
	
	// Checkbox
	for k, v in pairs( tab.settings ) do
	
		if ( v.type == "CheckBox" ) then
			Form:CheckBox( v.text, k )
			tab.settings[ k ] = nil
		end 
	
	end
	
	// Numeric
	for k, v in pairs( tab.settings ) do
	
		if ( v.type == "Numeric" ) then
			Form:NumberWang( v.text, k, v.low or 0, v.high or 200, v.decimals or 0 )
			tab.settings[ k ] = nil
		end
	
	end
	
	// Text	
	for k, v in pairs( tab.settings ) do
	
		Form:TextEntry( v.text, k )
	
	end

end

vgui.Register( "MapListOptions", PANEL, "DPanelList" )
