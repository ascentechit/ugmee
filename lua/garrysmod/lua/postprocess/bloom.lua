

local mat_Downsample	= Material( "pp/downsample" )
local mat_Bloom			= Material( "pp/bloom" )
local mat_BlurX			= Material( "pp/blurx" )
local mat_BlurY			= Material( "pp/blury" )

local tex_Bloom0		= render.GetBloomTex0()
local tex_Bloom1		= render.GetBloomTex1()

mat_Downsample:SetMaterialTexture( "$fbtexture", render.GetScreenEffectTexture() )

/*---------------------------------------------------------
   Register the convars that will control this effect
---------------------------------------------------------*/   
local pp_bloom 			= CreateClientConVar( "pp_bloom", 			"0", 	true, 	false )				// On/Off
local pp_bloom_darken 	= CreateClientConVar( "pp_bloom_darken", 	"0.65", false, 	false )		// Decides the strength of the bloom
local pp_bloom_multiply = CreateClientConVar( "pp_bloom_multiply", 	"2.0", 	false, 	false )	// Decides the strength of the bloom
local pp_bloom_sizex 	= CreateClientConVar( "pp_bloom_sizex", 	"9.0", 	false, 	false )		// Horizontal blur size
local pp_bloom_sizey 	= CreateClientConVar( "pp_bloom_sizey", 	"9.0", 	false, 	false )		// Vertical blur size
local pp_bloom_color 	= CreateClientConVar( "pp_bloom_color", 	"1.0", 	false, 	false )
local pp_bloom_color_r 	= CreateClientConVar( "pp_bloom_color_r", 	"255", 	false, 	false )
local pp_bloom_color_g 	= CreateClientConVar( "pp_bloom_color_g", 	"255", 	false, 	false )
local pp_bloom_color_b	= CreateClientConVar( "pp_bloom_color_b", 	"255", 	false, 	false )
local pp_bloom_passes 	= CreateClientConVar( "pp_bloom_passes", 	"1", 	false, 	false )

/*---------------------------------------------------------
   Can be called from engine or hooks using bloom.Draw
---------------------------------------------------------*/
function DrawBloom( darken, multiply, sizex, sizey, passes, color, colr, colg, colb )

	// No bloom for crappy gpus
	if ( !render.SupportsPixelShaders_2_0() ) then return end
	
	// Todo: Does this stop it working properly when rendered to a rect?
	local w = ScrW()
	local h = ScrH()
	
	// Copy the backbuffer to the screen effect texture
	render.UpdateScreenEffectTexture()
	
	// Store the render target so we can swap back at the end
	local OldRT = render.GetRenderTarget();
	
	// The downsample material adjusts the contrast
	mat_Downsample:SetMaterialFloat( "$darken", darken )
	mat_Downsample:SetMaterialFloat( "$multiply", multiply  )
	
		
	// Downsample to BloomTexture0
	render.SetRenderTarget( tex_Bloom0 )
	
	render.SetMaterial( mat_Downsample )
	render.DrawScreenQuad()			 
					 
	mat_BlurX:SetMaterialTexture( "$basetexture", tex_Bloom0 )
	mat_BlurY:SetMaterialTexture( "$basetexture", tex_Bloom1  )
	mat_BlurX:SetMaterialFloat( "$size", sizex )
	mat_BlurY:SetMaterialFloat( "$size", sizey )
	
	for i=1, passes do

		render.SetRenderTarget( tex_Bloom1 )
		render.SetMaterial( mat_BlurX )
		render.DrawScreenQuad()

		render.SetRenderTarget( tex_Bloom0 )
		render.SetMaterial( mat_BlurY )
		render.DrawScreenQuad()

	end
			 
	render.SetRenderTarget( OldRT );
	
	mat_Bloom:SetMaterialFloat( "$levelr", colr )
	mat_Bloom:SetMaterialFloat( "$levelg", colg )
	mat_Bloom:SetMaterialFloat( "$levelb", colb )
	mat_Bloom:SetMaterialFloat( "$colormul", color )
	mat_Bloom:SetMaterialTexture( "$basetexture", tex_Bloom0 )
	
	render.SetMaterial( mat_Bloom )
	render.DrawScreenQuad()
	
end


/*---------------------------------------------------------
   The function to draw the bloom (called from the hook)
---------------------------------------------------------*/
local function DrawInternal()

	// No bloom for crappy gpus
	
	if ( !render.SupportsPixelShaders_2_0() ) then return end	
	if ( !pp_bloom:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "bloom" ) ) then return end
	
	DrawBloom( pp_bloom_darken:GetFloat(), 
				pp_bloom_multiply:GetFloat(),
				pp_bloom_sizex:GetFloat(),
				pp_bloom_sizey:GetFloat(),
				pp_bloom_passes:GetFloat(),
				pp_bloom_color:GetFloat(),
				pp_bloom_color_r:GetFloat()/255,
				pp_bloom_color_g:GetFloat()/255,
				pp_bloom_color_b:GetFloat()/255 )
	

end



hook.Add( "RenderScreenspaceEffects", "RenderBloom", DrawInternal )



/*
// Control Panel
*/
local function BuildControlPanel( CPanel )

	CPanel:AddControl( "Header", { Text = "#Bloom", Description = "#Bloom_Information" }  )
	CPanel:AddControl( "CheckBox", { Label = "#Bloom_Toggle", Command = "pp_bloom" }  )
	
	local params = { Options = {}, CVars = {}, Label = "#Presets", MenuButton = "1", Folder = "bloom" }
	params.Options[ "#Default" ] = {pp_bloom_passes	=		"1",
									pp_bloom_darken	=		"0.65",
									pp_bloom_multiply =		"2.0",
									pp_bloom_sizex =		"9",
									pp_bloom_sizey = 		"9",
									pp_bloom_color =		"1.0",
									pp_bloom_color_r =		"255",
									pp_bloom_color_g =		"255",
									pp_bloom_color_b =		"255" }
									
	params.CVars = { "pp_bloom_passes",
						"pp_bloom_darken",
						"pp_bloom_multiply",
						"pp_bloom_sizex",
						"pp_bloom_sizey",
						"pp_bloom_color",
						"pp_bloom_color_r",
						"pp_bloom_color_g",
						"pp_bloom_color_b" }
						
	CPanel:AddControl( "ComboBox", 	params )
	
	CPanel:AddControl( "Slider", { Label = "#Bloom_Passes", Command = "pp_bloom_passes", Type = "Integer", Min = "0", Max = "30" }  )
	CPanel:AddControl( "Slider", { Label = "#Bloom_Darken", Command = "pp_bloom_darken", Type = "Float", Min = "0", Max = "1" }  )
	CPanel:AddControl( "Slider", { Label = "#Bloom_Multiply", Command = "pp_bloom_multiply", Type = "Float", Min = "0", Max = "5" }  )	
	CPanel:AddControl( "Slider", { Label = "#Bloom_BlurX", Command = "pp_bloom_sizex", Type = "Float", Min = "0", Max = "50" }  )	
	CPanel:AddControl( "Slider", { Label = "#Bloom_BlurY", Command = "pp_bloom_sizey", Type = "Float", Min = "0", Max = "50" }  )	
	CPanel:AddControl( "Slider", { Label = "#Bloom_Color_Multiplier", Command = "pp_bloom_color", Type = "Float", Min = "0", Max = "20" }  )	

	CPanel:AddControl( "Color", { Label = "#Bloom_Color", Red = "pp_bloom_color_r", Green = "pp_bloom_color_g", Blue = "pp_bloom_color_b", ShowAlpha = "0", ShowHSV = "1", ShowRGB = "1" }  )			
	
end

/*
// Tool Menu
*/
local function AddPostProcessMenu()

	spawnmenu.AddToolMenuOption( "PostProcessing", "PPShader", "Bloom", "#Bloom", "", "", BuildControlPanel, { SwitchConVar = "pp_bloom" } )

end

hook.Add( "PopulateToolMenu", "AddPostProcessMenu_Bloom", AddPostProcessMenu )
