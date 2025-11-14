extends Node2D


func _ready() -> void:
	MetSys.register_storable_object_with_marker(self)

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.receive_ability(&"double_jump")
	MetSys.store_object(self)
	queue_free()
