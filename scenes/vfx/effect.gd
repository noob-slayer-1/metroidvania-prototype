extends Node2D


func _ready() -> void:
	$AnimationPlayer.connect(&"animation_finished", _on_animation_finished)
	$AnimationPlayer.play(&"effect")

func _on_animation_finished(_anim_name):
	queue_free()
