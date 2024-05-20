extends MeshInstance3D

var pitch: float = 0.0
var roll: float = 0.0
#var yaw: float = 0.0
var adjustedPitch : float = 0.0

const SPEED = 0.2

const RSPEED = 0.02
const offset = PI/4

var k : float = 0.98

const COMPLETELYCOVERING = -0.079

#@onready var touchbutton = $"../Return"

@export var InvisibleBox : CSGBox3D
@export var Virke : MeshInstance3D
var Candle
@onready var return_button = $"../Return"

func _ready():
	#DisplayServer.size
	#DisplayServer.window_set_size(Vector2i(1080, 1920))
	#get_tree().root
	#DisplayServer.aspect = DisplayServer.keep_width
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_PORTRAIT)
	Candle = get_child(0).process_material as ParticleProcessMaterial
	return_button.pressed.connect(_main_menu)

func _process(delta):
	#var magnet: Vector3 = Input.get_magnetometer().rotated(-Vector3.FORWARD, rotation.z).rotated(Vector3.RIGHT, rotation.x)
	var gravity: Vector3 = Input.get_gravity()
	var roll_acc = atan2(-gravity.x, -gravity.y) 
	#gravity = gravity.rotated(-Vector3.FORWARD, rotation.z)
	var pitch_acc = atan2(gravity.z, -gravity.y)
	#var yaw_magnet = atan2(-magnet.x, magnet.z)
	var gyroscope: Vector3 = Input.get_gyroscope().rotated(-Vector3.FORWARD, roll)
	pitch = lerp_angle(pitch_acc, pitch + gyroscope.x * delta, k)
	#yaw = lerp_angle(yaw_magnet, yaw + gyroscope.y * delta, k)
	roll = lerp_angle(roll_acc, roll + gyroscope.z * delta, k) 
	adjustedPitch = pitch + offset #Half a radian offset
	adjustedPitch = clamp(adjustedPitch, -0.75, 0.75) #0.75f is max rotation, halfway to total up or down from middle
	roll = clamp(roll, -0.75, 0.75) #0.75f is max rotation, halfway to total up or down from middle
	#yaw = clamp(yaw, -0.75, 0.75) #0.75f is max rotation, halfway to total up or down from middle
	rotation += Vector3(-adjustedPitch, roll, 0.0) * RSPEED
	#var dot = transform.basis.z.dot(Vector3.FORWARD)
	#print(str(transform.basis.y.dot(Vector3.UP)))
	#print(str(global_basis.z))
	Candle.gravity = 0.1 * global_basis.y
	if !Virke.visible: #IsDone
		return
	if transform.basis.y.dot(Vector3.DOWN) > 0.9:
		InvisibleBox.position.y -= SPEED * delta
		Virke.position.y -= SPEED * delta
		if position.y > -0.363: #Not too far down
			position.y -= SPEED * delta
	if InvisibleBox.position.y <= COMPLETELYCOVERING:
		return_button.visible = true
		Virke.visible = false
		
func _main_menu():
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_LANDSCAPE)
	Load.change_scene()
