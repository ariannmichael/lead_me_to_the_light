extends Node

var playerScene = preload("res://player/player.tscn")
var spawn_position = Vector2.ZERO
var current_player_node: CharacterBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_position = $Player.global_position
	register_player($Player)

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
