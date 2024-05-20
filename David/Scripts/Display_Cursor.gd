extends Area2D

var amountOfFinishedPrints = 0

@onready var indexBuffer

var sprites = []

var currentSprite = -1

#var isOnPensel = false

@onready var fill = $"../Area2D2/Fill"

var lastPos = Vector2(0.0, 0.0)
var difference = 0.0

@onready var stickTo = $StickTo

var blobMum

var isInsideKnife = false

var totalBlobsThisFill = 0

var totalBlobs = 0

#var once = false

@onready var AllSprites = $"../AllSprites"
@onready var Finger = $"../Fingers"

var polygons = []

@onready var prompt = $"../PromptBlew"

var power = 0.0

#var allSprites = []

var FingerPrint = preload("res://David/FingerPrint.tscn")

const MAXBLOBS = 15
const ScreamPower = -30.0
const BLOBSPERFILL = 3

var isDone = false

@onready var mic = $"../MicrophoneAudioStreamPlayer"

@onready var all_labels = [$"../AllSuspects/AllLabels/Rina", $"../AllSuspects/AllLabels/Ryan", $"../AllSuspects/AllLabels/Olga", $"../AllSuspects/AllLabels/Hassan", $"../AllSuspects/AllLabels/Stig", $"../AllSuspects/AllLabels/Nuka"]
@onready var all_buttons = [$"../AllSuspects/Rina/Rina", $"../AllSuspects/Ryan/Ryan", $"../AllSuspects/Olga/Olga", $"../AllSuspects/Hassan/Hassan", $"../AllSuspects/Stig/Stig", $"../AllSuspects/Nuka/Nuka"]

#var start_time

var click_once = false

@onready var all_suspects = $"../AllSuspects"

func _ready():
	var j = 0
	for button in all_buttons:
		button.pressed.connect(_selected.bind(j))
		j += 1
	blobMum = $"../BlobMum"
	polygons = $"../Knife/CollisionPolygon2D".polygon
	for i in len(polygons):
		polygons[i] += $"../Knife".position
	indexBuffer = AudioServer.get_bus_index("Record")
	var SpritesLevel = load("res://David/AllSpriteBlobs.tscn")
	SpritesLevel = SpritesLevel.instantiate()
	for i in SpritesLevel.get_child_count():
		sprites.push_back(SpritesLevel.get_child(i) as Sprite2D)

func _process(_delta):
	lastPos = position
	position = get_global_mouse_position()


func _on_area_entered(area):
	#print("Hi")
	if !area.is_in_group("Knife") && fill.visible:
		totalBlobsThisFill = BLOBSPERFILL
		stick_to_brush()
		if totalBlobs >= MAXBLOBS:
			fill.visible = false
	else:
		if blobMum.visible && !isInsideKnife:
			drop_splash()
	
func stick_to_brush():
	if blobMum.visible:
		return
	#isOnPensel = true
	blobMum.visible = true
	while blobMum.visible:
		#var Difference = position - lastPos
		blobMum.position = stickTo.global_position
		await get_tree().process_frame
		
func drop_splash():
	isInsideKnife = true
	while isInsideKnife && totalBlobsThisFill > 0:
		#print(str(Time.get_time_dict_from_system ()))
		#print("Inside loop highest: " + str(isInsideKnife))
		#print(str(totalBlobsThisFill))
		var differenceThisFrame = position.distance_squared_to(lastPos)
		if differenceThisFrame > 250: #cap to 250
			differenceThisFrame = 250
		difference += differenceThisFrame
		#print(str(difference))
		if difference > 4000.0 && Geometry2D.is_point_in_polygon(stickTo.global_position, polygons):
			#isInsideKnife = false
			#if difference > 500:
			var randomIndex = randi_range(0, 4)
			var thisSprite = sprites[randomIndex].duplicate()
			#allSprites.append(thisSprite)
			AllSprites.add_child(thisSprite)
			thisSprite.position = stickTo.global_position
			difference = 0.0
			totalBlobsThisFill -= 1
			totalBlobs += 1
			#print(str(totalBlobs))
			if !totalBlobsThisFill:
				blobMum.visible = false
				if !fill.visible:
					#once = true
					prompt.visible = true
					checkforblow()
					return
		await get_tree().process_frame

func checkforblow(): #Seems to work know, shall choose random sprite-blobs to put fingerprints on
	var SpriteChildren = AllSprites.get_child_count()
	var amount = randi_range(3, SpriteChildren)
	#var randomOffset = randi_range(0, 3)
	var allPossible = []
	for i in AllSprites.get_child_count():
		allPossible.append(i)
	while amount > 0:
			amount -= 1
			var random = randi_range(0, SpriteChildren - 1)
			var index = allPossible[random]
			var finger_print = FingerPrint.instantiate()
			finger_print.visible = false
			Finger.add_child(finger_print)
			finger_print.position = AllSprites.get_child(index).position
	await get_tree().create_timer(1.0).timeout
	while !isDone:
		if !mic.playing:
			await get_tree().create_timer(0.5).timeout #Need a small timer for it to work
			mic.play()
		power = AudioServer.get_bus_peak_volume_left_db(indexBuffer, 0)
		if power > ScreamPower: 
			prompt.visible = false
			for index in Finger.get_child_count():
				Finger.get_child(index).visible = true
				Finger.get_child(index).get_child(0).emitting = true
				#finger_print.get_child(0).enabled = true
				AllSprites.get_child(index).visible = false
				allPossible[index] = allPossible[amount]
			await get_tree().create_timer(2.0).timeout
			isDone = true
			all_suspects.visible = true
		if !isDone:
			await get_tree().process_frame
		
func exit_splash(area):
	if area.is_in_group("Knife"):
		isInsideKnife = false

func _selected(index : int):
	#print("He")
	if click_once:
		return
	click_once = true
	if index == 5:
		all_labels[index].modulate = Color.GREEN
		await get_tree().create_timer(2.0).timeout
		Load.change_scene()
	else:
		all_labels[index].modulate = Color.RED
		await get_tree().create_timer(2.0).timeout
		Load.change_scene("res://David/KnifeScene.tscn")
