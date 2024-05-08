extends OptionButton

var devices: Array = []
# Called when the node enters the scene tree for the first time.

var indexBuffer
func _ready():
	indexBuffer = AudioServer.get_bus_index("Record")
	devices = AudioServer.get_input_device_list()
	
	for i in devices.size():
		var device = devices[i]
		add_item(device)
		if device == AudioServer.input_device:
			select(i)
			
	item_selected.connect(_on_item_selected)

func _on_item_selected(index: int) -> void:
	AudioServer.set_input_device(devices[index])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var power = AudioServer.get_bus_peak_volume_left_db(indexBuffer, 0)
	power = clamp(db_to_linear(power), 0.0, 1.0)
	#print(str(power))
	$"../Control/ColorRect/HSlider".value = power
