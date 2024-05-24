extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var sprite = get_node("MeshInstance3D/Pivot/AnimatedSprite3D")
	if sprite != null:
		sprite.play()  # Play the animation
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var gyro = Input.get_gyroscope()
	var grav = Input.get_gravity()
	get_node("Control/Gyroscope").text = "Gyroscope: " + str(gyro)

	# Using our gyro and do a drift correction using our gravity vector gives the best result
	var gyro_and_grav = get_node("MeshInstance3D")
	var new_basis = rotate_by_gyro(gyro, gyro_and_grav.transform.basis, delta).orthonormalized()
	gyro_and_grav.transform.basis = drift_correction(new_basis, grav)


func rotate_by_gyro(p_gyro, p_basis, p_delta):
	var rotate = Basis()

	rotate = rotate.rotated(p_basis.x.normalized(), -p_gyro.x * p_delta)
	rotate = rotate.rotated(p_basis.y.normalized(), -p_gyro.y * p_delta)
	rotate = rotate.rotated(p_basis.z.normalized(), -p_gyro.z * p_delta)

	return rotate * p_basis
	
# This function corrects the drift in our matrix by our gravity vector
func drift_correction(p_basis, p_grav):
	# as always, make sure our vector is normalized but also invert as our gravity points down
	var real_up = -p_grav.normalized()

	# start by calculating the dot product, this gives us the cosine angle between our two vectors
	var dot = p_basis.y.dot(real_up)

	# if our dot is 1.0 we're good
	if dot < 1.0:
		# the cross between our two vectors gives us a vector perpendicular to our two vectors
		var axis = p_basis.y.cross(real_up).normalized()
		var correction = Basis(axis, acos(dot))
		p_basis = correction * p_basis

	return p_basis
