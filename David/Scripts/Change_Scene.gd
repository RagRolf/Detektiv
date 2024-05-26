extends Node2D

@onready var allButtons = [$Knife, $Log, $Phone, $Lamp, $Safe]
@onready var animationPlayer = $Animation
@onready var AllLabels = [$CanvasLayer/LabelScen/Code1, $CanvasLayer/LabelScen/Code2, $CanvasLayer/LabelScen/Code3, $CanvasLayer/LabelScen/Code4]
@onready var magnifier = $CanvasLayer/Glas/See
@onready var start_sound = $StartSound
@onready var zoom_sound = $ZoomSound

var allScenes = ["res://David/KnifeScene.tscn", "res://David/Rotate_Object.tscn", "res://David/Phone.tscn", "res://David/Snurren.tscn", "res://David/Safe.tscn"]
var particles = []
var allAnims = ["knife", "log", "phone", "fan", "safe"]
var just_pressed = false
var isAllDone = true


func _ready():
	start_sound.finished.connect(_on_start_sound_finished)
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
		particles[4].emitting = true
	
	
func change_scene(index : int):
	if just_pressed:
		return
	just_pressed = true
	if index != 4:
		Load.done_map[index] = true
	if !isAllDone && index == 4:
		just_pressed = false #Must reset
		return
	for particle in particles:
		particle.visible = false
	animationPlayer.play(allAnims[index])
	await get_tree().create_timer(1.5).timeout
	Load.change_scene((allScenes[index]))
	
func show_what_to_press():
	if zoom_sound.playing:
		return
	zoom_sound.play()
	for i in len(particles) - 1:
		particles[i].emitting = true
	if !isAllDone:
		return
	particles[4].emitting = true

func _on_start_sound_finished():
	await get_tree().create_timer(1.78).timeout
	start_sound.play()
