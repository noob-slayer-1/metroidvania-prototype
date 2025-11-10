extends Node2D

@export var height_marker: Marker2D


func _ready() -> void:
	if height_marker:
		assert(_is_children(height_marker), "Height marker must be children of TrapResetPoint")
		$Area2D/CollisionShape2D.shape.size.y = abs(height_marker.position.y)
		$Area2D/CollisionShape2D.position.y = height_marker.position.y / 2

func _is_children(node):
	for child in get_children():
		if child == node:
			return true
	return false

func _on_area_2d_body_entered(_body: Node2D) -> void:
	Events.trap_reset_point_hit.emit(global_position)
