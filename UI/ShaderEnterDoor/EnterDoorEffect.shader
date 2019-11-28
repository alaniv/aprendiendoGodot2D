shader_type canvas_item;
uniform float xar = 0.55;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec3 c = textureLod(SCREEN_TEXTURE,uv,0.0).rgb;
	if(uv.x < xar || uv.x > 1.0-xar){
		c.r = 0.973;
		c.g = 0.816;
		c.b = 0.533;
	}
	COLOR.rgb=c;
}