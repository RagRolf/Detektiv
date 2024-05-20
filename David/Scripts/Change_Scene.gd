extends Node2D

@onready var allButtons = [$Knife, $Log, $Phone, $Safe]
@onready var animationPlayer = $Animation
@onready var AllLabels = [$LabelScen/Code1, $LabelScen/Code2, $LabelScen/Code3]
@onready var magnifier = $See

var allScenes = ["res://David/KnifeScene.tscn", "res://David/Rotate_Object.tscn", "res://David/Phone.tscn", "res://David/Safe.tscn"]
var particles = []
var allAnims = ["knife", "log", "phone", "safe"]
var just_pressed = false
var isAllDone = true


func _ready():
	magnifier.pressed.connect(show_what_to_press)
	for i in len(allButtons):
		allButtons[i].pressed.connect(change_scene.bind(i))
		particles.append(allButtons[i].get_child(0))
	for i in len(Load.done_map):
		if Load.done_map[i]:
			AllLabels[i].text = Load.allPasswords[i]
			AllLabels[i].set("theme_override_colors/font_color", Color.RED)
	for i in len(Load.done_map):
		if !Load.done_map[i]:
			isAllDone = false
	if isAllDone:
		particles[3].emitting = true
	
	
func change_scene(index : int):
	if just_pressed:
		return
	just_pressed = true
	if index != 3:
		Load.done_map[index] = true
	if !isAllDone && index == 3:
		just_pressed = false #Must reset
		return
	for particle in particles:
		particle.visible = false
	animationPlayer.play(allAnims[index])
	await get_tree().create_timer(1.5).timeout
	Load.change_scene((allScenes[index]))
	
func show_what_to_press():
	for i in len(particles) - 1:
		particles[i].emitting = true
	if !isAllDone:
		return
	particles[3].emitting = true
