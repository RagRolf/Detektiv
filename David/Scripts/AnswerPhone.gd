extends TouchScreenButton

var ifPressed = false

var start_position

var parent

var hasAnswered = false

@onready var humanSprite = $"../../Dude"
@onready var below = $"../../below"
@onready var PhoneSignal = $"../../PhoneSignal"
@onready var Voice = $"../../Voice"

const BORDER = 274.0

func _ready():
	parent = get_parent()
	start_position = parent.position
	pressed.connect(pressed_func)
	while(!hasAnswered):
		Input.vibrate_handheld(800)
		await get_tree().create_timer(1.0).timeout

func _process(_delta):
	#print(str(randi_range(0,4)))
	if ifPressed && !hasAnswered:
		parent.position.x = get_global_mouse_position().x
		if get_global_mouse_position().x > start_position.x:
			parent.position.x = start_position.x
		elif get_global_mouse_position().x < BORDER:
			humanSprite.visible = false
			below.visible = false
			visible = false
			hasAnswered = true
			PhoneSignal.stop()
			await get_tree().create_timer(1.0).timeout
			Voice.play()
			await get_tree().create_timer(5.0).timeout
			Load.change_scene()
			
			
		
func _input(event):
	if event is InputEventScreenTouch:
		if !event.is_pressed():
			parent.position = start_position
			ifPressed = false
	
func pressed_func():
	ifPressed = true


func on_answer_pressed():
	if !hasAnswered:
		return
