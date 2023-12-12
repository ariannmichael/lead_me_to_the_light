extends CharacterBody2D

signal died

enum State { NORMAL, DASHING }
@export_flags_2d_physics var dashHazardMask

const gravity = 1000
const max_horizontal_speed = 140
const max_dash_speed = 500
const min_dash_speed = 200
const horizontal_acceleration = 2000
const jump_speed = 500
const jump_termination_multiplier = 4
var has_double_jump = false
var has_dash = false
var current_state = State.NORMAL
var isStateNew = true

var defaultHazardMask = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$HazardArea.connect("area_entered", on_hazard_area_entered)
	defaultHazardMask = $HazardArea.collision_mask


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match current_state:
		State.NORMAL:
			process_normal(delta)
		State.DASHING:
			process_dash(delta)
	isStateNew = false

func change_state(newState):
	current_state = newState
	isStateNew = true

	
func process_normal(delta):
	if(isStateNew):
		$DashArea/CollisionShape2D.disabled = true
		$HazardArea.collision_mask = defaultHazardMask
		
	var move_vector = get_movement_vector()
	
	velocity.x += move_vector.x * horizontal_acceleration * delta
	if(move_vector.x == 0):
		velocity.x = lerp(0, int(velocity.x), pow(2, -50 * delta))
		
	velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
	
	if(move_vector.y < 0 and (is_on_floor() or !$CoyoteTimer.is_stopped() or has_double_jump)):
		velocity.y = move_vector.y * jump_speed
		if(!is_on_floor() and $CoyoteTimer.is_stopped()):
			has_double_jump = false
		$CoyoteTimer.stop()
		
	if(velocity.y < 0 and !Input.is_action_pressed("jump")):
		velocity.y += gravity * jump_termination_multiplier * delta
	else:
		velocity.y += gravity * delta
		
	velocity.x = move_vector.x * max_horizontal_speed
	velocity.y += gravity * delta
	
	var was_on_floor = is_on_floor()
	move_and_slide()
	
	if(was_on_floor and !is_on_floor()):
		$CoyoteTimer.start()
		
	if(is_on_floor()):
		has_double_jump = true
		has_dash = true
		
	if(has_dash and Input.is_action_just_pressed("dash")):
		call_deferred("change_state", State.DASHING)
		has_dash = false
	
	update_animation()

func process_dash(delta):
	if(isStateNew):
		$DashArea/CollisionShape2D.disabled = false
		$AnimatedSprite.play("jump")
		$HazardArea.collision_mask =  dashHazardMask
		
		var move_vector = get_movement_vector()
		var velocity_mod = 1
		if(move_vector.x != 0):
			velocity_mod = sign(move_vector.x)
		else:
			velocity_mod = -1 if $AnimatedSprite.flip_h else 1
			
		velocity = Vector2(max_dash_speed * velocity_mod, 0)

	move_and_slide()
	velocity.x = lerp(0, int(velocity.x), pow(2, -8 * delta))
	
	if(abs(velocity.x) < min_dash_speed):
		$DashArea/CollisionShape2D.disabled = true
		call_deferred("change_state", State.NORMAL)

func get_movement_vector():
	var move_vector = Vector2.ZERO
	move_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_vector.y = -1 if Input.is_action_just_pressed("jump") else 0
	
	return move_vector

func update_animation():
	var move_vector = get_movement_vector()
	
	if(!is_on_floor()):
		$AnimatedSprite.play("jump")
	elif(move_vector.x != 0):
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")
		
	if(move_vector.x != 0):
		$AnimatedSprite.flip_h = false if move_vector.x > 0 else true

func on_hazard_area_entered(_area2D):
	#died.emit()
	emit_signal("died")
