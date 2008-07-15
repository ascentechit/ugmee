//
//  ___  ___   _   _   _    __   _   ___ ___ __ __
// |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
//  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
//  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2007
//										 
//

include( "panel_animation.lua" )

local meta = FindMetaTable( "Panel" )
if (!meta) then return end

AccessorFunc( meta, "m_strCookieName",  "CookieName" )

meta.SetFGColorEx = meta.SetFGColor
meta.SetBGColorEx = meta.SetBGColor


/*---------------------------------------------------------
   Name:	SetFGColor
   Desc:	Override to make it possible to pass Color's
---------------------------------------------------------*/  
function meta:SetFGColor( r, g, b, a )

	if ( type( r ) == "table" ) then
		return self:SetFGColorEx( r.r, r.g, r.b, r.a )
	end

	return self:SetFGColorEx( r, g, b, a )

end


/*---------------------------------------------------------
   Name:	SetBGColor
   Desc:	Override to make it possible to pass Color's
---------------------------------------------------------*/  
function meta:SetBGColor( r, g, b, a )

	if ( type( r ) == "table" ) then
		return self:SetBGColorEx( r.r, r.g, r.b, r.a )
	end

	return self:SetBGColorEx( r, g, b, a )

end


/*---------------------------------------------------------
	Name: SetHeight
---------------------------------------------------------*/  
function meta:SetHeight( h )

	self:SetSize( self:GetWide(), h )

end

meta.SetTall = meta.SetHeight


/*---------------------------------------------------------
	Name: SetHeight
---------------------------------------------------------*/  
function meta:SetWidth( w )

	self:SetSize( w, self:GetTall() )

end

meta.SetWide = meta.SetWidth


/*---------------------------------------------------------
	Name: StretchToParent (borders)
---------------------------------------------------------*/  
function meta:StretchToParent( l, u, r, d )

	local w, h = self:GetParent():GetSize()

	if ( l != nil ) then
		self.x = l
	end
	
	if ( u != nil ) then
		self.y = u
	end
	
	if ( r != nil ) then
		self:SetWide( w - self.x - r )
	end
	
	if ( d != nil ) then
		self:SetTall( h - self.y - d )
	end
	
	//self:SetPos( l, u )
	//self:SetSize( w - (r + l), h - (d + u) )

end

/*---------------------------------------------------------
	Name: CopyHeight
---------------------------------------------------------*/  
function meta:CopyHeight( pnl )

	self:SetTall( pnl:GetTall() )

end

/*---------------------------------------------------------
	Name: CopyWidth
---------------------------------------------------------*/  
function meta:CopyWidth( pnl )

	self:SetWide( pnl:GetWide() )

end

/*---------------------------------------------------------
	Name: CopyPos
---------------------------------------------------------*/  
function meta:CopyPos( pnl )

	self:SetPos( pnl:GetPos() )

end

/*---------------------------------------------------------
	Name: Align with the edge of the parent
---------------------------------------------------------*/  
function meta:AlignBottom( m ) m = m or 0; self:SetPos( self.x, self:GetParent():GetTall() - self:GetTall() - m ) end 
function meta:AlignRight( m ) m = m or 0; self:SetPos( self:GetParent():GetWide() - self:GetWide() - m, self.y ) end
function meta:AlignTop( m ) m = m or 0; self:SetPos( self.x, m ) end
function meta:AlignLeft( m ) m = m or 0; self:SetPos( m, self.y ) end

/*---------------------------------------------------------
	Name: Move relative to another panel
---------------------------------------------------------*/  
function meta:MoveAbove( pnl, m ) m = m or 0; self:SetPos( self.x, pnl.y - self:GetTall() - m ) end
function meta:MoveBelow( pnl, m ) m = m or 0; self:SetPos( self.x, pnl.y + pnl:GetTall() + m ) end
function meta:MoveRightOf( pnl, m ) m = m or 0; self:SetPos( pnl.x + pnl:GetWide() + m, self.y ) end
function meta:MoveLeftOf( pnl,  m ) m = m or 0; self:SetPos( pnl.x - self:GetWide() - m, self.y ) end


/*---------------------------------------------------------
	Name: StretchRightTo
---------------------------------------------------------*/  
function meta:StretchRightTo( pnl, m ) m = m or 0; self:SetWide( pnl.x - self.x -  m ) end
function meta:StretchBottomTo( pnl, m ) m = m or 0; self:SetTall( pnl.y - self.y - m ) end

/*---------------------------------------------------------
	Name: CenterVertical
---------------------------------------------------------*/  
function meta:CenterVertical( fraction )

	fraction = fraction or 0.5
	self:SetPos( self.x, self:GetParent():GetTall() * fraction -  self:GetTall() * 0.5 )

end

/*---------------------------------------------------------
	Name: CenterHorizontal
---------------------------------------------------------*/  
function meta:CenterHorizontal( fraction )

	fraction = fraction or 0.5
	self:SetPos( self:GetParent():GetWide() * fraction - self:GetWide() * 0.5, self.y )

end

/*---------------------------------------------------------
	Name: CenterHorizontal
---------------------------------------------------------*/  
function meta:Center()

	self:CenterVertical()
	self:CenterHorizontal()

end

/*---------------------------------------------------------
	Name: CopyBounds
---------------------------------------------------------*/  
function meta:CopyBounds( pnl )

	local x, y, w, h = pnl:GetBounds()
	
	self:SetPos( x, y )
	self:SetSize( w, h )

end

/*---------------------------------------------------------
	Name: GetCookieNumber
---------------------------------------------------------*/  
function meta:SetCookieName( cookiename )

	self.m_strCookieName = cookiename
	
	// If we have a loadcookies function, call it.
	if ( self.LoadCookies ) then
		self:LoadCookies()
		self:InvalidateLayout()
	end

end


/*---------------------------------------------------------
	Name: GetCookieNumber
---------------------------------------------------------*/  
function meta:GetCookieNumber( cookiename, default )

	local name = self:GetCookieName()
	if ( !name ) then return default end
	
	return cookie.GetNumber( name.."."..cookiename, default )

end

/*---------------------------------------------------------
	Name: GetCookie
---------------------------------------------------------*/  
function meta:GetCookie( cookiename, default )

	local name = self:GetCookieName()
	if ( !name ) then return default end
	
	return cookie.GetString( name.."."..cookiename, default )

end

/*---------------------------------------------------------
	Name: SetCookie
---------------------------------------------------------*/  
function meta:SetCookie( cookiename, value )

	local name = self:GetCookieName()
	if ( !name ) then return end
	
	return cookie.Set( name.."."..cookiename, value )

end


/*---------------------------------------------------------
	Name: InvalidateParent
---------------------------------------------------------*/  
function meta:InvalidateParent( layoutnow )

	local parent = self:GetParent()
	if ( !parent ) then return end
	if ( self.LayingOutParent ) then return end
	
	self.LayingOutParent = true
	parent:InvalidateLayout( layoutnow )
	self.LayingOutParent = false

end


/*---------------------------------------------------------
	Name: TellParentAboutSizeChanges
---------------------------------------------------------*/  
function meta:TellParentAboutSizeChanges()

	local w, h = self:GetSize()
	local p = self:GetParent()
	local t = self.m_tSizeChanges
	
	if ( !t || t.Parent != p || t.Width != w || t.Height != h ) then
		self:InvalidateParent()
	end
	
	self.m_tSizeChanges = self.m_tSizeChanges or {}
	self.m_tSizeChanges.Parent = p
	self.m_tSizeChanges.Width = w
	self.m_tSizeChanges.Height = h

end

/*---------------------------------------------------------
	Name: PositionLabel
---------------------------------------------------------*/ 
function meta:PositionLabel( LabelWidth, X, Y, Lbl, Control )

	Lbl:SetWide( LabelWidth )
	Lbl:SetPos( X, Y )
	
	Control.y = Y
	Control:MoveRightOf( Lbl, 0 )

	return Y + math.max( Lbl:GetTall(), Control:GetTall() )

end




/*---------------------------------------------------------
   Name: SetTooltip
---------------------------------------------------------*/
function meta:SetTooltip( tooltip )
	self.strTooltipText = tooltip
end

meta.SetToolTip = meta.SetTooltip

/*---------------------------------------------------------
   Name: SetTooltipPanel
---------------------------------------------------------*/
function meta:SetTooltipPanel( panel )
	self.pnlTooltipPanel = panel
end

meta.SetToolTipPanel = meta.SetTooltipPanel


/*---------------------------------------------------------
   Name: SizeToContentsY (Only works on Labels)
---------------------------------------------------------*/
function meta:SizeToContentsY( tooltip )
	local w, h = self:GetContentSize()
	if (!w || !h ) then return end
	self:SetTall( h )
end

/*---------------------------------------------------------
   Name: SizeToContentsX (Only works on Labels)
---------------------------------------------------------*/
function meta:SizeToContentsX( tooltip )
	local w, h = self:GetContentSize()
	if (!w || !h) then return end
	self:SetWide( w )
end

/*---------------------------------------------------------
   Name: SetSkin
---------------------------------------------------------*/
function meta:SetSkin( strSkin )
	
	if ( self.m_ForceSkinName == strSkin ) then return end
	
	self.m_ForceSkinName = strSkin
	self.m_iSkinIndex = nil
	
end

/*---------------------------------------------------------
   Name: GetSkin
---------------------------------------------------------*/
function meta:GetSkin()

	local skin = nil
	
	if ( derma.SkinChangeIndex() == self.m_iSkinIndex ) then
	
		skin = self.m_Skin
		if ( skin ) then return skin end

	end

	// We have a default skin
	if ( !skin && self.m_ForceSkinName ) then
		skin = derma.GetNamedSkin( self.m_ForceSkinName )
	end
	
	// No skin, inherit from parent
	local parent = self:GetParent()
	if ( !skin && IsValid( parent ) ) then
		skin = parent:GetSkin()
	end
	
	// Parent had no skin, use default
	if ( !skin) then
		skin = derma.GetDefaultSkin()
	end
	
	// Save skin details on us so we don't have to keep looking up
	self.m_Skin 		= skin
	self.m_iSkinIndex 	= derma.SkinChangeIndex()
	
	self:InvalidateLayout( false )
	
	return skin
	
end

/*---------------------------------------------------------
   Name: Returns true if the panel is valid. This does not
		check the type. If the passed object is anything other
		than a panel or nil, this will error. (speed)
---------------------------------------------------------*/
function ValidPanel( pnl )

	if (!pnl) then return false end
	
	return pnl:IsValid() 

end



