shader_type canvas_item;

uniform bool damage = true;

void fragment() {
	if(!damage){
	    vec4 c = texture(TEXTURE, UV);
		COLOR.rgba = c.rgba;
	}
	else {
	    vec4 c = texture(TEXTURE, UV);
		if(c.g > 0.7){
			c.b = 0.0;
			c.g = 0.0;
			c.r = 0.0;
		}
		else if(c.g < 0.1 && c.b < 0.1 && c.r <  0.1){
			c.b = 0.2;
			c.g = 0.7;
			c.r = 0.9;
		}
		else{
			c.b = 0.0;
			c.g = 0.0;
			c.r = 0.85;
		}
		COLOR.rgba = c.rgba;
	}
}