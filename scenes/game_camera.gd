extends Camera2D

@export_color_no_alpha var backgroundColor

var target_position = Vector2.ZERO

func _ready():
	RenderingServer.set_default_clear_color(backgroundColor)
	make_current()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	acquire_target()
	global_position = lerp(target_position, global_position, pow(2, -25 * delta))
	#global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20))
	
	
func acquire_target():
	var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	target_position = player.global_position
