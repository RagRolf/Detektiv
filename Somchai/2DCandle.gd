extends Node2D

var child_sprite
var parent_sprite

func _ready():
	child_sprite = get_node("Sprite2D/Pivot/Light")
	if child_sprite != null:
		child_sprite.play()  # Play the animation
	parent_sprite = get_node("Sprite2D/")
		
func _process(delta):
	if not child_sprite:
		return

	# Get parent's rotation
	var parent_rotation = parent_sprite.rotation

	# Set child sprite's rotation to face up relative to parent
	child_sprite.rotation = parent_rotation + PI / 2  # PI/2 radians is 90 degrees

func _draw():
	# Optional: Draw a gizmo to visualize the child sprite's position'
	draw_line(Vector2.ZERO, child_sprite.get_position(), Color.LIGHT_BLUE, 2)
