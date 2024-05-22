extends CollisionShape2D

var touched = false
var swiping = false
var inZone = false
signal spinFan
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inZone and touched:
		swiping = true
	
	if (swiping) && ((!touched) or (!inZone)):
		print("Swipe emitted!")
		spinFan.emit()
		swiping = false
		touched = false


func _on_touch_screen_button_pressed():
	touched = true
	print("Touched button")


func _on_touch_screen_button_released():
	touched = false
	print("Released button")


func _on_point_location_area_entered(area):
	inZone = true
	print("Entered zone")


func _on_point_location_area_exited(area):
	inZone = false
	print("Exited zone")
