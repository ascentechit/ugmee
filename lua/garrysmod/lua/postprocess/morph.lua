
local mat_Morph			= Material( "pp/morph/refract" )
local mat_Brush			= Material( "pp/morph/brush1" )
local mat_BrushOut		= Material( "pp/morph/brush_outline" )
local mat_White			= Material( "white" )
local tex_MorphBuffer	= render.GetMorphTex0()
mat_Morph:SetMaterialTexture( "$fbtexture", render.GetScreenEffectTexture() )

Morph = {}

Morph.Clear 		= true
Morph.Drawing 		= false
Morph.BrushSize 	= 64

// This morph was so awesome. It was just like in photoshop or something
// But it turned out that it only worked on my Geforce 7800GTX
// So I had to make it dumb :(

// Maybe one day it'll be awesome again!


/*---------------------------------------------------------
   Register the convars that will control this effect
---------------------------------------------------------*/   
local pp_morph 			= CreateClientConVar( "pp_morph", "0", false, false )
local pp_morph_scale	= CreateClientConVar( "pp_morph_scale", "0.2", false, false )


local function MorphFrameVisible()

	if ( !Morph.Frame ) then return false end
	return Morph.Frame:IsVisible()

end


/*---------------------------------------------------------
   Draws the morph - you can call this from a function if you need to.
---------------------------------------------------------*/ 
function DrawMorph( size )

	if ( !render.SupportsPixelShaders_2_0() ) then return end
	if ( !render.SupportsHDR() ) then return end

	// Copy the backbuffer to the screen effect texture
	render.UpdateScreenEffectTexture()

	// Clear the morph buffer
	if (Morph.Clear) then
	
		render.ClearRenderTarget( tex_MorphBuffer, Color( 128, 128, 128, 255 ) )
		Morph.Clear = false
		
	end
	
	local x, y = gui.MousePos()
	
	// Here's the situation with this.
	// I had it set up awesome, when it drew it just used the additive blend mode and it added/subtracted just fine.
	// Then I found out it didn't work on ATI cards so I had to complicate everything.

	if (Morph.Drawing && MorphFrameVisible()) then
			
		local OldRT = render.GetRenderTarget();
		render.SetRenderTarget( tex_MorphBuffer )
		render.SetMaterial( mat_Brush )
		
		// Interpolate the two positions
		local vStart 	= Vector ( Morph.oldX, Morph.oldY, 0 )
		local vEnd 		= Vector ( x, y, 0 )
		local vDiff 	= vEnd-vStart
		local fLen 		= vDiff:Length()
		local vNorm		= vDiff:GetNormalized()
		
		color = Color( 128, 128, 128, 16 )
		
		local r = (Morph.oldX - x)*10
		local g = (Morph.oldY - y)*10
		
		color.r = color.r + math.Clamp( r, -127, 127 )
		color.g = color.g + math.Clamp( g, -127, 127 )
		
		
		if ( math.abs(r) > 5 || math.abs(g) > 5 ) then
		
			for i=0, fLen, 16 do
		
				render.DrawQuadEasy( vStart + vNorm*i, Vector( 0, 0, -1 ), Morph.BrushSize, Morph.BrushSize, color )
		
			end		
		
		end
		
		render.SetRenderTarget( OldRT )
	
	end
	
	Morph.oldX = x
	Morph.oldY = y
	
	mat_Morph:SetMaterialFloat( "$refractamount", size )
	mat_Morph:SetMaterialTexture( "$normalmap", tex_MorphBuffer )
	mat_Morph:SetMaterialTexture( "$basetexture", tex_MorphBuffer )

	
	
	render.SetMaterial( mat_Morph )
	
	render.DrawScreenQuad()
	
	// Draw the handle
	if ( vgui.IsHoveringWorld() && MorphFrameVisible()) then
		render.SetMaterial( mat_BrushOut )
		render.DrawQuadEasy( Vector( Morph.oldX, Morph.oldY, 0 ), Vector( 0, 0, -1 ), Morph.BrushSize, Morph.BrushSize, color_white )
	end
	
end

/*---------------------------------------------------------
   Hooked function to draw the morph
---------------------------------------------------------*/ 
local function DrawInternal()

	if ( !pp_morph:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "morph" ) ) then return end

	DrawMorph( pp_morph_scale:GetFloat() );

end

hook.Add( "RenderScreenspaceEffects", "DrawMorph", DrawInternal )

/*---------------------------------------------------------
   Mouse button down
---------------------------------------------------------*/   
local function MouseDown( mouse )

	if (!MorphFrameVisible()) then return end

	// This makes it so that even if you're hovering over another panel when you
	// release the mouse - it will still send the release event to this panel
	vgui.GetWorldPanel():MouseCapture( true )
	
	Morph.Drawing = true

end


/*---------------------------------------------------------
   Mouse button released
---------------------------------------------------------*/   
local function MouseUp( mouse )

	if (!MorphFrameVisible()) then return end
	
	vgui.GetWorldPanel():MouseCapture( false )
	
	Morph.Drawing = false
	
end

hook.Add( "GUIMousePressed", "MorphMouseDown", MouseDown )
hook.Add( "GUIMouseReleased", "MorphMouseUp", MouseUp )


/*---------------------------------------------------------
   This is a console command that opens the morph window
---------------------------------------------------------*/   
local function MorphFrame( player, command, arguments )

	if (Morph.Frame) then
	
		Morph.Frame:SetVisible( true )
	
	return end

	
	local frame = vgui.Create( "Frame" )
	frame:SetName( "Morph" )	

	
	// Brush Size Slider
	
	local brushsize = function( panel, message, param1, param2 )
	
		if (message != "SliderMoved") then return end
		Morph.BrushSize = param1
	
	end
	
	local slider = vgui.Create( "Slider", frame, "MorphSlider" )
	slider:PostMessage( "SetLower", "f", "8" )
	slider:PostMessage( "SetHigher", "f", "256" )
	slider:PostMessage( "SetValue", "f", Morph.BrushSize )
	slider:SetActionFunction( brushsize )
	
	
	// Refract Size Slider
	
	local refractsize = function( panel, message, param1, param2 )
	
		if (message != "SliderMoved") then return end
		
		RunConsoleCommand( "pp_morph_scale", param1 )
	
	end
	
	local slider = vgui.Create( "Slider", frame, "RefractSlider" )
	slider:PostMessage( "SetInteger", "b", "0" )
	slider:PostMessage( "SetLower", "f", "-1.0" )
	slider:PostMessage( "SetHigher", "f", "1.0" )
	slider:PostMessage( "SetValue", "f", pp_morph_scale:GetFloat() )
	
	slider:SetActionFunction( refractsize )
	
	
	// Clear Button
	
	local clear = function( panel, message, param1, param2 )
		
		if (message != "Command") then return end
		Morph.Clear = true
		
	end
	
	local button = vgui.Create( "Button", frame, "ClearButton" )
	button:SetActionFunction( clear )
	
	
	// Screenshot Button
	
	local screenshot = function( panel, message, param1, param2 )
		
		if (message != "Command") then return end
		
		frame:SetVisible( false )
		
		timer.Simple( 0.1, LocalPlayer().ConCommand, LocalPlayer(), "jpeg\n" )
		timer.Simple( 0.2, frame.SetVisible, frame, true )
		
	end
	
	local button = vgui.Create( "Button", frame, "ScreenshotButton" )
	button:SetActionFunction( screenshot )
	
	frame:LoadControlsFromFile( "resource/ui/Morph.res" )	
	frame:SetKeyBoardInputEnabled( false )
	frame:SetMouseInputEnabled( true )
	frame:SetVisible( true )

	Morph.Frame = frame	
	
	// Turn morphing on
	RunConsoleCommand( "pp_morph", "1" )

end

concommand.Add( "pp_morph_open", MorphFrame )

/*
// Control Panel
*/
local function BuildControlPanel( CPanel )

	CPanel:AddControl( "Header", { Text = "#Morph", Description = "#Morph_Information" }  )
	CPanel:AddControl( "CheckBox", { Label = "#Morph_Toggle", Command = "pp_morph" }  )
	CPanel:Button( "#Morph_Open", "pp_morph_open" )

end

/*
// Tool Menu
*/
local function AddPostProcessMenu()

	spawnmenu.AddToolMenuOption( "PostProcessing", "PPShader", "Morph", "#Morph", "", "", BuildControlPanel, { SwitchConVar = "pp_morph" } )

end

hook.Add( "PopulateToolMenu", "AddPostProcessMenu_Morph", AddPostProcessMenu )