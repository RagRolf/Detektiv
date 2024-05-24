extends Label

var toggleClue = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match toggleClue:
		true:
			show()
		false:
			hide()


func _on_fan_clue_reveal():
	toggleClue = !toggleClue
