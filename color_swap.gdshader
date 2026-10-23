shader_type canvas_item;

uniform vec4 from_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 to_color : source_color = vec4(0.0, 0.0, 1.0, 1.0);
uniform vec4 from_color2 : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 to_color2 : source_color = vec4(0.0, 0.0, 1.0, 1.0);
uniform vec4 from_color3 : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 to_color3 : source_color = vec4(0.0, 0.0, 1.0, 1.0);
uniform vec4 from_color4 : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 to_color4 : source_color = vec4(0.0, 0.0, 1.0, 1.0);
uniform vec4 from_color5 : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 to_color5 : source_color = vec4(0.0, 0.0, 1.0, 1.0);
// 0.0 = exact match only; raise it to catch nearby shades and anti-aliased edges.
uniform float tolerance : hint_range(0.0, 1.0) = 0.05;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	if (distance(tex.rgb, from_color.rgb) <= tolerance) {
		COLOR = to_color;
	} 
	else if (distance(tex.rgb, from_color2.rgb) <= tolerance) {
		COLOR = to_color2;
	} 
	else if (distance(tex.rgb, from_color3.rgb) <= tolerance) {
		COLOR = to_color3;
	} else if (distance(tex.rgb, from_color4.rgb) <= tolerance) {
		COLOR = to_color4;
	} else if (distance(tex.rgb, from_color3.rgb) <= tolerance) {
		COLOR = to_color5;
	} else {
		COLOR = COLOR;
	}
}