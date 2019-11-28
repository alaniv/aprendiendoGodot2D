shader_type canvas_item;
uniform float trans_param = 0.0;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec3 c = textureLod(SCREEN_TEXTURE,uv,0.0).rgb;
	if(c.b > 0.8){ // barras
		c.g = c.g * 0.6;
		c.r = c.r * 0.25;
		c.b = c.b * 0.8;
	}
	else if(c.g > 0.8 &&  c.r > 0.8){ // la parte amarillenta del pasto
		c.g = c.g * 0.52;
		c.r = c.r * 0.22;
		c.b = c.b * 2.7;
	} else if(c.g > 0.8 &&  c.r <= 0.8){ // copa alta, hojas
		c.g = c.g * 0.33;
		c.r = c.r * 0.25;
		c.b = c.b * 1.8;
	} else if(c.g > 0.5 &&  c.r <= 0.6){ //plantas y copa baja
		c.g = c.g*0.2;
		c.r = c.r*0.2;
		c.b += 0.3;
	} else{ //maderas
		c.g = c.g *0.3;
		c.r = c.r *0.2;
		c.b += 0.15;
	}

	COLOR.rgb=(1.0-trans_param)*(c.rgb)+ (trans_param)*textureLod(SCREEN_TEXTURE,uv,0.0).rgb;
	
}