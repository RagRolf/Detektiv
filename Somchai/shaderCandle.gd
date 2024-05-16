extends Node


#shader_type spatial;
#
#uniform float dissolve_factor : hint_range(0, 1);
#
#void vertex() {
	#// Move vertices based on dissolve factor
	#VERTEX.y += (sin(VERTEX.x + VERTEX.z) * dissolve_factor);
#}
#
#void fragment() {
	#// Change color based on dissolve factor
	#ALBEDO = mix(vec3(1.0), vec3(0.0), dissolve_factor);
#}



#var dissolve_factor = 0.0
#
#func _process(delta):
	#dissolve_factor += delta * 0.1
	#material.set_shader_param("dissolve_factor", dissolve_factor)
