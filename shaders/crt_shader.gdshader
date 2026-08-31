shader_type canvas_item;

uniform float scanline_count : hint_range(50.0, 1080.0) = 360.0;
uniform float scanline_intensity : hint_range(0.0, 0.5) = 0.08;
uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.35;

void fragment() {
	// Scanlines horizontais
	float scanline = sin(UV.y * scanline_count * 3.1415926) * 0.5 + 0.5;
	
	// Vinheta escura nos cantos da tela
	vec2 uv_dist = UV * (1.0 - UV.yx);
	float vig = clamp(uv_dist.x * uv_dist.y * 15.0, 0.0, 1.0);
	float vignette_darkness = (1.0 - vig) * vignette_intensity;
	
	// Alpha total do overlay escurecedor (preto translúcido)
	float alpha = clamp(scanline * scanline_intensity + vignette_darkness, 0.0, 0.8);
	COLOR = vec4(0.05, 0.02, 0.01, alpha);
}
