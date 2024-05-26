shader_type canvas_item;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 textColour = texture(TEXTURE, UV);
	float offset = 0.0078;
	// Why not make all grey? Because we need outlines 
	// of objects to still remain. These are black and 
	// colours should be balanced rgb and thus should
	// not be changed. 
	
	// make blue into grey
	if (textColour.b > textColour.g+offset && textColour.b > textColour.r+offset){
		COLOR = vec4(0.6, 0.6, 0.6, 1);
	}
	
	// make green into grey
	else if (textColour.g > textColour.b+offset && textColour.g > textColour.r+offset){
		COLOR = vec4(0.6, 0.6, 0.6, 1);
	}
	
	// make red into grey
	else if (textColour.r > textColour.b+offset && textColour.r > textColour.g+offset){
		COLOR = vec4(0.6, 0.6, 0.6, 1);
	}
		
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
