extends Node2D

@export_range(10, 300) var lamp_x

signal start_healing
signal stop_healing

func _process(_delta):
	var transform_values = $Area2D/CollisionShape2D.get_shape()
	var oldScale = transform_values.extents
	$Area2D/CollisionShape2D.shape.extents = Vector2(lamp_x, oldScale.y)

func _on_area_2d_area_entered(_area):
	emit_signal("start_healing")

func _on_area_2d_area_exited(_area):
	emit_signal("stop_healing")
