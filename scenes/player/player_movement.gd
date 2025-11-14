extends Node2D

const JUMP_TIME_PEAK = 0.5
const JUMP_TIME_DOWN = 0.4

@export var jump_height = 128.0
@export var move_speed = 300.0

var last_facing_direction = Vector2.RIGHT
var double_jump = false
var prev_on_floor = false
var can_controlled = true

@onready var player: CharacterBody2D = get_owner()
@onready var ct_timer = $CTTimer
@onready var jump_velocity = ((2 * jump_height) / JUMP_TIME_PEAK) * -1.0
@onready var jump_gravity = (2.0 * jump_height) / pow(JUMP_TIME_PEAK, 2)
@onready var fall_gravity = (2.0 * jump_height) / pow(JUMP_TIME_DOWN, 2)


func _ready() -> void:
	Events.trap_hit.connect(_on_trap_hit)
	Events.player_resetted.connect(_on_player_resetted)
	Events.player_health_depleted.connect(_on_player_health_depleted)

func apply_force(direction: Vector2, force: float):
	player.velocity = direction * force

func reset():
	player.velocity = Vector2.ZERO
	can_controlled = true

func do_horizontal():
	var input_velocity = Vector2(Input.get_axis(&"move_left", &"move_right"), 0)
	player.velocity.x = move_speed * input_velocity.x
	if input_velocity:
		last_facing_direction = input_velocity.normalized()
	
	_flip_sprite()

func do_jump():
	apply_force(Vector2.UP, -jump_velocity)
	ct_timer.stop()

func can_jump():
	if player.is_on_floor():
		return true
	elif not ct_timer.is_stopped():
		return true 
	return false

func can_double_jump():
	if not can_jump() and double_jump:
		return true
	return false

func update_jump():
	if prev_on_floor and not player.is_on_floor():
		if ct_timer.is_stopped():
			ct_timer.start()
	
	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y = 0
	
	prev_on_floor = player.is_on_floor()

func do_double_jump():
	double_jump = false
	
	apply_force(Vector2.UP, -jump_velocity)
	var effect = FXSpawner.spawn_effect("player_double_jump")
	add_child(effect)

func _flip_sprite():
	if player.velocity.x > 0:
		$"../Sprite2D".flip_h = false
	elif player.velocity.x < 0:
		$"../Sprite2D".flip_h = true

func _on_trap_hit():
	can_controlled = false

func _on_player_resetted():
	can_controlled = true

func _on_player_health_depleted():
	can_controlled = false
