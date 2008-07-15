//=============================================================================//
//  ___  ___   _   _   _    __   _   ___ ___ __ __
// |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
//  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
//  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2007
//										 
//=============================================================================//

PANEL.Base = "DPanelList"

/*---------------------------------------------------------
	Init
---------------------------------------------------------*/
function PANEL:Init()

	self:EnableVerticalScrollbar()
	self:SetPadding( 8 )
	self:SetSpacing( 8 )

	local Form = vgui.Create( "DForm", self )
		self:AddItem( Form )
		Form:SetName(  Localize( "Skin" ) )
		
		local List = vgui.Create( "DListView", self )
			List:SetMultiSelect( false )
			List:AddColumn( Localize( "Skin Name" ) )
			local AuthorCol = List:AddColumn( Localize( "Author" ) )
			AuthorCol:SetFixedWidth( 100 )
			
			local CurrentSkin = GetConVarString( "derma_skin" )
			local SkinList = derma.GetSkinTable()
			for k, v in pairs( SkinList ) do
				
				local name = v.PrintName or k
				local author = v.Author or "Unknown"
				
				local line = List:AddLine( name, author )
				line.OnSelect = function() RunConsoleCommand( "derma_skin", k ) end
				
				if ( CurrentSkin == k ) then List:SelectItem( line ) end
				
			end
			
			List:SetTall( 250 )
			
		Form:AddItem( List, nil )

end