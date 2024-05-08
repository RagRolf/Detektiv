extends Control

signal button1Pressed
signal buttonReturn

func _on_touch_screen_button_pressed():
	button1Pressed.emit()
	print("Touched")


func _on_return_pressed():
	buttonReturn.emit()
	print("Returning")

func _process(delta):
	if $"../../Camera3D".zoom == true:
		$Return.show()
	else:
		$Return.hide()
