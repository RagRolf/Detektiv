extends MeshInstance3D
#
#var gyro;
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#var sprite = get_node("AnimatedSprite3D")
	#if sprite != null:
		#sprite.play()  # Play the animation
	#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#gyro = Input.get_gyroscope()
	#print(gyro)
	#
	#rotate_x(rotation.x)
	#rotate_y(rotation.y)
	#
	#get_node("Control/Gyroscope").text = "Gyroscope: " + str(gyro)
