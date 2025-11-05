extends Node2D

@export var health: int = 0
@onready var enemy = get_owner()


func take_damage(damage: int):
	health -= damage
	health = clamp(health, 0, health)
	
	if health == 0:
		enemy.queue_free()
