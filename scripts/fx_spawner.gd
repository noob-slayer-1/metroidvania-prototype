class_name FXSpawner
extends Node

const EFFECTS = {
	"player_hit": preload("res://scenes/vfx/player_hit.tscn"),
	"player_double_jump": preload("res://scenes/vfx/player_double_jump.tscn"),
	"enemy_hit": preload("res://scenes/vfx/enemy_hit.tscn")
}


static func spawn_effect(id: String):
	return EFFECTS[id].instantiate()
