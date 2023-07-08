shader_type canvas_item;

uniform vec4 color = vec4(1, 1, 1, 1);
uniform float flashstate;
uniform float glowfactor = 0.1;
uniform float timefactor = 1.0;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	COLOR = mix(pixelColor, color, (sin(TIME * timefactor) * glowfactor + glowfactor) * flashstate);
	COLOR.a = pixelColor.a;
}
