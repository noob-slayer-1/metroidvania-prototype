extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysModule.gd"

var player: Node2D
var transition_anim_player: AnimationPlayer


func _initialize():
	player = game.player
	assert(player)
	transition_anim_player = game.get_transition_anim_player()
	MetSys.room_changed.connect(_on_room_changed, CONNECT_DEFERRED)
	Events.player_health_depleted.connect(_on_player_health_depleted)

func _reset_to_start():
	player.set_process_mode(Node.PROCESS_MODE_DISABLED)
	transition_anim_player.play("room_transition")
	await transition_anim_player.animation_finished
	
	player.reset()
	
	var prev_room_instance := MetSys.get_current_room_instance()
	if prev_room_instance:
		prev_room_instance.get_parent().remove_child(prev_room_instance)
		prev_room_instance.queue_free()
	
	await game.load_room(game.starting_map)
	
	var start_point = game.map.get_node_or_null("StartPoint")
	if start_point:
		player.global_position = start_point.global_position
	
	transition_anim_player.play_backwards("room_transition")
	player.set_process_mode(Node.PROCESS_MODE_INHERIT)

func _on_room_changed(target_room: String):
	if target_room == MetSys.get_current_room_id():
		# This can happen when teleporting to another room.
		return
	
	player.set_process_mode(Node.PROCESS_MODE_DISABLED)
	transition_anim_player.play("room_transition")
	await transition_anim_player.animation_finished
	
	var prev_room_instance := MetSys.get_current_room_instance()
	if prev_room_instance:
		prev_room_instance.get_parent().remove_child(prev_room_instance)
	
	await game.load_room(target_room)
	
	if prev_room_instance:
		player.position -= MetSys.get_current_room_instance().get_room_position_offset(prev_room_instance)
		prev_room_instance.queue_free()
	
	transition_anim_player.play_backwards("room_transition")
	player.set_process_mode(Node.PROCESS_MODE_INHERIT)

func _on_player_health_depleted():
	await game.get_tree().create_timer(2.0).timeout
	_reset_to_start()
