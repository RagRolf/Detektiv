extends Node2D

@onready var allButtons = [$Knife, $Log, $Phone, $Safe]
@onready var animationPlayer = $Animation
@onready var AllLabels = [$LabelScen/Code1, $LabelScen/Code2, $LabelScen/Code3]
#@onready var pic = $Pi

#@onready var allPlayers = [$KnifeP, $LogP, $PhoneP, $SafeP]
var allScenes = ["res://David/KnifeScene.tscn", "res://David/Rotate_Object.tscn", "res://David/Phone.tscn", "res://David/Safe.tscn"]
var allAnims = ["knife", "log", "phone", "safe"]
var just_pressed = false


func _ready():
	for i in len(allButtons):
		allButtons[i].pressed.connect(change_scene.bind(i))
	for i in len(Load.done_map):
		if Load.done_map[i]:
			AllLabels[i].text = Load.allPasswords[i]
	
	
func change_scene(index : int):
	
	if just_pressed:
		return
	just_pressed = true
	if index != 3:
		Load.done_map[index] = true
	var isAllDone = true
	for i in len(Load.done_map):
		if !Load.done_map[i]:
			isAllDone = false
	if !isAllDone && index == 3:
		just_pressed = false #Must reset
		return
	#print(str(index))
	animationPlayer.play(allAnims[index])
	#pic.visible = false
	#allPlayers[index].play()
	await get_tree().create_timer(1.5).timeout
	Load.change_scene((allScenes[index]))
	#get_tree().change_scene_to_file(allScenes[index])
