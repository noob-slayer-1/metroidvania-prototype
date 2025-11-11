extends Node2D

const JUMP_TIME_PEAK = 0.5
const JUMP_TIME_DOWN = 0.4

@export var jump_height = 128.0
@export var move_speed = 300.0

var last_facing_direction = Vector2.RIGHT
var double_jump = false
var prev_on_floor = false

@onready var player: CharacterBody2D = get_owner()
@onready var ct_timer = $CTTimer
@onready var jump_velocity = ((2 * jump_height) / JUMP_TIME_PEAK) * -1.0
@onready var jump_gravity = (2.0 * jump_height) / pow(JUMP_TIME_PEAK, 2)
@onready var fall_gravity = (2.0 * jump_height) / pow(JUMP_TIME_DOWN, 2)
@onready var gravity = $"../Gravity"


func update() -> void:
	gravity.set_gravity(get_gravity())
	
	if not player.is_in_knockback:
		var input_velocity = Vector2(Input.get_axis(&"move_left", &"move_right"), 0)
		player.velocity.x = move_speed * input_velocity.x
		if input_velocity:
			last_facing_direction = input_velocity.normalized()
		
		handle_jump()
		
		if player.velocity.x > 0:
			$"../Sprite2D".flip_h = false
		elif player.velocity.x < 0:
			$"../Sprite2D".flip_h = true
		
		if player.is_on_floor():
			double_jump = true
			if player.velocity.x:
				$"../AnimationPlayer".play(&"moving")
			else :
				$"../AnimationPlayer".play(&"idle")
		else:
			$"../AnimationPlayer".play(&"jump")

func apply_force(direction: Vector2, force: float):
	player.velocity = direction * force

func handle_jump():
	if prev_on_floor and not player.is_on_floor():
		ct_timer.start()
	
	if Input.is_action_just_pressed(&"jump"):
		if player.is_on_floor():
			apply_force(Vector2.UP, -jump_velocity)
		elif not ct_timer.is_stopped():
			ct_timer.stop()
			apply_force(Vector2.UP, -jump_velocity)
		elif double_jump:
			double_jump = false
			apply_force(Vector2.UP, -jump_velocity)
			
			var effect = FXSpawner.spawn_effect("player_double_jump")
			add_child(effect)
	elif Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y = 0
	prev_on_floor = player.is_on_floor()

func get_gravity():
	return jump_gravity if player.velocity.y < 0.0 else fall_gravity
