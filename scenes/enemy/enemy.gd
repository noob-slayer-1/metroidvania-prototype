extends CharacterBody2D

enum State { IDLE, CHASE, KNOCKBACK }

var current_state = State.IDLE
var player_detected = false
@onready var movement = $Movement
@onready var detect = $Detect


func _physics_process(delta: float) -> void:
	match current_state:
		State.IDLE:
			idle()
		State.CHASE:
			chase()
		State.KNOCKBACK:
			if not $EffectHandler.is_on_knockback():
				if player_detected:
					current_state = State.CHASE
				else :
					current_state = State.IDLE
			
			$EffectHandler.update_knockback(delta)
	
	if $EffectHandler.is_on_knockback():
		current_state = State.KNOCKBACK
	$Gravity.apply_gravity(delta)
	
	move_and_slide()

func idle():
	if player_detected:
		current_state = State.CHASE
	$AnimationPlayer.play(&"idle")

func chase():
	var direction = (detect.player.global_position - global_position).normalized()
	movement.move(direction)
	if direction.x > 0:
		$Sprite2D.flip_h = false
	elif direction.x < 0:
		$Sprite2D.flip_h = true
	$AnimationPlayer.play(&"moving")

func receive_attack(attack_data: AttackData):
	$Health.take_damage(attack_data.DAMAGE)
	for effect in attack_data.effects:
		$EffectHandler.apply_effect(effect)

func get_center_global_position():
	return global_position - ($CollisionShape2D.shape.size.y * 0.5 * Vector2(0, 1))
