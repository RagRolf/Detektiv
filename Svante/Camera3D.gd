extends Camera3D

var follow_speed = 0.1
var targetPos 
var zoom = false
var focus = "Default"
var timer : Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	targetPos = $"../cameraDefault".position
	timer.one_shot = true
	timer.autostart = false
	timer.wait_time = 1.0
	timer.timeout.connect(changeScene)
	add_child(timer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Lerp
	position = lerp(position, targetPos, follow_speed)
	
	if targetPos != $"../cameraDefault".position:
		zoom = true
	else:
		zoom = false


# Zooms to Item 1
func _on_control_button_1_pressed():
	targetPos = $"../item1Pos".position
	focus = "Item_1"

# Zooms to Item 2
func _on_control_button_2_pressed():
	targetPos = $"../item2Pos".position
	focus = "Item_2"
	timer.start()

# Returns to default position
func _on_control_button_return():
	targetPos = $"../cameraDefault".position
	focus = "Default"

func changeScene():
	get_tree().change_scene_to_file("res://Svante/alt_scene.tscn")
