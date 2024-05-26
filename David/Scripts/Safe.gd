extends ColorRect

var buttons = []

const OFFSETSIDEWAYS = 62
const OFFSETUPDOWN = 99

var left_right = 0
var up_down = 0

@onready var codes = [$"../AllCodes/Code1", $"../AllCodes/Code2", $"../AllCodes/Code3",  $"../AllCodes/Code4"]

@onready var codesToShow = [$"../../LabelScen/Code1", $"../../LabelScen/Code2", $"../../LabelScen/Code3", $"../../LabelScen/Code4"]

@onready var theCode = $"../../TheCode"

@onready var return_button = $"../../Return2/Return"
@onready var numbers = $"../AllCodes"
@onready var button_press = $"../../ButtonPress"

@onready var Start = $"../../Start"
@onready var EndSong = $"../../EndPlay"

func _ready():
	EndSong.finished.connect(_on_start_sound_finished)
	return_button.pressed.connect(_return_to_main)
	var myParent = $"../../AllButtons"
	for k in len(codesToShow):
		codesToShow[k].text = Load.allPasswords[k]
	for i in myParent.get_child_count():
		buttons.append(myParent.get_child(i))
		if i < 10:
			buttons[i].pressed.connect(_number.bind(i))
	buttons[10].pressed.connect(_return)
	buttons[11].pressed.connect(_erase_all)
	buttons[12].pressed.connect(_left_arrow)
	buttons[13].pressed.connect(_right_arrow)
	buttons[14].pressed.connect(_right_point)
	buttons[15].pressed.connect(_left_point)
	var is_on  = true
	change_pitch()
	while true:
		await get_tree().create_timer(0.5).timeout
		is_on  = !is_on 
		color.a = is_on as float
		
func change_pitch():
	while !theCode.visible:
		Start.pitch_scale = randf_range(0.75, 1.0)
		await get_tree().create_timer(randf_range(5.0, 7.0)).timeout
	
func _number(integer : int):
	button_press.play()
	if codes[up_down].text[left_right] == str(integer):
		return
	codes[up_down].text[left_right] = str(integer)
	if left_right != 3:
		left_right += 1
		position.x += OFFSETSIDEWAYS
	elif up_down != 3:
		up_down += 1
		position.y += OFFSETUPDOWN
		left_right = 0
		position.x -= OFFSETSIDEWAYS * 3
	
func _left_point():
	button_press.play()
	if up_down > 0:
		position.y -= OFFSETUPDOWN
		if up_down:
			up_down -= 1
	
func _right_point():
	button_press.play()
	if up_down < 3:
		position.y += OFFSETUPDOWN
		if up_down != 3:
			up_down += 1
	
func _right_arrow():
	button_press.play()
	if left_right < 3:
		position.x += OFFSETSIDEWAYS
		if left_right != 3:
			left_right += 1
	
func _left_arrow():
	button_press.play()
	if left_right > 0:
		position.x -= OFFSETSIDEWAYS
		if left_right:
			left_right -= 1
	
func _erase_all():
	button_press.play()
	for i in len(codes):
		for j in codes[0].text.length():
			codes[i].text[j] = str(0)
	
func _return():
	button_press.play()
	for i in len(codes):
		if codes[i].text != Load.allPasswords[i]:
			return
	if theCode.visible:
		return
	visible = false
	theCode.visible = true
	numbers.visible = false
	Start.stop()
	EndSong.play()
	process_mode = Node.PROCESS_MODE_DISABLED
	
func _return_to_main():
	Load.change_scene()
	
func _on_start_sound_finished():
	await get_tree().create_timer(1.78).timeout
	EndSong.play()
