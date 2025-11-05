extends Area2D

var player
@onready var enemy = get_owner()


func _on_body_entered(body: Node2D) -> void:
	player = body
	enemy.player_detected = true
	set_deferred("monitoring", false)
