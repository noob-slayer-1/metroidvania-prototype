extends Node2D

@export var health: int = 0
@onready var enemy = get_owner()
@onready var collider = $"../CollisionShape2D"


func take_damage(damage: int):
	health -= damage
	health = clamp(health, 0, health)
	
	Events.enemy_hit_vfx.emit(enemy.global_position + (collider.shape.size.y * Vector2(0, -1) * 0.5))
	if health == 0:
		enemy.queue_free()
