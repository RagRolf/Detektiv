extends Camera3D

var follow_speed = 0.1
var targetPos 
var zoom = false
var focus = "Default"

# Called when the node enters the scene tree for the first time.
func _ready():
	targetPos = $"../cameraDefault".position


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

# Returns to default position
func _on_control_button_return():
	targetPos = $"../cameraDefault".position
	focus = "Default"
