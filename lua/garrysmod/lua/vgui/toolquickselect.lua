
local PANEL = {}

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self.TargetOffset = 0
	self.Offset = 0
	self.Stick = false
	self.Buttons = {}
	self.In = false
	
	self.btnAdd = vgui.Create( "DImageButton", self )
	self.btnAdd:SetImage( "gui/silkicons/add" )
	self.btnAdd.DoClick = function () self:AddButton() end
	self.btnAdd:SetToolTip( "Add Button" )
	
	self.btnStick = vgui.Create( "DImageButton", self )
	self.btnStick:SetImage( "gui/silkicons/application_put" )
	self.btnStick.DoClick = function () self:StickToggle() end
	self.btnStick:SetToolTip( "Anchor" )
	
	self:LoadSettings()
	
	self:SetIn( false )

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:AddButton()

	local btn = vgui.Create( "DImageButton", self )
	btn:SetImage( "gui/silkicons/wrench" )
	
	btn.DoClick = 		function ( btn ) 
	
							LocalPlayer():ConCommand( tostring( btn.strCommand ) .. "\n" ) 
							
						end
						
	btn.DoRightClick = 	function ( btn ) 
							
							local menu = DermaMenu()
								menu:AddOption( "Properties..", function() self:ButtonProperties( btn ) end )
								menu:AddOption( "Remove", function() self:RemoveButton( btn ) end )
								menu:Open()				
							
						end
						
	btn.strCommand = ""

	table.insert( self.Buttons, btn )
	
	self:InvalidateLayout( true )
	
	self:SaveSettings()

	return btn
	
end


/*---------------------------------------------------------
   Name: RemoveButton
---------------------------------------------------------*/
function PANEL:RemoveButton( btnToRemove )

	for k, btn in pairs( self.Buttons ) do
	
		if ( btnToRemove == btn ) then
			table.remove( self.Buttons, k )
		end

	end
	
	btnToRemove:Remove()
	self:PerformLayout()
	self:SaveSettings()

end

/*---------------------------------------------------------
   Name: ButtonProperties
---------------------------------------------------------*/
function PANEL:ButtonProperties( btn )

	local window = vgui.Create( "ToolQuickSelectProperties" )
		window:Setup( btn, self )

end

/*---------------------------------------------------------
   Name: StickToggle
---------------------------------------------------------*/
function PANEL:StickToggle()

	self.Stick = !self.Stick
	
	if ( self.Stick ) then
		self.btnStick:SetImage( "gui/silkicons/anchor" )
	else
		self.btnStick:SetImage( "gui/silkicons/application_put" )
	end
	
	self:SaveSettings()

end

/*---------------------------------------------------------
   Name: SetIn
---------------------------------------------------------*/
function PANEL:SetIn( _in )

	if ( self.Stick ) then _in = true end

	self.In = _in
	
	if ( self.In ) then
	
		self.TargetOffset = 24
	
	else
	
		self.TargetOffset = 0
	
	end

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint()

	draw.RoundedBox( 8, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 150 ) )

end


/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Think()

	if ( self.Offset != self.TargetOffset ) then
	
		self.Offset = math.Approach( self.Offset, self.TargetOffset, 500 * FrameTime() )
		self.y = ScrH() - self.Offset
	
	end

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()
	
	local t = 24
	local x = 8
	local y = 4
	local space = 8
	local ypos = t
	
	for k, btn in pairs( self.Buttons ) do
	
		btn:SetSize( 16, 16 )
		btn:SetPos( x, y )
		btn:SetToolTip( btn.strCommand )
		
		x = x + 16 + space
	
	end

	// Extra space to seperate it from the others..
	x = x + space

	// Add new button
	self.btnAdd:SetSize( 16, 16 )
	self.btnAdd:SetPos( x, y )
	x = x + 16 + space
	
	// Stick
	self.btnStick:SetSize( 16, 16 )
	self.btnStick:SetPos( x, y )
	x = x + 16 + space
	
	
	self:SetSize( x, t * 2 )	
	self:SetPos( ScrW() / 2 - x / 2, ScrH() - self.Offset )

end


/*---------------------------------------------------------
   Name: SaveSettings
---------------------------------------------------------*/
function PANEL:SaveSettings()

	local tab = {}
	
	if ( self.Stick ) then tab.anchor = '1' else tab.anchor = '0' end
	
	for k, btn in pairs( self.Buttons ) do
	
		local btntab = {}
		btntab.command = btn.strCommand or ""
		btntab.icon = btn:GetImage()
		
		table.insert( tab, btntab )
	
	end
	
	
	local data = util.TableToKeyValues( tab )
	file.Write( "tool_quick_select.txt", data )
	
end

/*---------------------------------------------------------
   Name: LoadSettings
---------------------------------------------------------*/
function PANEL:LoadSettings()

	local data = file.Read( "tool_quick_select.txt" )
	if (!data) then return end
	
	local tab = util.KeyValuesToTable( data )
	
	if ( tab.anchor == 1 ) then self:StickToggle() end
	
	for i=1, 100 do
	
		local btntab = tab[ tostring(i) ]
		if ( !btntab ) then break end
				
		local btn = self:AddButton()
		btn:SetImage( btntab.icon )
		btn.strCommand = btntab.command
	
	end

end

vgui.Register( "ToolQuickSelect", PANEL, "Panel" )