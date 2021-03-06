RENDERMODE_NORMAL			= 0 	// src
RENDERMODE_TRANSCOLOR			= 1	// c*a+dest*(1-a)
RENDERMODE_TRANSTEXTURE			= 2	// src*a+dest*(1-a)
RENDERMODE_GLOW				= 3	// src*a+dest -- No Z buffer checks -- Fixed size in screen space
RENDERMODE_TRANSALPHA			= 4	// src*srca+dest*(1-srca)
RENDERMODE_TRANSADD			= 5	// src*a+dest
RENDERMODE_ENVIROMENTAL			= 6	// not drawn, used for environmental effects
RENDERMODE_TRANSADDFRAMEBLEND		= 7	// use a fractional frame value to blend between animation frames
RENDERMODE_TRANSALPHADD			= 8	// src + dest*(1-a)
RENDERMODE_WORLDGLOW			= 9	// Same as kRenderGlow but not fixed size in screen space
RENDERMODE_NONE				= 10	// Don't render.