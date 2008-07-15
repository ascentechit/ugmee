
PANEL = {}

local Distance 			= 256
local BlurSize			= 0.5
local pnlWindow 		= nil

local Window 			= nil
local Status 			= "Preview"


local sldDistance   	= nil
local lblDistance 		= nil
local lblSize 			= nil
local FocusGrabber  	= false
local ScreenshotTimer	= 0

local strTitle 		= Localize( "SuperDOF_WindowTitle", "Super DOF" )
local strBlurSize 	= Localize( "SuperDOF_BlurSize", "Blur Size:" )
local strDistance 	= Localize( "SuperDOF_Distance", "Focus Distance:" )
local strRender 	= Localize( "SuperDOF_Render", "Render" )
local strScreenshot = Localize( "SuperDOF_Screenshot", "Save Screenshot" )
local strOpenWindow = Localize( "SuperDoF_Open", "Open Window" )
local strInformation =  Localize( "SuperDoF_Warning", "Warning: This is VERY experimental so it might not totally work on your graphics card. \n\nThis effect is not realtime. You render it and then save a screenshot of your render. Also, you will have low fps when previewing - that's normal.")


function PANEL:Init()

	self:SetTitle( strTitle )
	self:SetRenderInScreenshots( false )

	self.BlurSize = vgui.Create( "DNumSlider", self )
		self.BlurSize:SetMin( 0 )
		self.BlurSize:SetMax( 10 )
		self.BlurSize:SetDecimals( 3 )
		self.BlurSize:SetText( strBlurSize )
		self.BlurSize:SetValue( BlurSize )
		function self.BlurSize:OnValueChanged( val ) BlurSize = val end
	
	self.Distance = vgui.Create( "DNumSlider", self )
		self.Distance:SetMin( 0 )
		self.Distance:SetMax( 4096 )
		self.Distance:SetText( strDistance )
		self.Distance:SetValue( Distance )
		function self.Distance:OnValueChanged( val ) Distance = val end
		

	self.Render = vgui.Create( "DButton", self )
		self.Render:SetText( strRender )
		function self.Render:DoClick() Status = "Render" end
		
	self.Screenshot = vgui.Create( "DButton", self )
		self.Screenshot:SetText( strScreenshot )
		function self.Screenshot:DoClick() RunConsoleCommand( "jpeg" ) end

end

function PANEL:ChangeDistanceTo( dist )

	self.Distance:SetValue( dist )

end

function PANEL:PerformLayout()

	self:SetSize( 300, 180 )
	
	DFrame.PerformLayout( self )
	
	self.BlurSize:SetPos( 5, 35 )
	self.BlurSize:StretchToParent( 20, nil, 20, nil )
	self.BlurSize:SetTall( 45 )
	
	self.Distance:StretchToParent( 20, nil, 20, nil )
	self.Distance:SetTall( 45 )	
	self.Distance:MoveBelow( self.BlurSize, 5 )
	
	self.Render:SetWide( 100 )
	self.Render:MoveBelow( self.Distance, 10 )
	self.Render:AlignRight( 20 )
	
	self.Screenshot:CopyBounds( self.Render	)
	self.Screenshot:MoveLeftOf( self.Render, 10 )

end

local paneltypeSuperDOF = vgui.RegisterTable( PANEL, "DFrame" )


local texFSB = render.GetSuperFPTex()
local matFSB = Material( "pp/motionblur" )
local matFB	 = Material( "pp/fb" )

local function RenderDoF( vOrigin, vAngle, vFocus, fAngleSize, radial_steps, passes, drawhud )

	local OldRT 	= render.GetRenderTarget();
	local view 		= {  x = 0, y = 0, w = ScrW(), h = ScrH(), drawhud = drawhud }
	local fDistance = vOrigin:Distance( vFocus )
	
	fAngleSize = fAngleSize * math.Clamp( 256/fDistance, 0.1, 1 ) * 0.5
	
	view.origin = vOrigin
	view.angles = vAngle
	
	// Straight render (to act as a canvas)
	render.RenderView( view )
	render.UpdateScreenEffectTexture()
	
	render.SetRenderTarget( texFSB )
			matFB:SetMaterialFloat( "$alpha", 1  )
			render.SetMaterial( matFB )
			render.DrawScreenQuad()	
	
	local Radials = (math.pi*2) / radial_steps
	
	for mul=(1 / passes), 1, (1 / passes) do
	
		for i=0,(math.pi*2), Radials do
		
			local VA = vAngle * 1 // hack - this makes it copy the angles instead of the reference
			
			// Rotate around the focus point
			VA:RotateAroundAxis( vAngle:Right(), 	math.sin( i + (mul) ) * fAngleSize * mul )
			VA:RotateAroundAxis( vAngle:Up(), 		math.cos( i + (mul) ) * fAngleSize * mul )
			
			ViewOrigin = vFocus - VA:Forward() * fDistance
			
			view.origin = ViewOrigin
			view.angles = VA
			
			// Render to the front buffer
			render.SetRenderTarget( OldRT )
			render.Clear( 0, 0, 0, 255, true )
			render.RenderView( view )
			render.UpdateScreenEffectTexture()
			
			// Copy it to our floating point buffer at a reduced alpha
			render.SetRenderTarget( texFSB )
			local alpha = (Radials/(math.pi*2)) 		// Divide alpha by number of radials
			alpha = alpha * (1-mul)					// Reduce alpha the further away from center we are
			matFB:SetMaterialFloat( "$alpha", alpha  )
			

				render.SetMaterial( matFB )
				render.DrawScreenQuad()

		
		end
		
	end
	
	// Restore RT
	render.SetRenderTarget( OldRT )
	
	// Render our result buffer to the screen
	matFSB:SetMaterialFloat( "$alpha", 1 )
	matFSB:SetMaterialTexture( "$basetexture", texFSB )
		
	render.SetMaterial( matFSB )
	render.DrawScreenQuad()

end

function RenderSuperDoF( ViewOrigin, ViewAngles )

	if ( FocusGrabber ) then
	
		tr = util.TraceLine( util.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetCursorAimVector() ) )
		Distance = tr.HitPos:Distance( ViewOrigin )
		Status = "Preview"
	
		pnlWindow:ChangeDistanceTo( Distance )
	
	end

	local FocusPoint = ViewOrigin + ViewAngles:Forward() * Distance
	
	if ( Status == "Preview" ) then
		
		// A low quality, pretty quickly drawn rough outline
		RenderDoF( ViewOrigin, ViewAngles, FocusPoint, BlurSize, 2, 2, 1 )
		
	elseif ( Status == "Render" ) then
		
		// A great quality render..
		RenderDoF( ViewOrigin, ViewAngles, FocusPoint, BlurSize, 16, 8, 1 )
		Status = "ViewShot"
	
	elseif ( Status == "ViewShot" ) then
		
		matFSB:SetMaterialFloat( "$alpha", 1 )
		matFSB:SetMaterialTexture( "$basetexture", texFSB )
		render.SetMaterial( matFSB )
		render.DrawScreenQuad()
		
	end
	
end

local function RenderSceneHook( ViewOrigin, ViewAngles )

	if ( !ValidPanel( pnlWindow ) ) then return end
	
	// Don't render it when the console is up
	if ( FrameTime() == 0 ) then return end
	
	RenderSuperDoF( ViewOrigin, ViewAngles );
	return true;

end


hook.Add( "RenderScene", "RenderSuperDoF", RenderSceneHook )


local function OpenWindow()

	Status = "Preview"
	
	if ( ValidPanel( pnlWindow ) ) then
	
		pnlWindow:MakePopup()
		pnlWindow:AlignBottom( 50 )
		pnlWindow:CenterHorizontal()
		pnlWindow:SetKeyboardInputEnabled( false )
	
	return end
	
	pnlWindow = vgui.CreateFromTable( paneltypeSuperDOF )
	
	pnlWindow:InvalidateLayout( true )
	pnlWindow:MakePopup()
	pnlWindow:AlignBottom( 50 )
	pnlWindow:CenterHorizontal()
	pnlWindow:SetKeyboardInputEnabled( false )

end

concommand.Add( "pp_superdof", OpenWindow )


/*---------------------------------------------------------
   Mouse button down
---------------------------------------------------------*/   
local function MouseDown( mouse )

	if ( !ValidPanel(pnlWindow) ) then return end

	vgui.GetWorldPanel():MouseCapture( true )
	FocusGrabber = true

end


/*---------------------------------------------------------
   Mouse button released
---------------------------------------------------------*/   
local function MouseUp( mouse )

	if ( !ValidPanel(pnlWindow) ) then return end
	
	vgui.GetWorldPanel():MouseCapture( false )
	FocusGrabber = false
	
end

hook.Add( "GUIMousePressed", "SuperDOFMouseDown", MouseDown )
hook.Add( "GUIMouseReleased", "SuperDOFMouseUp", MouseUp )


/*
// Control Panel
*/
local function BuildControlPanel( CPanel )

	CPanel:Help( strInformation )
	CPanel:Button( strOpenWindow, "pp_superdof" )
	
end

/*
// Tool Menu
*/
local function AddPostProcessMenu()

	spawnmenu.AddToolMenuOption( "PostProcessing", "PPShader", "SuperDoF", "#Super DoF", "", "", BuildControlPanel )

end

hook.Add( "PopulateToolMenu", "AddPostProcessMenu_SuperDoF", AddPostProcessMenu )
