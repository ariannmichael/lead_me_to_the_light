extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	var base_levels = get_tree().get_nodes_in_group("base_level")
	if base_levels.size() > 0:
		base_levels[0].connect("coin_total_changed", update_coin_count)


func update_coin_count(total_coins, collected_coins):
	$MarginContainer/HBoxContainer/Label.text = str(collected_coins, "/", total_coins)
	
