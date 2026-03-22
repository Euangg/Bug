shader_type canvas_item;

uniform sampler2D screen_texture:hint_screen_texture,filter_nearest;

void fragment() {
	vec4 sprite_color=texture(TEXTURE,UV);
	vec4 screen_color=texture(screen_texture,SCREEN_UV);
	
	if (sprite_color.a==0.)discard;
	
	if(sprite_color==screen_color){
		
	}
	else{
		COLOR=vec4(1,0,0,1);
	}
}