extends Node2D

@onready var gravity_strength = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var actor: CharacterBody2D = get_owner()


func apply_gravity(delta):
	if not actor.is_on_floor() and not actor.is_in_knockback:
		actor.velocity.y += gravity_strength * delta
