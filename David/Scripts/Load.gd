extends Control

#var loading_scene = preload("res://David/LoadingScen.tscn")
@onready var bar
var OnOff = true

#@onready var scene = "res://David/Main_Menu.tscn"

var progress = [0.0]

const SAVEPATH = "user://savegame.save"

var done_map = [false, false, false]

const allPasswords = ["9141", "1346", "1493"]

func _ready():
	if !OnOff:
		return
	const STARTSCENE = "res://David/Main_Menu.tscn"
	await get_tree().process_frame #Scene is null otherwise
	#var LoadingScene = "res://David/LoadingScen.tscn"
	get_tree().change_scene_to_file("res://David/LoadingScen.tscn")
	await get_tree().process_frame
	bar = get_node("/root/LoadingScene/ProgressBar")
	if !FileAccess.file_exists("user://savegame.save"):
		#print("Hi")
		get_tree()
		var prompt = ResourceLoader.load("res://David/PromptFirstTime.tscn")
		prompt = prompt.instantiate()
		get_tree().root.add_child(prompt)
		prompt.show()
		while true:
			await get_tree().process_frame
			if !prompt.visible:
				#print("Break")
				prompt.get_child(0).visible = false
				break
		var save_file = ConfigFile.new()
		save_file.save(SAVEPATH)
		var mic = AudioStreamPlayer.new()
		get_tree().get_current_scene().add_child(mic)
		mic.stream = AudioStreamMicrophone.new()
		mic.play()
		await get_tree().create_timer(2.0).timeout
		get_tree().quit()
	ResourceLoader.load_threaded_request(STARTSCENE, "", false, 1) #Multithreading works on PC, but breaks android
	var ifDone = false
	while true:
		var status = ResourceLoader.load_threaded_get_status(STARTSCENE, progress)
		match status:
			0, 2:
				set_process(false)
				return
			1:
				bar.value = progress[0]
				await get_tree().process_frame
			3:
				bar.value = 1.0
				#await get_tree().process_frame
				var _loaded_resource = ResourceLoader.load_threaded_get(STARTSCENE)
				ifDone = true
				get_tree().change_scene_to_packed(_loaded_resource)
		if !ifDone:
			await get_tree().process_frame
		


func change_scene(toScene = "res://David/Main_Menu.tscn"):
	#var loader = 
	#if ResourceLoader.exists(scene):
		#print("Hello there")
	await get_tree().process_frame #Scene is null otherwise
	#var LoadingScene = "res://David/LoadingScen.tscn"
	get_tree().change_scene_to_file("res://David/LoadingScen.tscn")
	await get_tree().process_frame
	bar = get_node("/root/LoadingScene/ProgressBar")
		#var power = AudioServer.get_bus_peak_volume_left_db(AudioServer.get_bus_index("Record"), 0)
	ResourceLoader.load_threaded_request(toScene, "", false, ResourceLoader.CACHE_MODE_REUSE) #Multithreading works on PC, but breaks android
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
				#await get_tree().process_frame
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
