extends Node2D

var can_trigger = true


func _ready() -> void:
	Events.trap_hit.connect(_on_trap_hit)
	Events.player_resetted.connect(_on_player_resetted)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if can_trigger:
		body.receive_attack(AttackData.new())
		Events.trap_hit.emit()

func _on_trap_hit():
	can_trigger = false

func _on_player_resetted():
	can_trigger = true
