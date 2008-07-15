//=============================================================================//
//  ___  ___   _   _   _    __   _   ___ ___ __ __
// |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
//  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
//  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2007
//										 
//=============================================================================//


include( "map_icon.lua" )

local PANEL = {}

AccessorFunc( PANEL, "m_pController", 			"Controller" )

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Init()

	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( false )
	
	self.PanelList = vgui.Create( "DPanelList", self )
	self.PanelList:EnableVerticalScrollbar( true )
	self.PanelList:SetSpacing( 2 )
	self.PanelList:SetPadding( 2 )
	
end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:BuildMaps()

	self:AddCategory( "Garry's Mod", true )

	for k, v in SortedPairs( g_MapListCategorised ) do
	
		if ( k != "Garry's Mod" && k != "Other" ) then
			self:AddCategory( k, false )
		end

	end
	
	self:AddCategory( "Other", false )
	
	self:PerformLayout()
	
end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:AddCategory( strCategoryName, bExpanded )

	if (!g_MapListCategorised[ strCategoryName ]) then return end
	
	local count = table.Count( g_MapListCategorised[ strCategoryName ] )
	if ( count == 0 ) then return end
	
	local Category = vgui.Create( "DCollapsibleCategory" )
	Category:SetLabel( strCategoryName .. " (" .. count .. " maps) "  )
	self.PanelList:AddItem( Category )
	
	local Contents = vgui.Create( "DPanelList" );
	Contents:EnableHorizontal( true )
	Contents:SetAutoSize( true )
	Contents:SetSpacing( 2 )
	Contents:SetPadding( 4 )
	Contents:SetDrawBackground( false )
	
	Category:SetContents( Contents )
	
	for k, v in SortedPairs( g_MapListCategorised[ strCategoryName ] ) do
	
		self:AddMap( v, Contents )
	
	end
	
	Category:SetExpanded( bExpanded )
	Category:PerformLayout()
	
end


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:AddMap( MapTable, Contents )

	local icon = vgui.Create( "MapIcon", Contents )
	icon:SetMap( MapTable )
	icon:SetController( self:GetController() )
	
	Contents:AddItem( icon )
	
end


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:PerformLayout()

	self.PanelList:SetPos( 0, 0 )
	self.PanelList:SetSize( self:GetWide(), self:GetTall() )
	self.PanelList:InvalidateLayout()
	
end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Setup()

	self:BuildMaps()
	
end

vgui.Register( "MapListIcons", PANEL )