extends Node2D

var light_sprite
var light_pivot
var candle_sprite
var candle_number

var roll = 0.0

var target_scale = Vector2(0.5, 0.5)  # Initial or default scale
var smooth_rate = 0.8  # Adjust for desired smoothing speed (lower for slower)


func _ready():
	light_sprite = get_node("Container/Pivot/Light")
	light_pivot = get_node("Container/Pivot")
	candle_sprite = get_node(("Container/Sprite2D"))
	candle_number = get_node(("Number"))
	#light_sprite.scale = Vector2(3, 1)
	light_sprite.play()
	candle_number.visible = false
	
func _process(delta):
	var gyro = Input.get_gyroscope()
	var grav = Input.get_gravity()
	var acc = Input.get_accelerometer()
	get_node("Control/Gyroscope").text = "Gyroscope: " + str(gyro)
	get_node("Control/Grav").text = "Grav: " + str(grav)
	get_node("Control/Acc").text = "Acc: " + str(acc)
	

	var gravity: Vector3 = Input.get_gravity()
	var roll_acc = atan2(gravity.x, gravity.y) 
	var gyroscope: Vector3 = Input.get_gyroscope().rotated(-Vector3.FORWARD, roll)
	roll = lerp_angle(roll_acc, roll + gyroscope.z * delta, 0.98)
	
	light_pivot.scale = light_pivot.scale.lerp(target_scale, smooth_rate * delta)
	
	print("roll:" + str(roll))
	if(roll > -3 && roll < 0):
		print(str("hot"))
		Input.vibrate_handheld(100)
		target_scale = Vector2(1,1)
		candle_number.visible = true
		
	else:
		target_scale = Vector2(0.5, 0.5)
		
	light_pivot.rotation = roll
	
	
#3-
#0

#-2--1
