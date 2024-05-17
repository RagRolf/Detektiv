extends Node3D

var pitch: float = 0.0
var roll: float = 0.0
var adjustedPitch = 0.0
#var yaw: float = 0.0
const offset = PI/4

#var initial_yaw : float = 0.0

const k : float = 0.98

const RSPEED = 0.01

@onready var touchbutton = $"../Return"

#@onready var MainScene = load("res://David/Main_Menu.tscn")

#var once = false

#var timer

func _ready():
	touchbutton.pressed.connect(scene_switch)
	#await get_tree().process_frame
	#var magnet: Vector3 = Input.get_magnetometer()
	#print(magnet)
	#initial_yaw = atan2(-magnet.x, magnet.z) 
	

func _process(delta):
	#var magnet: Vector3 = Input.get_magnetometer().rotated(-Vector3.FORWARD, rotation.z).rotated(Vector3.RIGHT, rotation.x)
	var gravity: Vector3 = Input.get_gravity()
	var roll_acc = atan2(-gravity.x, -gravity.y) 
	var pitch_acc = atan2(gravity.z, -gravity.y)
	#var yaw_magnet = atan2(-magnet.x, magnet.z)
	var gyroscope: Vector3 = Input.get_gyroscope().rotated(-Vector3.FORWARD, roll)
	pitch = lerp_angle(pitch_acc, pitch + gyroscope.x * delta, k)
	#yaw = lerp_angle(yaw_magnet, yaw + gyroscope.y * delta, k)
	roll = lerp_angle(roll_acc, roll + gyroscope.z * delta, k) 
	adjustedPitch = pitch + offset
	adjustedPitch = clamp(adjustedPitch, -0.75, 0.75)
	roll = clamp(roll, -1.0, 1.0) * 0.75
	rotation += Vector3(adjustedPitch, roll, 0.0) * RSPEED
	#var dot = transform.basis.z.dot(Vector3.FORWARD)
	#print(dot)
	if transform.basis.z.dot(Vector3.FORWARD) > 0.9:
		#timer.start()
		#scene_switch()
		touchbutton.visible = true
		#await _scene_switch()
		
		
func scene_switch():
	#await get_tree().create_timer(3.0).timeout
	Load.change_scene()
	
