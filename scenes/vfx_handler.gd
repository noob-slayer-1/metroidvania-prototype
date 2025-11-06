extends Node2D

signal effect_spawned(effect, global_pos)


func _ready() -> void:
	Events.player_hit_vfx.connect(_on_player_hit_vfx)
	Events.enemy_hit_vfx.connect(_on_enemy_hit_vfx)

func _on_player_hit_vfx(at_global_pos):
	effect_spawned.emit(FXSpawner.spawn_effect("player_hit"), at_global_pos)

func _on_enemy_hit_vfx(at_global_pos):
	effect_spawned.emit(FXSpawner.spawn_effect("enemy_hit"), at_global_pos)
