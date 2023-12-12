extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("area_entered", on_area_entered)

func on_area_entered(_area: Area2D):
	$AnimationPlayer.play("pickup")
	call_deferred("disable_pickup")

func disable_pickup():
	$Area2D/CollisionShape2D.disabled = true
