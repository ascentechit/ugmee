
//
// You can use this function to add your own CLASS_ var.
// Adding in this way will ensure your CLASS_ doesn't collide with another
//

function Add_NPC_Class( name )

	_G[ name ] = NUM_AI_CLASSES
	NUM_AI_CLASSES = NUM_AI_CLASSES + 1

end
