shader_type canvas_item;

uniform float frequency=40;
uniform float depth = 0.25;

void fragment() {
	vec2 uv = SCREEN_UV;
	uv.x += sin(uv.y*frequency+TIME)*depth;
	uv.x = clamp(uv.x,0,1);
	vec3 c = textureLod(SCREEN_TEXTURE,uv,0.0).rgb;
	COLOR.rgb=c;
}