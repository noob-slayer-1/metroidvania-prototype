extends Node2D

@export var move_speed = 230.0
@onready var enemy = get_owner()


func move(direction):
	if not enemy.is_in_knockback:
		enemy.velocity.x = move_speed * direction.x

func apply_force(direction: Vector2, force: float):
	enemy.velocity = direction * force
