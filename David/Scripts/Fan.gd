extends TextureRect

var stored_pos = Vector2.ZERO
var real_pos = Vector2.ZERO

var rotation_speed = 0.0

const DECREASEDSPEED = 0.5

const MAXDISTANCE = 250000
const MINDISTANCE = 20000

@onready var the_code = $"../Code"
@onready var return_button = $"../Return"
@onready var FanSound = $"../../FanSound"

@onready var Arrows = $"../Arrows"

func _ready():
	real_pos = position + pivot_offset
	return_button.pressed.connect(_return)
	$"../../ArrowAnim".play("AnimateArrow")
	_play_fan()
	while true:
		if rotation_speed > 0.0:
			rotation_speed -= DECREASEDSPEED
			if rotation_speed < 0.0:
				rotation_speed = 0.0
		await get_tree().create_timer(1.0).timeout

func _input(event):
	if event is InputEventScreenTouch:
		if !event.is_pressed() && get_global_mouse_position().y > stored_pos.y && real_pos.distance_squared_to(get_global_mouse_position()) < MAXDISTANCE && MINDISTANCE < stored_pos.distance_squared_to(get_global_mouse_position()):
			rotation_speed += DECREASEDSPEED
		else:
			stored_pos = get_global_mouse_position()

func _process(delta):
	rotation += rotation_speed * delta
	if rotation_speed > 20.0:
		the_code.visible = true
		return_button.visible = true
		rotation_speed = 20.0
		
func _play_fan():
	while true:
		if rotation_speed > 5:
			Arrows.visible = false
			FanSound.play()
			await get_tree().create_timer((1 / rotation_speed) * 5).timeout
		else:
			Arrows.visible = true
			await get_tree().process_frame
		
func _return():
	Load.change_scene()
