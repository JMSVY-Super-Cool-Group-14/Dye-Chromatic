shader_type canvas_item;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 textColour = texture(TEXTURE, UV);
	float offset = 0.1;
	// make blue into grey
	if (textColour.b > textColour.g+offset && textColour.b > textColour.r+offset){
		COLOR = vec4(0.6, 0.6, 0.6, 1);
	}
	
	// Make green into grey
	else if (textColour.g > textColour.r+offset && textColour.g > textColour.b+offset){
		COLOR = vec4(0.6, 0.6, 0.6, 1);
	}
	
	// make blue+green (cyan) into grey
	else if (textColour.b > textColour.r+offset && textColour.g > textColour.r+offset){
		COLOR = vec4(0.6, 0.6, 0.6, 1);
	}
		
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
