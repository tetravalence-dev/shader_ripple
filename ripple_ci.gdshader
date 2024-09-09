shader_type canvas_item;
uniform vec4 color: source_color; 
uniform vec4 color1: source_color;
uniform vec4 color2: source_color;
uniform float num_cells: hint_range(2.0, 20.0, 1.0)=10.0; 
uniform float speed: hint_range(0.1,2.0, 0.01)=1.0;
uniform float smoothness: hint_range(0.5, 2.0, 0.01)=1.0; 
uniform float angle: hint_range(0.0, 360.0)=45.0; 

uniform bool enabled = false;
uniform float start_time = 0.0;

float rectanglef (vec2 uv, float width, float height, float feather){
	vec2 uv_cartesian = uv * 2.0 - 1.0; 
	vec2 uv_reflected = abs(uv_cartesian); 
	float dfx = smoothstep(width,width+feather,uv_reflected.x);
	float dfy = smoothstep(height,height+feather,uv_reflected.y); 
	return max(dfx,dfy); 
}

vec2 rotation (vec2 uv, vec2 center, float ang){
	mat2 rotation = mat2(
					vec2(cos(ang), -sin(ang)), 
					vec2(sin(ang), cos(ang))
					);
	uv -= center; 
	uv *= rotation; 
	uv += center; 
	
	return uv;
}

void fragment(){
	if(enabled){
		vec2 igrid = floor(UV * num_cells)/num_cells;

		igrid = rotation(igrid, vec2(0.5), angle * PI/180.0); 
		
		
		//igrid.x += 2.0 - mod(start_time*speed,4.0); //for shader activated from script with button
		igrid.x += 2.0 - mod(TIME*speed,4.0); //for shader always active
		
		vec2 fgrid = fract(UV * num_cells); 
		float rect_mask = rectanglef(igrid, 0.001,2.0,smoothness); 
		float grid_mask = 1.0 - rectanglef(fgrid,rect_mask,rect_mask,0.0); 
		float outline_mask = 1.0 - rectanglef(fgrid,rect_mask+0.1,rect_mask+0.1,0.0) - grid_mask; 
		vec4 outline = outline_mask * color; 
		
		vec4 tex = texture(TEXTURE,UV) * COLOR; 
		float grid_position = fract((igrid.x - 0.5) / num_cells);
		vec4 grid_color = grid_position < 0.5 ? color1 : color2;
		
		vec4 output = mix(tex, grid_color * grid_mask * grid_color.a, grid_mask * grid_color.a) + outline; 
		COLOR = vec4(output.rgb, tex.a * (outline_mask + grid_mask)); 
		
	}
}
