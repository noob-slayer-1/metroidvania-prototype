extends CharacterBody2D

const GRAVITY = 980
const MOVE_SPEED = 300

var is_in_knockback: bool = false


func _ready() -> void:
	Events.player_health_depleted.connect(_on_health_depleted)

func _physics_process(delta: float) -> void:
	$Gravity.apply_gravity(delta)
	$PlayerMovement.move(delta)
	$EffectHandler.update(delta)
	
	move_and_slide()

func receive_attack(attack_data: AttackData):
	$Health.take_damage(attack_data.DAMAGE)
	for effect in attack_data.effects:
		$EffectHandler.apply_effect(effect)

func _on_health_depleted():
	set_deferred(&"collision_layer", 0)
	set_deferred(&"collision_mask", 0)
	
	var upward_knockback = EffectData.new()
	upward_knockback.type = EffectHandler.EffectType.KNOCKBACK
	upward_knockback.data = {
			"force": 400.0,
			"direction": Vector2.UP
	}
	$EffectHandler.apply_effect(upward_knockback)
	
	$EffectHandler.ignore_effect = true
	await get_tree().process_frame
	$EffectHandler.ignore_effect = false
