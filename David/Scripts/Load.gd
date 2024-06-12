extends Control

@onready var bar

var progress = [0.0]

const SAVEPATH = "user://savegame.save"

var done_map = [false, false, false, false]

const allPasswords = ["9141", "1346", "1493", "5201"]


func _ready():
	const STARTSCENE = "res://David/Main_Menu.tscn"
	await get_tree().process_frame
	#bar = get_node("/root/LoadingScene/ProgressBar")
	bar = get_node_or_null("/root/LoadingScene/ProgressBar")
	if !bar:
		return #playing current level
	if !FileAccess.file_exists("user://savegame.save"):
		var prompt = ResourceLoader.load("res://David/PromptFirstTime.tscn")
		prompt = prompt.instantiate()
		get_tree().root.add_child(prompt)
		var particleCached = load("res://David/FingerPrint.tscn") #For caching only, first time
		var finger_print = particleCached.instantiate()
		get_tree().root.add_child(finger_print)		
		finger_print.get_child(0).emitting = true
		var materialZoom = load("res://David/Models/Zoom.tres")
		var GPUZOOM = GPUParticles2D.new()
		GPUZOOM.process_material = materialZoom
		get_tree().root.add_child(GPUZOOM)
		GPUZOOM.emitting = true
		prompt.show()
		while true:
			await get_tree().process_frame
			if !prompt.visible:
				prompt.get_child(0).visible = false
				break
		var mic = AudioStreamPlayer.new()
		get_tree().root.add_child(mic)
		mic.stream = AudioStreamMicrophone.new()
		mic.play()
		mic.stream_paused = true
		var save_file = ConfigFile.new()
		save_file.save(SAVEPATH)
		await get_tree().create_timer(1.0).timeout
		get_tree().quit()
	ResourceLoader.load_threaded_request(STARTSCENE, "", false, ResourceLoader.CACHE_MODE_REUSE) #Multithreading works on PC, but breaks android
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
	await get_tree().process_frame #Scene is null otherwise
	get_tree().change_scene_to_file("res://David/LoadingScen.tscn")
	await get_tree().process_frame
	bar = get_node("/root/LoadingScene/ProgressBar")
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
				var _loaded_resource = ResourceLoader.load_threaded_get(toScene)
				ifDone = true
				get_tree().change_scene_to_packed(_loaded_resource)
		if !ifDone:
			await get_tree().process_frame
