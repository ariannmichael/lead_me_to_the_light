extends Marker2D

enum Direction { RIGHT, LEFT }
@export var startDirection: Direction

@export var enemy_scene: PackedScene

var current_enemy_node = null
var spawn_on_next_click = false

func _ready():
	call_deferred("spawn_enemy")

func spawn_enemy():
	current_enemy_node = enemy_scene.instantiate()
	current_enemy_node.set_start_direction(Vector2.RIGHT if startDirection == Direction.RIGHT else Vector2.LEFT) 
	get_parent().add_child(current_enemy_node)
	current_enemy_node.global_position = global_position

func check_enemy_spawn():
	if(!is_instance_valid(current_enemy_node)):
		if(spawn_on_next_click):
			spawn_enemy()
			spawn_on_next_click = false
		else:
			spawn_on_next_click = true


func _on_timer_timeout():
	check_enemy_spawn()
