extends Node3D


var pitch: float = 0.0
var roll: float = 0.0
var yaw: float = 0.0

var initial_yaw : float = 0.0

var k : float = 0.98

#@onready var MainScene = load("res://David/Main_Menu.tscn")

#var once = false

#var timer

func _ready():
	await get_tree().process_frame
	#var magnet: Vector3 = Input.get_magnetometer()
	#timer = Timer.new()
	#timer.wait_time = 2.0
	#get_tree().root.add_child(timer)
	#timer.timeout.connect(scene_switch)
	#print(magnet)
	#initial_yaw = atan2(-magnet.x, magnet.z) 
	

func _process(delta):
	var magnet: Vector3 = Input.get_magnetometer().rotated(-Vector3.FORWARD, rotation.z).rotated(Vector3.RIGHT, rotation.x)
	var gravity: Vector3 = Input.get_gravity()
	var roll_acc = atan2(-gravity.x, -gravity.y) 
	gravity = gravity.rotated(-Vector3.FORWARD, rotation.z)
	var pitch_acc = atan2(gravity.z, -gravity.y)
	var yaw_magnet = atan2(-magnet.x, magnet.z)
	var gyroscope: Vector3 = Input.get_gyroscope().rotated(-Vector3.FORWARD, roll)
	pitch = lerp_angle(pitch_acc, pitch + gyroscope.x * delta, k)
	yaw = lerp_angle(yaw_magnet, yaw + gyroscope.y * delta, k)
	roll = lerp_angle(roll_acc, roll + gyroscope.z * delta, k) 
	rotation = Vector3(pitch, yaw, roll)
	#var dot = transform.basis.z.dot(Vector3.FORWARD)
	#print(dot)
	if transform.basis.z.dot(Vector3.FORWARD) > 0.9:
		#timer.start()
		scene_switch()
		#await _scene_switch()
		
		
func scene_switch():
	await get_tree().create_timer(3.0).timeout
	Load.change_scene()
	
