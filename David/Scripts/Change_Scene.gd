extends Node2D

@onready var allButtons = [$Knife, $Log, $Safe, $Phone]
@onready var animationPlayer = $Animation
#@onready var pic = $Pi
#var scene1 = preload("res://David/David_Main.tscn")
#var scene2 = preload("res://David/Rotate_Object.tscn")
#var scene3 = preload("res://David/Candle.tscn")

#@onready var allPlayers = [$KnifeP, $LogP, $PhoneP, $SafeP]
var allScenes = ["res://David/David_Main.tscn", "res://David/Rotate_Object.tscn", "res://David/Safe.tscn", "res://David/Phone.tscn"]
var allAnims = ["knife", "log", "safe", "phone"]

func _ready():
	for i in len(allButtons):
		allButtons[i].pressed.connect(_change_scene.bind(i))
	
func _change_scene(index : int):
	#print(str(index))
	animationPlayer.play(allAnims[index])
	#pic.visible = false
	#allPlayers[index].play()
	await get_tree().create_timer(1.5).timeout
	Load.change_scene((allScenes[index]))
	#get_tree().change_scene_to_file(allScenes[index])
