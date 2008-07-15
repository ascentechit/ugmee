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
		Form:SetName( Localize( "Depots To Mount" ) )
		
	for k, v in SortedPairs( GetMountableContent() ) do
	
		local checkbox, label = Form:CheckBox( v.title )
		
		if ( v.mounted ) then
			checkbox:SetValue( 1 )
		end
		
		if ( v.depotid == 220 ) then
			checkbox:SetTooltip( Localize( "Content_NeedInstall", "This needs to be installed" ) )
			checkbox:SetDisabled( true )
		end
		
		if ( !v.mountable  ) then
			checkbox:SetDisabled( true )
			checkbox:SetTooltip( Localize( "Content_NoPermission", "You don't own this content" ) )
		end
		
		function checkbox:OnChange( val )
			SetMountContent( tostring(v.depotid), val );
		end
	
	end	
	
	Form:Help( Localize( "Content_HelpReboot", "* You need to restart Garry's Mod for these changes to come into effect." ) )
	
	

end
