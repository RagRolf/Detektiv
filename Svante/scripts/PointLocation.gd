extends Area2D

var target = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	target = get_global_mouse_position()
	position = target
	#print(target)
