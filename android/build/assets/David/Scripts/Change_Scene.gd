extends Node2D

@onready var allButtons = [$TouchScreenButton, $TouchScreenButton2, $TouchScreenButton3]
var allScenes = ["res://David/David_Main.tscn", "res://David/Candle.tscn", "res://David/Rotate_Object.tscn"]

func _ready():
	for i in len(allButtons):
		allButtons[i].pressed.connect(_change_scene.bind(allScenes[i], i))
	
func _change_scene(name : String, index : int):
	print(str(index))
	if !index:
		#print("Hi")
		$Knife.play("knife")
		await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(name)
