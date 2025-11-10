extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysModule.gd"

var player
var reset_pos: Vector2
var do_reset = true
var transition_anim_player: AnimationPlayer

func _initialize():
	player = game.player
	assert(player)
	transition_anim_player = game.get_transition_anim_player()
	game.room_loaded.connect(_on_room_loaded)
	Events.trap_hit.connect(_on_trap_hit)
	Events.trap_reset_point_hit.connect(_on_trap_reset_point_hit)

func _on_room_loaded():
	reset_pos = player.global_position
	do_reset = true

func _on_trap_hit():
	Events.player_health_changed.connect(_on_player_health_changed, CONNECT_ONE_SHOT)
	if do_reset:
		transition_anim_player.play("trap_reset")
		await transition_anim_player.animation_finished
		player.global_position = reset_pos
		Events.player_resetted.emit()
		transition_anim_player.play_backwards("trap_reset")

func _on_player_health_changed(health):
	if health == 0:
		do_reset = false

func _on_trap_reset_point_hit(point_global_pos):
	reset_pos = point_global_pos
