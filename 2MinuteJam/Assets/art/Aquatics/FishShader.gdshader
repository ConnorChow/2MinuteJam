shader_type spatial;
render_mode cull_disabled, vertex_lighting, specular_schlick_ggx;

uniform sampler2D fish_texture;
uniform vec3 colour;

uniform float swimSpeed = 3;
uniform float side_to_side = 0.1;

uniform float pivot = 1;

uniform float amplitude = 1;
uniform float wave = 1;

uniform float twist = 1;

uniform float mask_black = 0;
uniform float mask_white = 1; 

uniform float specular = 0.75;

uniform float swim_strength_straight = 0.1;
uniform float swim_strength_turning = 1.0;

uniform float random_offset = 137.5;

void vertex() {
	float body = (VERTEX.z + 1.0) / 2.0;
	float gradient = 1.0 - body;
	float mask = smoothstep(mask_black, mask_white, body) ;//* ((swim_strength_straight * (1.0 - INSTANCE_CUSTOM.y)) + (swim_strength_turning * INSTANCE_CUSTOM.y));
	
	float time = TIME * swimSpeed + (INSTANCE_CUSTOM.x * random_offset);
	VERTEX.x += cos(time) * side_to_side;
	
	float pivot_angle = cos(time) * 0.1 * pivot;
	mat2 rotation_matrix = mat2(vec2(cos(pivot_angle), -sin(pivot_angle)), vec2(sin(pivot_angle), cos(pivot_angle)));
	
	VERTEX.xz = rotation_matrix * VERTEX.xz;
	
	VERTEX.x += cos(time + gradient * amplitude) * wave * mask;
	
	float twist_angle = cos(time + gradient * amplitude) * 0.3 * twist;
	mat2 twist_matrix = mat2(vec2(cos(twist_angle), -sin(twist_angle)), vec2(sin(twist_angle), cos(twist_angle)));
	
	VERTEX.xy = mix(VERTEX.xy, twist_matrix * VERTEX.xy, mask);
	
}

void fragment() {
	ALBEDO = texture(fish_texture, UV).xyz;// * colour;
	SPECULAR = specular;
}
