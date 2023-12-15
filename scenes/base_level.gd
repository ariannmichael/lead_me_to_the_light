extends Node
class_name BaseLevel

signal coin_total_changed

var playerScene = preload("res://player/player.tscn")
var level_complete_scene = preload("res://scenes/level_complete.tscn")
var spawn_position = Vector2.ZERO
var current_player_node: CharacterBody2D = null
var total_coins = 0
var collected_coins = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_position = $Player.global_position
	register_player($Player)
	total_coins_changed(get_tree().get_nodes_in_group("coin").size())
	#$Flag.connect("player_won", on_player_won)
	
func coin_collected():
	collected_coins += 1 
	emit_signal("coin_total_changed", total_coins, collected_coins)
	
func total_coins_changed(newTotal):
	total_coins = newTotal
	emit_signal("coin_total_changed", total_coins, collected_coins)

func register_player(player):
	current_player_node = player
	current_player_node.connect("died", on_player_died, CONNECT_DEFERRED)

func create_player():
	var player_instance = playerScene.instantiate()
	add_sibling(player_instance)
	player_instance.global_position = spawn_position
	register_player(player_instance)
	
func on_player_died():
	current_player_node.queue_free()
	create_player()
	
func on_player_won():
	current_player_node.queue_free()
	var level_complete = level_complete_scene.instantiate()
	add_child(level_complete)
