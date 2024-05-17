extends ColorRect

var buttons = []

const OFFSETSIDEWAYS = 57
const OFFSETUPDOWN = 98

var left_right = 0
var up_down = 0

@onready var codes = [$"../AllCodes/Code1", $"../AllCodes/Code2", $"../AllCodes/Code3"]

@onready var theCode = $"../../TheCode"

@onready var return_button = $"../../Return"
@onready var numbers = $"../AllCodes"


func _ready():
	return_button.pressed.connect(_return_to_main)
	var myParent = $"../../AllButtons"
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
	while true:
		await get_tree().create_timer(0.5).timeout
		is_on  = !is_on 
		color.a = is_on as float
	
func _number(integer : int):
	if codes[up_down].text[left_right] == str(integer):
		return
	codes[up_down].text[left_right] = str(integer)
	if left_right != 3:
		left_right += 1
		position.x += OFFSETSIDEWAYS
	elif up_down != 2:
		up_down += 1
		position.y += OFFSETUPDOWN
		left_right = 0
		position.x -= OFFSETSIDEWAYS * 3
	
func _right_point():
	if up_down > 0:
		position.y -= OFFSETUPDOWN
		if up_down:
			up_down -= 1
	
func _left_point():
	if up_down < 2:
		position.y += OFFSETUPDOWN
		if up_down != 2:
			up_down += 1
	
func _right_arrow():
	if left_right < 3:
		position.x += OFFSETSIDEWAYS
		if left_right != 3:
			left_right += 1
	
func _left_arrow():
	if left_right > 0:
		position.x -= OFFSETSIDEWAYS
		if left_right:
			left_right -= 1
	
func _erase_all():
	for i in len(codes):
		for j in codes[0].text.length():
			codes[i].text[j] = str(0)
	
func _return():
	for i in len(codes):
		if codes[i].text != Load.allPasswords[i]:
			return
	visible = false
	theCode.visible = true
	numbers.visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	
func _return_to_main():
	Load.change_scene()
