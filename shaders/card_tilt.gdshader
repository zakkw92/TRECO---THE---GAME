shader_type canvas_item;

// Parâmetros de Inclinação 3D
uniform vec2 mouse_offset = vec2(0.0, 0.0); // -1.0 a 1.0
uniform float max_tilt_angle : hint_range(0.0, 0.3) = 0.14;

// Efeito Foil / Holográfico (Estilo Balatro)
uniform bool is_foil = false;
uniform bool is_manilha = false;
uniform bool is_zap = false;
uniform float foil_intensity : hint_range(0.0, 1.0) = 0.45;
uniform float shine_progress : hint_range(0.0, 1.0) = 0.0;

// Efeito de Dissolução / Queima
uniform float dissolve_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 burn_color : source_color = vec4(1.0, 0.6, 0.1, 1.0);

// Deformação de Vértice para Perspectiva 3D
void vertex() {
	vec2 centered = VERTEX / vec2(90.0, 130.0) - vec2(0.5, 0.5);
	
	// Deslocamento de perspectiva 3D simulada
	float depth = (centered.x * mouse_offset.x + centered.y * mouse_offset.y) * max_tilt_angle;
	VERTEX.x += centered.x * depth * 25.0;
	VERTEX.y += centered.y * depth * 25.0;
	
	// Rotação suave baseada na inclinação
	VERTEX.x -= mouse_offset.y * centered.y * 8.0;
	VERTEX.y += mouse_offset.x * centered.x * 8.0;
}

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	
	// 1. Efeito de Dissolução
	if (dissolve_amount > 0.0) {
		float noise = fract(sin(dot(UV * 25.0, vec2(12.9898, 78.233))) * 43758.5453);
		if (noise < dissolve_amount) {
			discard;
		} else if (noise < dissolve_amount + 0.08) {
			COLOR = mix(tex_color, burn_color, 0.85);
			return;
		}
	}
	
	// 2. Reflexo de Luz Especular (Gleam / Glare do Balatro)
	vec2 glare_uv = UV - vec2(0.5, 0.5) + mouse_offset * 0.35;
	float glare = smoothstep(0.45, 0.0, length(glare_uv));
	tex_color.rgb += vec3(glare * 0.18);
	
	// 3. Efeito Foil Metálico / Holográfico
	if (is_foil || is_manilha) {
		float rainbow_pos = UV.x * 2.0 + UV.y * 3.0 + mouse_offset.x * 1.5 + TIME * 0.8;
		vec3 rainbow = 0.5 + 0.5 * cos(rainbow_pos * 6.28318 + vec3(0.0, 2.0, 4.0));
		
		if (is_zap) {
			// Zap: Dourado / Esmeralda vivo
			vec3 zap_glow = mix(vec3(1.0, 0.85, 0.2), vec3(0.2, 1.0, 0.5), sin(TIME * 4.0) * 0.5 + 0.5);
			tex_color.rgb = mix(tex_color.rgb, zap_glow, foil_intensity * 0.55 + glare * 0.3);
		} else {
			// Manilhas: Brilho iridescente sutil
			tex_color.rgb = mix(tex_color.rgb, tex_color.rgb * rainbow * 1.5, foil_intensity * 0.4);
		}
	}
	
	COLOR = tex_color;
}
