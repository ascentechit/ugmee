

/*
   Convenience function to build a vertex
   The only parameter that's mandatory is pos
*/
function Vertex( pos, u, v, normal )

	return { pos = pos, u = u, v = v, normal = normal }
	
end


/*
   Convenience function to make a mesh cube table
*/
function MeshCube( size, texturescale, pos )

	pos = pos or Vector(0,0,0)

	return {

		// Top
		Vertex( Vector(  size,  size, size ) + pos, texturescale, texturescale ),
		Vertex( Vector(  size, -size, size ) + pos, texturescale, 0 ),
		Vertex( Vector( -size, -size, size ) + pos, 0, 0 ),
		Vertex( Vector(  -size, size, size ) + pos, 0, texturescale ),
		Vertex( Vector(  size,  size, size ) + pos, texturescale, texturescale ),
		Vertex( Vector( -size, -size, size ) + pos, 0, 0 ),

		// Bottom
		Vertex( Vector( -size, -size, -size ) + pos, 0, 0 ),
		Vertex( Vector(  size, -size, -size ) + pos, texturescale, 0 ),
		Vertex( Vector( -size,  size, -size ) + pos, 0, texturescale ),
		Vertex( Vector(  size, -size, -size ) + pos, texturescale, 0 ),
		Vertex( Vector(  size,  size, -size ) + pos, texturescale, texturescale ),
		Vertex( Vector( -size,  size, -size ) + pos, 0, texturescale ),
		
		// LEFT
		Vertex( Vector( size,  size,  size ) + pos, texturescale, texturescale ),
		Vertex( Vector( size,  size, -size ) + pos, texturescale, 0 ),
		Vertex( Vector( size, -size, -size ) + pos, 0, 0 ),
		Vertex( Vector( size, -size,  size ) + pos, 0, texturescale ),
		Vertex( Vector( size,  size,  size ) + pos, texturescale, texturescale ),
		Vertex( Vector( size, -size, -size ) + pos, 0, 0 ),

		// RIGHT
		Vertex( Vector( -size, -size, -size ) + pos, 0, 0 ),
		Vertex( Vector( -size,  size, -size ) + pos, texturescale, 0 ),
		Vertex( Vector( -size, -size,  size ) + pos, 0, texturescale ),
		Vertex( Vector( -size,  size, -size ) + pos, texturescale, 0 ),
		Vertex( Vector( -size,  size,  size ) + pos, texturescale, texturescale ),
		Vertex( Vector( -size, -size,  size ) + pos, 0, texturescale ),
		
		// FRONT
		Vertex( Vector( size, -size,  size ) + pos, texturescale, texturescale ),
		Vertex( Vector( size, -size, -size ) + pos, texturescale, 0 ),
		Vertex( Vector( -size, -size, -size ) + pos, 0, 0 ),
		Vertex( Vector( -size, -size,  size ) + pos, 0, texturescale ),
		Vertex( Vector( size, -size,  size ) + pos, texturescale, texturescale ),
		Vertex( Vector( -size, -size, -size ) + pos, 0, 0 ),

		// BACK
		Vertex( Vector(  -size, size, -size ) + pos, 0, 0 ),
		Vertex( Vector(  size, size, -size ) + pos, texturescale, 0 ),
		Vertex( Vector( -size, size,  size ) + pos, 0, texturescale ),
		Vertex( Vector( size, size, -size ) + pos, texturescale, 0 ),
		Vertex( Vector( size, size,  size ) + pos, texturescale, texturescale ),
		Vertex( Vector( -size, size,  size ) + pos, 0, texturescale ),

		}

end

/*
   Convenience function to make a quad
*/
function MeshQuad( v1, v2, v3, v4, t )

	return 
	{		
		Vertex( v1, 0, 0 ),
		Vertex( v2, (v1-v2):Length() * t, 0 ),
		Vertex( v4, 0, (v1-v4):Length() * t ),
		Vertex( v2, (v1-v2):Length() * t, 0 ),
		Vertex( v3, (v3-v4):Length() * t, (v2-v3):Length() * t ),
		Vertex( v4, 0, (v1-v4):Length() * t ),
	}	
end
