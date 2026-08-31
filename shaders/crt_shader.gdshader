shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float scanline_count : hint_range(0.0, 1080.0) = 360.0;
uniform float scanline_intensity : hint_range(0.0, 1.0) = 0.12;
uniform float curvature : hint_range(0.0, 0.1) = 0.015;
uniform float vignette_intensity : hint_range(0.0, 2.0) = 0.45;
uniform vec4 vignette_color : source_color = vec4(0.12, 0.08, 0.05, 1.0);

vec2 curve(vec2 uv) {
	uv = (uv - 0.5) * 2.0;
	uv *= 1.0 + pow((abs(uv.yx) / 4.0), vec2(2.0)) * curvature;
	uv = (uv / 2.0) + 0.5;
	return uv;
}

void fragment() {
	vec2 curved_uv = curve(SCREEN_UV);
	
	// Limites da tela curvada
	if (curved_uv.x < 0.0 || curved_uv.x > 1.0 || curved_uv.y < 0.0 || curved_uv.y > 1.0) {
		COLOR = vec4(0.05, 0.03, 0.03, 1.0);
		return;
	}
	
	vec4 tex_color = texture(screen_texture, curved_uv);
	
	// Scanlines sutis
	float scanline = sin(curved_uv.y * scanline_count * 3.14159) * 0.5 + 0.5;
	tex_color.rgb -= scanline * scanline_intensity;
	
	// Vinheta quente de taverna
	vec2 uv_dist = curved_uv * (1.0 - curved_uv.yx);
	float vig = uv_dist.x * uv_dist.y * 15.0;
	vig = clamp(pow(vig, vignette_intensity), 0.0, 1.0);
	tex_color.rgb = mix(vignette_color.rgb, tex_color.rgb, vig);
	
	COLOR = tex_color;
}
