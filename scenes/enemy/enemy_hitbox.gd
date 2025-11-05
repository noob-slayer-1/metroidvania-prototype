extends Area2D

@export var attack: AttackData
@onready var enemy = get_owner()
@onready var effect_handler = $"../EffectHandler"


func _on_body_entered(body: Node2D) -> void:
	var knockback
	for effect in attack.effects:
		if effect.type == EffectHandler.EffectType.KNOCKBACK:
			var direction = (body.global_position - enemy.global_position).normalized()
			if not body.is_on_floor():
				var new_direction = (body.global_position - enemy.get_center_global_position()).normalized()
				if new_direction.y < 0:
					direction = new_direction
			effect.data["direction"] = direction
			knockback = effect
	body.receive_attack(attack)
	
	var self_knockback = knockback.duplicate_deep()
	self_knockback.data["direction"] = -self_knockback.data["direction"]
	effect_handler.apply_effect(self_knockback)
