//=============================================================================//
//  ___  ___   _   _   _    __   _   ___ ___ __ __
// |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
//  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
//  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2007
//										 
//=============================================================================//


local PANEL = {}

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Init()

	self.StartGame = vgui.Create( "DButton", self )
	self.StartGame:SetText( "Start Game" )
	self.StartGame:SetSize( 100, 20 )
	self.StartGame.DoClick = function() self:LaunchGame() end
	self.StartGame:SetDisabled( true )
	
	self.Help = vgui.Create( "DLabel", self )
	self.Help:SetText( "#ChooseMapHelp" )
	self.Help:SetTextColor( Color( 0, 0, 0, 230 ) )
	
	// Restore the saved hostname
	RunConsoleCommand( "hostname", cookie.GetString( "menuui.hostname", GetConVarString( "hostname" ) ) )

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 190, 190, 190, 255 ) )

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:PerformLayout()

	self.StartGame:SetPos( self:GetWide() - self.StartGame:GetWide() - 10, self:GetTall() - self.StartGame:GetTall() - 10 )
	
	self.Help:SetPos( 10, 10 )
	self.Help:SizeToContents()
	
end


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:SetMap( strMap )

	self.Map = strMap
	self.StartGame:SetDisabled( false )

end

/*--------------------------------------------------------

---------------------------------------------------------*/
function PANEL:SetMultiplayer()
	self.Multiplayer = true
end


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:LaunchGame()

	// Error Sound?
	if (!self.Map) then return end
	
	// This hook is used to close all of the GAMEUI windows.
	hook.Call( "StartGame", {} )
	
	RunConsoleCommand( "progress_enable" )
	
	if ( !self.Multiplayer ) then
	
		RunConsoleCommand( "disconnect" )
		RunConsoleCommand( "maxplayers", 1 )
		
	else
	
		RunConsoleCommand( "disconnect" )
		RunConsoleCommand( "sv_cheats", "0" )
		
		// Set maxplayers..
		timer.Simple( 0.1, function() RunConsoleCommand( "maxplayers", GetConVarNumber( "sv_maxplayers" ) ) end )
		
	end
	
	// This tiny delay is to allow the disconnect, then allow maxplayers to change.
	timer.Simple( 0.2, function() RunConsoleCommand( "map", self.Map ) end )
	
	// Save the hostname
	cookie.Set( "menuui.hostname", GetConVarString( "hostname" ) )
		
end



vgui.Register( "StartGame", PANEL, "Panel" )
