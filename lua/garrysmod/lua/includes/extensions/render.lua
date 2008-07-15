
// Return if there's nothing to add on to
if (!render) then return end


/*---------------------------------------------------------
   Name:	ClearRenderTarget
   Params: 	<texture> <color>
   Desc:	Clear a render target
---------------------------------------------------------*/   
function render.ClearRenderTarget( rt, color )

	local OldRT = render.GetRenderTarget();
		render.SetRenderTarget( rt )
		render.Clear( color.r, color.g, color.b, color.a )
	render.SetRenderTarget( OldRT )

end


/*---------------------------------------------------------
   Name:	SupportsHDR
   Params: 	
   Desc:	Return true if the client supports HDR
---------------------------------------------------------*/   
function render.SupportsHDR( )

	if ( render.GetDXLevel() < 80 ) then return false end

	return true
	
end


/*---------------------------------------------------------
   Name:	CopyTexture
   Params: 	<texture from> <texture to>
   Desc:	Copy the contents of one texture to another
---------------------------------------------------------*/   
function render.CopyTexture( from, to )

	local OldRT = render.GetRenderTarget();
		
		render.SetRenderTarget( from )
		render.CopyRenderTargetToTexture( to )
		
	render.SetRenderTarget( OldRT )

end