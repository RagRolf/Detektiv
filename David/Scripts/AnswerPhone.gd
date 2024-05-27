extends TouchScreenButton

var ifPressed = false

var start_position

var parent

var hasAnswered = false
@export var Candle : MeshInstance3D

@onready var humanSprite = $"../../../Dude"
@onready var below = $"../.."
@onready var PhoneSignal = $"../../../../PhoneSignal"
@onready var Voice = $"../../../../Voice"
@onready var aPanel = $"../../../Panel"

@onready var Wind = $"../../../../Wind"

const BORDER = 100.0

func _ready():
	Candle.process_mode = Node.PROCESS_MODE_DISABLED
	parent = get_parent()
	start_position = parent.position
	pressed.connect(pressed_func)
	while !hasAnswered:
		Input.vibrate_handheld(800)
		await get_tree().create_timer(1.0).timeout
	

func _process(_delta):
	if ifPressed && !hasAnswered:
		parent.global_position.x = get_global_mouse_position().x
		if parent.position.x > start_position.x:
			parent.position.x = start_position.x
		elif parent.position.x < BORDER:
			humanSprite.visible = false
			below.visible = false
			visible = false
			hasAnswered = true
			PhoneSignal.stop()
			await get_tree().create_timer(1.0).timeout
			Voice.play()
			await get_tree().create_timer(2.5).timeout
			aPanel.visible = false
			Wind.play()
			process_mode = Node.PROCESS_MODE_DISABLED
			Candle.process_mode = Node.PROCESS_MODE_INHERIT
			
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
