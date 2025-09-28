shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	float speed = 5.0;
	vec2 uv = SCREEN_UV;
	float wave = cos(uv.y * 10.0 + speed * TIME) * 0.01;
	
	uv.x += 2.0 * wave;
	uv.y += -wave * 10.0;
	COLOR = texture(screen_texture, uv);
}
