
local PANEL = {}

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self:SetTitle( "#Button Settings" )
	self:SetKeyboardInputEnabled( true )
	
	self.lblCommand = vgui.Create( "DLabel", self )
		self.lblCommand:SetText( "#Console Command:" )
	
	self.txtCommand = vgui.Create( "DTextEntry", self )
	self.txtCommand:SetKeyboardInputEnabled( true )
	self.txtCommand:SetTabPosition( 2 )
	
	self.btnOK = vgui.Create( "DButton", self )
	self.btnOK:SetText( "#OK" )
	self.btnOK:SetTabPosition( 3 )
	self.btnOK.DoClick = function() self:OK() end
	
	self.btnCancel = vgui.Create( "DButton", self )
	self.btnCancel:SetText( "#Cancel" )
	self.btnCancel:SetTabPosition( 4 )
	self.btnCancel.DoClick = function() self:Remove() end
	
	
	self.iconFrame = vgui.Create( "DPanelList", self )
	self.iconFrame:EnableHorizontal( true )
	self.iconFrame:SetSpacing( 2 )
	
	local list = list.Get( "16x16Icons" )
	
	for name, img in pairs( list ) do
	
		local btn = vgui.Create( "DImageButton", self )
			btn:SetImage( img )
			btn:SetSize( 16, 16 )
			btn.DoClick = function() self:UpdateImage( btn ) end
				
		self.iconFrame:AddItem( btn )
	
	end
	
	
	self:Center()
	self:MakePopup()

end

/*---------------------------------------------------------
   Name: Setup
---------------------------------------------------------*/
function PANEL:Setup( button, QuickTool )

	self.QuickTool 	= QuickTool
	self.Button 	= button
	
	self.txtCommand:SetText( tostring( self.Button.strCommand ) )

end
	
/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:UpdateImage( btn )

	self.Button:SetImage( btn:GetImage() )

end
	
/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()
	
	self.BaseClass.PerformLayout( self )
	
	self:SetSize( 200, 300 )
	
	local y = 30
	
	self.lblCommand:SetPos( 10, y )
		self.lblCommand:SetWide( self:GetWide() )
	y = y + 21
	self.txtCommand:SetPos( 10, y )
	self.txtCommand:SetWide( self:GetWide() - 20 )
	y = y + 30
	
	self.iconFrame:SetPos( 10, y )
	self.iconFrame:SetWide( self:GetWide() - 20 )
	self.iconFrame:SetTall( 100 )	
	
	y = y + self.iconFrame:GetTall()
	y = y + 20
	
	self.btnOK:SetPos( self:GetWide() - 115, y )
	self.btnOK:SetWide( 40 )
	
	self.btnCancel:SetPos( self:GetWide() - 70, y )
	self.btnCancel:SetWide( 60 )
	
	y = y + 30
	self:SetTall( y )
	
end

/*---------------------------------------------------------
   Name: OK
---------------------------------------------------------*/
function PANEL:OK()

	self.Button.strCommand = self.txtCommand:GetValue()
	
	self.QuickTool:SaveSettings()
	
	self:Remove()

end
	

vgui.Register( "ToolQuickSelectProperties", PANEL, "DFrame" )