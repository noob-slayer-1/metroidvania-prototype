extends Node2D

@export var health: int = 0
@onready var player = get_owner()
@onready var collider = $"../CollisionShape2D"


func take_damage(damage: int):
	health -= damage
	health = clamp(health, 0, health)
	
	Events.player_health_changed.emit(health)
	Events.player_hit_vfx.emit(player.global_position + (collider.shape.size.y * Vector2(0, -1) * 0.5))
	$"../AnimationPlayer".play(&"hit")
	if health == 0:
		Events.player_health_depleted.emit()
