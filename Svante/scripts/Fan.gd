extends AnimatedSprite2D

var speed = 5
var direction = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if speed > 0: speed -= 0.02
	else: speed = 0
	
	#print(speed)
	rotation += direction * speed * delta


func _on_down_spin_fan():
	speed = get_global_mouse_position().y / 100
