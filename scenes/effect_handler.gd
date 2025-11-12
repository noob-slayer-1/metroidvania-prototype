class_name EffectHandler
extends Node2D

enum EffectType { KNOCKBACK }
const KNOCKBACK_DECAY = 600

@export var movement: Node2D
var ignore_effect: bool = false
@onready var actor: CharacterBody2D = get_owner()

var knockback_velocity = Vector2.ZERO
var knockback_dissipate_treshold = 5.0


func is_on_knockback():
	return not knockback_velocity == Vector2.ZERO

func update_knockback(delta: float):
	actor.velocity = knockback_velocity
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, KNOCKBACK_DECAY * delta)
	if knockback_velocity.length() <= knockback_dissipate_treshold:
		knockback_velocity = Vector2.ZERO

func apply_effect(effect: EffectData):
	if ignore_effect:
		return
	match effect.type:
		EffectType.KNOCKBACK:
			knockback_velocity = effect.data["direction"] * effect.data["force"]
			movement.apply_force(effect.data["direction"], effect.data["force"])
