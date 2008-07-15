//=============================================================================//
//  ___  ___   _   _   _    __   _   ___ ___ __ __
// |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
//  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
//  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2007
//										 
//=============================================================================//


local PANEL = {}

AccessorFunc( PANEL, "m_strText", 				"Text" )

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Init()

	self:SetMouseInputEnabled( false )
	self:SetKeyboardInputEnabled( false )
	
	self.Label = vgui.Create( "DLabel", self )
	self.Label:SetText( "" )
	
	self.StartTime = SysTime()
	
end


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:SetText( text )

	text = string.gsub( text, "\n", " " )
	text = string.gsub( text, "\t", " " )
	text = string.gsub( text, "\r", "" )
	
	self.m_strText = text
	self.Label:SetText( text )	
	self.Label:SetFont( "TabLarge" )
	self.Label:SetTextColor( color_white )
	
end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Think()

	self:InvalidateLayout()

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:PerformLayout()

	local w = ScrW() * 0.8

	self.Label:SizeToContents()
	
	local xOff = w + (self.StartTime - SysTime()) * 70
	
	if ( xOff < self.Label:GetWide() * -1 ) then
	
		self.StartTime = SysTime()
		
	end
	
	self.Label:SetPos( xOff, 2 )
	
	self:SetSize( w, 20 )
	self:SetPos( ScrW() * 0.1, ScrH() - 20 )

end

local pnlScrollBar = vgui.RegisterTable( PANEL, "Panel" )


local NewsBar = nil

local function fnCallback( contents, size )

	if ( contents == nil || contents == "" ) then return end
	
	NewsBar = vgui.CreateFromTable( pnlScrollBar )
	NewsBar:SetText( contents )

end

http.Get( "http://www.garrysmod.com/newsbar/", "", fnCallback )