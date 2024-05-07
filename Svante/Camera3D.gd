extends Camera3D

var hovering = false
var zoom = false
#var currentPos
var targetPos

# Called when the node enters the scene tree for the first time.
func _ready():
	targetPos = $"../cameraDefault".position
	#currentPos = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug_test"):
		zoom = !zoom
		
		if zoom:
			targetPos = $"../item1Pos".position
			print("Zooming")
		else:
			targetPos = $"../cameraDefault".position
			print("Returning")
	
	# Lerp
	position = lerp(position, targetPos, 0.2)
	
	if hovering:
		if Input.is_action_just_pressed("Left_click"):
			print("Block Clicked")


func _on_area_3d_mouse_entered():
	print("Block Hovered")
	hovering = true


func _on_area_3d_mouse_exited():
	hovering = false
