extends Control

#var loading_scene = preload("res://David/LoadingScen.tscn")
@onready var bar
var OnOff = false
#@onready var scene = "res://David/Main_Menu.tscn"

var progress = [0.0]

func _ready():
	if OnOff:
		change_scene()

func change_scene(toScene = "res://David/Main_Menu.tscn"):
	#var loader = 
	#if ResourceLoader.exists(scene):
		#print("Hello there")
	await get_tree().process_frame #Scene is null otherwise
	var LoadingScene = "res://David/LoadingScen.tscn"
	get_tree().change_scene_to_file("res://David/LoadingScen.tscn")
	await get_tree().process_frame
	bar = get_node("/root/LoadingScene/ProgressBar")
	ResourceLoader.load_threaded_request(toScene, "", false) #Multithreading works on PC, but breaks android
	var ifDone = false
	while true:
		var status = ResourceLoader.load_threaded_get_status(toScene, progress)
		match status:
			0, 2:
				set_process(false)
				return
			1:
				bar.value = progress[0]
				await get_tree().process_frame
			3:
				bar.value = 1.0
				await get_tree().create_timer(0.1).timeout
				var _loaded_resource = ResourceLoader.load_threaded_get(toScene)
				ifDone = true
				get_tree().change_scene_to_packed(_loaded_resource)
		if !ifDone:
			await get_tree().process_frame
	
#func _process(delta):
	#
	#var status = ResourceLoader.load_threaded_get_status(scene, progress)
	#match status:
		#0, 2:
			#set_process(false)
			#return
		#1:
			#bar.value = progress[0]
			#await get_tree().process_frame
		#3:
			#bar.value = 1.0
			#var _loaded_resource = ResourceLoader.load_threaded_get(scene)
			#get_tree().change_scene_to_packed(_loaded_resource)
			#get_tree().get_root().call_deferred("add_child", scene)

#func load_scene(current_scene, next_scene):
	##var loading_scene_instance = loading_scene.instance()
	##get_tree().root.call_deferred("add_child", loading_scene_instance)
	#
	#var loader = ResourceLoader.load(next_scene)
	#if loader == null:
		#print("Error!")
		#return
		#
	#current_scene.queue_free()
	#
	#await get_tree().create_timer(0.5).timeout
	#
	#while true:
		#var error = loader.poll()
		#
		#if error == OK:
			#var progress_bar = loading_scene_instance.get_node("Progress_Bar")
			#progress_bar.value = float(loader.get_stage()) / loader.get_stage_count() * 100
			#
		#elif error == ERR_FILE_EOF:
			#var scene = loader.get_resource().instance()
			#get_tree().get_root().call_deferred("add_child", scene)
			#return
			#
		#else:
			#print("Failed loading")
			#return
