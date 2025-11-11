extends CharacterBody2D

var is_in_knockback: bool = false
var can_controlled = true


func _ready() -> void:
	Events.player_health_depleted.connect(_on_health_depleted)
	Events.trap_hit.connect(_on_trap_hit)
	Events.player_resetted.connect(_on_player_resetted)

func _physics_process(delta: float) -> void:
	if can_controlled:
		$Gravity.apply_gravity(delta)
		$PlayerMovement.update()
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

func _on_trap_hit():
	can_controlled = false

func _on_player_resetted():
	can_controlled = true
