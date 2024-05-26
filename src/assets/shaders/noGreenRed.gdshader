shader_type canvas_item;

void fragment() {
	vec4 textColour = texture(TEXTURE, UV);
	float offset = 0.1;
	// make green into grey
	if (textColour.g > textColour.b+(offset/2.0) && textColour.g > textColour.r+offset){
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
