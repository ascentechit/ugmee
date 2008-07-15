//=============================================================================//
//  ___  ___   _   _   _    __   _   ___ ___ __ __
// |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
//  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
//  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2007
//										 
//=============================================================================//

language.Add( "MultiplayerGame", "Multiplayer Game" )

local PANEL = {}

/*---------------------------------------------------------
	Init
---------------------------------------------------------*/
function PANEL:Init()

	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )
	
	self:SetDeleteOnClose( false )
	
	self:SetTitle( "#MultiplayerGame" )
	
	self:CreateControls()
	
end


/*---------------------------------------------------------
	CreateControls
---------------------------------------------------------*/
function PANEL:CreateControls()

	self.StartGame = vgui.Create( "StartGame", self )
	self.StartGame:SetMultiplayer()
	
	self.MapSheet = vgui.Create( "DPropertySheet", self )
	
	local MapIcons = vgui.Create( "MapListIcons" )
	MapIcons:SetController( self.StartGame )
	MapIcons:Setup()
	
	local MapList = vgui.Create( "MapListList" )
	MapList:SetController( self.StartGame )
	
	local Options = vgui.Create( "MapListOptions", self )
	Options:SetupMultiPlayer()
		
	self.MapSheet:AddSheet( "Icons", MapIcons, "gui/silkicons/application_view_tile" )
	self.MapSheet:AddSheet( "List", MapList, "gui/silkicons/application_view_detail" )
	self.MapSheet:AddSheet( "Options", Options, "gui/silkicons/application_view_detail" )

end

/*---------------------------------------------------------
	PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self:SetSize( 450, ScrH() * 0.8 )
	
	self.MapSheet:SetPos( 8, 25 )
	self.MapSheet:SetSize( self:GetWide() - 16, self:GetTall() - 25 - 8 - 60 - 8 )
	self.MapSheet:InvalidateLayout()
	
	self.StartGame:SetPos( 8, self:GetTall() - 60 - 8 )
	self.StartGame:SetSize( self:GetWide() - 16, 60 )
	
	self.BaseClass.PerformLayout( self )
	
end


vgui.Register( "StartMultiPlayerGame", PANEL, "DFrame" )

local MenuFrame = vgui.Create( "StartMultiPlayerGame" )
MenuFrame:SetVisible( false )

local function menu_multiplayer()

	if ( MenuFrame ) then
	
		MenuFrame:SetVisible( true )
		MenuFrame:Center()
		MenuFrame:MakePopup()
	
	end

end

concommand.Add( "menu_multiplayer", menu_multiplayer )

local function CloseMultiPlayerMenu()

	if ( MenuFrame ) then
		MenuFrame:Close()
	end

end

hook.Add( "StartGame", "CloseMultiPlayerMenu", CloseMultiPlayerMenu )