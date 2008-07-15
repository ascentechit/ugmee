//=============================================================================//
//  ___  ___   _   _   _    __   _   ___ ___ __ __
// |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
//  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
//  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2007
//										 
//=============================================================================//

language.Add( "GMod_Settings", "GMod Settings" )

local pnlDerma 		= vgui.RegisterFile( "derma.lua" )
local pnlContent 	= vgui.RegisterFile( "content.lua" )

local PANEL = {}

/*---------------------------------------------------------
	Init
---------------------------------------------------------*/
function PANEL:Init()

	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )
	
	self:SetDeleteOnClose( false )
	self:SetTitle( Localize( "GMod_Settings", "Garry's Mod Settings" ) )
	
	self.PropertySheet = vgui.Create( "DPropertySheet", self )
	
	self.PropertySheet:AddSheet( Localize( "Content" ), vgui.CreateFromTable( pnlContent ) )
	self.PropertySheet:AddSheet( Localize( "Derma Skin" ), vgui.CreateFromTable( pnlDerma ) )
	
end

/*---------------------------------------------------------
	Init
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self:SetSize( 500, 400 )
	DFrame.PerformLayout( self )
	
	self.PropertySheet:StretchToParent( 4, 25, 4, 4 )
	
end

local tSettingsPanel = vgui.RegisterTable( PANEL, "DFrame" )
local OptionsFrame = nil

local function command_function()

	if ( !OptionsFrame ) then
		OptionsFrame = vgui.CreateFromTable( tSettingsPanel )
	end

	OptionsFrame:SetVisible( true )
	OptionsFrame:Center()
	OptionsFrame:MakePopup()

end

concommand.Add( "menu_options", command_function )

// development
//RunConsoleCommand( "menu_options" )