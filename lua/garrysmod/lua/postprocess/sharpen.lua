
local _Material			= Material( "pp/sharpen" )
_Material:SetMaterialTexture( "$fbtexture", render.GetScreenEffectTexture() )

/*---------------------------------------------------------
   Register the convars that will control this effect
---------------------------------------------------------*/   
local pp_sharpen_contrast 	= CreateClientConVar( "pp_sharpen_contrast", "1", false, false )
local pp_sharpen_distance	= CreateClientConVar( "pp_sharpen_distance", "1", false, false )
local pp_sharpen			= CreateClientConVar( "pp_sharpen", "0", false, false )


function DrawSharpen( contrast, distance )

	render.UpdateScreenEffectTexture()

	_Material:SetMaterialFloat( "$contrast", contrast )
	_Material:SetMaterialFloat( "$distance", distance / ScrW() )
	
	
	render.SetMaterial( _Material )
	render.DrawScreenQuad()
	
end

local function DrawInternal()

	if ( !pp_sharpen:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "sharpen" ) ) then return end

	DrawSharpen( pp_sharpen_contrast:GetFloat(), pp_sharpen_distance:GetFloat() );

end

hook.Add( "RenderScreenspaceEffects", "RenderSharpen", DrawInternal )


/*
// Control Panel
*/
local function BuildControlPanel( CPanel )

	CPanel:AddControl( "Header", { Text = "#Sharpen", Description = "" }  )
	CPanel:AddControl( "CheckBox", { Label = "#Enable", Command = "pp_sharpen" }  )
	
	CPanel:AddControl( "Slider", { Label = "#Distance", Command = "pp_sharpen_distance", Type = "Float", Min = "-5", Max = "5" }  )
	CPanel:AddControl( "Slider", { Label = "#Contrast", Command = "pp_sharpen_contrast", Type = "Float", Min = "0", Max = "20" }  )

end

/*
// Tool Menu
*/
local function AddPostProcessMenu()

	spawnmenu.AddToolMenuOption( "PostProcessing", "PPShader", "Sharpen", "#Sharpen", "", "", BuildControlPanel, { SwitchConVar = "pp_sharpen" } )

end

hook.Add( "PopulateToolMenu", "AddPostProcessMenu_Sharpen", AddPostProcessMenu )
