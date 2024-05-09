shader_type spatial;

uniform vec3 water_colour = vec3(0, 0.5, 1.0);
uniform sampler2D screen : hint_screen_texture;
uniform sampler2D depth : hint_depth_texture;

uniform float fog_depth = 5;
uniform float fog_power = 2;

void vertex() {
	// Called for every vertex the material is visible on.vec3(alpha);//
}

void fragment() {
	float alpha = clamp(pow(texture(depth, SCREEN_UV).r * fog_depth, fog_power), 0.0, 1.0);
	ALBEDO.rgb = (texture(screen, SCREEN_UV).rgb * (1.0-alpha)) + (water_colour * (alpha));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
