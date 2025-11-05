extends TextureRect


func _ready() -> void:
	Events.player_health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(health):
	var region
	match health:
		0:
			region = Rect2(Vector2(28.0, 28.0), Vector2(87.0, 23.0))
		1:
			region = Rect2(Vector2(28.0, 76.0), Vector2(87.0, 23.0))
		2:
			region = Rect2(Vector2(28.0, 124.0), Vector2(87.0, 23.0))
		3:
			region = Rect2(Vector2(28.0, 172.0), Vector2(87.0, 23.0))
		4:
			region = Rect2(Vector2(28.0, 220.0), Vector2(87.0, 23.0))
		5:
			region = Rect2(Vector2(140.0, 28.0), Vector2(87.0, 23.0))
		_:
			region = Rect2(Vector2(28.0, 28.0), Vector2(87.0, 23.0))
	texture.set_region(region)
