extends CanvasLayer

func _on_button_pressed():
	$"/root/LevelManager".increment_level()
