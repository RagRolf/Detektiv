extends Node2D

var light_sprite
var light_pivot
var candle_sprite

var roll = 0.0

func _ready():
	light_sprite = get_node("Pivot/Light")
	light_pivot = get_node("Pivot")
	candle_sprite = get_node(("Sprite2D"))
	#light_sprite.scale = Vector2(3, 1)
	light_sprite.play()
	
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
	
	print(str(roll))
	light_pivot.rotation = roll
