extends Node2D

@export var health: int = 0


func take_damage(damage: int):
	health -= damage
	health = clamp(health, 0, health)
	
	Events.player_health_changed.emit(health)
	$"../AnimationPlayer".play(&"hit")
	if health == 0:
		Events.player_health_depleted.emit()
