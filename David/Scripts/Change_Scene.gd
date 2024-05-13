extends Node2D

@onready var allButtons = [$Knife, $Log, $Candle]
@onready var animationPlayer = $Animation
#var scene1 = preload("res://David/David_Main.tscn")
#var scene2 = preload("res://David/Rotate_Object.tscn")
#var scene3 = preload("res://David/Candle.tscn")
var allScenes = ["res://David/David_Main.tscn", "res://David/Rotate_Object.tscn", "res://David/Candle.tscn"]

func _ready():
	for i in len(allButtons):
		allButtons[i].pressed.connect(_change_scene.bind(i))
	
func _change_scene(index : int):
	#print(str(index))
	if !index:
		#print("Hi")
		animationPlayer.play("knife")
		await get_tree().create_timer(1.5).timeout
	if index == 1:
		#print("Hi")
		animationPlayer.play("log")
		await get_tree().create_timer(1.5).timeout
	Load.change_scene((allScenes[index]))
	#get_tree().change_scene_to_file(allScenes[index])
