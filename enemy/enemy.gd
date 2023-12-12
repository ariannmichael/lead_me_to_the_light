extends CharacterBody2D

enum Direction { RIGHT, LEFT }
@export var startDirection: Direction

var max_speed = 100
var direction = Vector2.ZERO
var gravity = 15000

func _ready():
	direction = Vector2.RIGHT if startDirection == Direction.RIGHT else Vector2.LEFT
	$GoalDetector.connect("area_entered", on_goal_entered)
	$HitboxArea.connect("area_entered", on_hitbox_entered)

func _process(delta):
	velocity.x = (direction * max_speed).x
	velocity.y = gravity * delta
	move_and_slide()
	
	if(is_on_wall()):
		direction *= -1
	
	$AnimatedSprite2D.flip_h = true if direction.x > 0 else false

func on_goal_entered(_area2d):
	direction *= -1
	
func on_hitbox_entered(_area2d):
	queue_free()
