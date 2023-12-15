extends Node2D

signal player_won
#
## Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("area_entered", on_area_entered)
	
func on_area_entered(_area2d: Area2D):
	player_won.emit()
