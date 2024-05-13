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
const ScreamPower = -100.0
const BLOBSPERFILL = 3

#var start_time

func _ready():
	#start_time = Time.get_time_dict_from_system ()
	blobMum = $"../BlobMum"
	polygons = $"../Knife/CollisionPolygon2D".polygon
	for i in len(polygons):
		polygons[i] += $"../Knife".position
	indexBuffer = AudioServer.get_bus_index("Record")
	var SpritesLevel = load("res://David/AllSpriteBlobs.tscn")
	SpritesLevel = SpritesLevel.instantiate()
	for i in SpritesLevel.get_child_count():
		sprites.push_back(SpritesLevel.get_child(i) as Sprite2D)
		#sprites[i].modulate = sprites[i].modulate + Color(0, 0, randf_range(0, 0.244))
		#sprites[i].visible = true
		#sprites[i].queue_free()

func _process(_delta):
	#print(str(randi_range(0,4)))
	lastPos = position
	position = get_global_mouse_position()
	#power = clamp(db_to_linear(AudioServer.get_bus_peak_volume_left_db(indexBuffer, 0)), 0.0, 1.0)
	power = AudioServer.get_bus_peak_volume_left_db(indexBuffer, 0)
	#print("Inside Update: " + str(isInsideKnife))
	#print("Inside Update: " + str(totalBlobsThisFill))
	#print(str(power))
	#$"../Control/ColorRect/HSlider".value = power


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
		#print("Inside loop lowest: " + str(isInsideKnife))
		#print(str(totalBlobsThisFill))
		await get_tree().process_frame

func checkforblow(): #Seems to work know, shall choose random sprite-blobs to put fingerprints on
	while true:
		#print(str(ScreamPower))
		if power > ScreamPower: 
			prompt.visible = false
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
				Finger.add_child(finger_print)
				finger_print.position = AllSprites.get_child(index).position
				AllSprites.get_child(index).visible = false
				allPossible[index] = allPossible[amount]
				finger_print.modulate = Color(randf_range(0.0,1.0),randf_range(0.0,1.0),randf_range(0.0,1.0))
			return
		await get_tree().process_frame
		
func exit_splash(area):
	#print("Exited: " + str(isInsideKnife))
	#print(str(totalBlobsThisFill))
	if area.is_in_group("Knife"):
		isInsideKnife = false
		
		#if difference > 2000:
			#difference -= randi_range(20, 50) #decrease a bit
		
		


#func _on_knife_mouse_exited():
	##if area.is_in_group("Knife"):
	#isInsideKnife = false
	#if difference > 2000:
		#difference -= randi_range(10, 20) #decrease a bit

#
#func _on_knife_mouse_entered():
	#if blobMum.visible:
		#await drop_splash()
