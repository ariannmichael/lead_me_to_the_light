extends Node2D

enum Direction { RIGHT, LEFT }
@export var startDirection: Direction

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.flip_h = true if startDirection == Direction.RIGHT else false
	$Area2D.connect("area_entered", on_area_entered)

func on_area_entered(_area: Area2D):
	$AnimationPlayer.play("pickup")
	call_deferred("disable_pickup")
	
	var base_level: BaseLevel = get_tree().get_first_node_in_group("base_level")
	if base_level == null:
		return
	base_level.coin_collected()

func disable_pickup():
	$Area2D/CollisionShape2D.disabled = true
