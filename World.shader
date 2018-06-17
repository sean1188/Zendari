shader_type canvas_item;
uniform bool rewind;

void fragment() {
	if (rewind){
		COLOR = vec4(0.4, 0.5, 0.95, 0.5);
	}
	else {
		COLOR = vec4(0, 0, 0, 0);
	}
}