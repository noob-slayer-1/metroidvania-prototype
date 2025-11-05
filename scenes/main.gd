extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"

@export_file("room_link") var starting_map: String

func _ready() -> void:
	MetSys.reset_state()
	set_player($Player)
	MetSys.set_save_data()
	room_loaded.connect(_on_room_loaded, CONNECT_DEFERRED)
	load_room(starting_map)
	add_module("RoomTransitions.gd")

func _on_room_loaded():
	MetSys.get_current_room_instance().adjust_camera_limits($Player/Camera2D)
	if MetSys.last_player_position.x == Vector2i.MAX.x:
		MetSys.set_player_position(player.position)
