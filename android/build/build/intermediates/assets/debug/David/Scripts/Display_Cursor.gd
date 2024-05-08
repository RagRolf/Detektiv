extends Area2D

var amountOfFinishedPrints = 0

@onready var indexBuffer

func _ready():
	indexBuffer = AudioServer.get_bus_index("Record")

func _process(delta):
	position = get_global_mouse_position()
	var power = AudioServer.get_bus_peak_volume_left_db(indexBuffer, 0)
	power = clamp(db_to_linear(power), 0.0, 1.0)
	#print(str(power))
	$"../Control/ColorRect/HSlider".value = power


func _on_area_entered(area):
	area.get_child(0).modulate = area.get_child(0).modulate + Color(0, 0, 0, 0.1)
	if area.get_child(0).modulate.a >= 0.6 && !area.get_meta("Finished"):
		area.set_meta("Finished", true)
		amountOfFinishedPrints += 1
		if amountOfFinishedPrints == 3:
			print("Done")
