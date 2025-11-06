extends Node2D

@export var jump_force: float = 350.0
@export var air_control: float = 10.0
var last_facing_direction = Vector2.RIGHT
@onready var player: CharacterBody2D = get_owner()


func move() -> void:
	if not player.is_in_knockback:
		var input_velocity = Vector2(Input.get_axis(&"move_left", &"move_right"), 0)
		player.velocity.x = player.MOVE_SPEED * input_velocity.x
		if input_velocity:
			last_facing_direction = input_velocity.normalized()
		if Input.is_action_just_pressed(&"jump"):
			if input_velocity:
				apply_force(Vector2.UP + (input_velocity * 0.8), jump_force)
			else:
				apply_force(Vector2.UP, jump_force)
		
		if player.velocity.x > 0:
			$"../Sprite2D".flip_h = false
		elif player.velocity.x < 0:
			$"../Sprite2D".flip_h = true
		
		if player.is_on_floor() and player.velocity.x:
			$"../AnimationPlayer".play(&"moving")
		elif not player.is_on_floor():
			$"../AnimationPlayer".play(&"jump")
		else :
			$"../AnimationPlayer".play(&"idle")

func apply_force(direction: Vector2, force: float):
	player.velocity = direction * force
