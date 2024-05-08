extends Control

signal button1Pressed
signal button2Pressed
signal buttonReturn

func _on_touch_screen_button_pressed():
	button1Pressed.emit()
	print("Touched First Item")


func _on_return_pressed():
	buttonReturn.emit()
	print("Returning")

func _process(delta):
	if $"../../Camera3D".zoom == true:
		$Return.show()
	else:
		$Return.hide()
	
	if $"../../Camera3D".focus != "Default":
		if $"../../Camera3D".focus == "Item_1":
			$Zoom2.hide()
		elif $"../../Camera3D".focus == "Item_2":
			$Zoom.hide()
	else:
		$Zoom2.show()
		$Zoom.show()


func _on_zoom_2_pressed():
	button2Pressed.emit()
	print("Touched Second Item")
