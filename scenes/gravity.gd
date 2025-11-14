extends Node2D

@onready var gravity_strength = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var actor: CharacterBody2D = get_owner()


func apply_gravity(delta):
	actor.velocity.y += gravity_strength * delta

func set_gravity(value):
	gravity_strength = value
