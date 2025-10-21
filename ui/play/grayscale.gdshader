shader_type canvas_item;

uniform float intensity:hint_range(0.0, 1.0)=0.0;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec4 origin_color = textureLod(screen_texture, SCREEN_UV, 0.0);
	float gray=dot(origin_color.rgb,vec3(0.299,0.587,0.144));
	vec3 final_color=mix(origin_color.rgb,vec3(gray),intensity);
	COLOR=vec4(final_color,origin_color.a);
}