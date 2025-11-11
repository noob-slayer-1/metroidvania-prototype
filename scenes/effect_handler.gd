class_name EffectHandler
extends Node2D

enum EffectType { KNOCKBACK }
const KNOCKBACK_DECAY = 600

@export var movement: Node2D
var ignore_effect: bool = false
@onready var actor: CharacterBody2D = get_owner()


func update(delta: float):
	if actor.is_in_knockback and actor.velocity:
		actor.velocity = actor.velocity.move_toward(Vector2.ZERO, delta * KNOCKBACK_DECAY)
	else :
		actor.is_in_knockback = false

func apply_effect(effect: EffectData):
	if ignore_effect:
		return
	match effect.type:
		EffectType.KNOCKBACK:
			actor.is_in_knockback = true
			movement.apply_force(effect.data["direction"], effect.data["force"])

func reset():
	actor.is_in_knockback = false
