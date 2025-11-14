extends CharacterBody2D

enum State { IDLE, RUN, JUMP, FALL, DOUBLE_JUMP, KNOCKBACK }
var _current_state: State
var _abilities: Array[StringName] = [&"double_jump"]


func _ready() -> void:
	_set_current_state(State.IDLE)
	Events.player_health_depleted.connect(_on_health_depleted)

func _physics_process(delta: float) -> void:
	$Gravity.apply_gravity(delta)
	var input_axis = Input.get_axis(&"move_left", &"move_right")
	match _current_state:
		State.IDLE:
			if input_axis:
				_set_current_state(State.RUN)
			elif _jump_condition_meets():
				_set_current_state(State.JUMP)
		State.RUN:
			if not input_axis:
				_set_current_state(State.IDLE)
			elif not is_on_floor():
				_set_current_state(State.FALL)
			elif _jump_condition_meets():
				_set_current_state(State.JUMP)
			
			$PlayerMovement.do_horizontal()
		State.JUMP:
			if velocity.y > 0:
				_set_current_state(State.FALL)
			
			$PlayerMovement.do_horizontal()
			$PlayerMovement.update_jump()
		State.DOUBLE_JUMP:
			if velocity.y > 0:
				_set_current_state(State.FALL)
			
			$PlayerMovement.do_horizontal()
			$PlayerMovement.update_jump()
		State.FALL:
			if _jump_condition_meets():
				_set_current_state(State.JUMP)
			elif Input.is_action_just_pressed(&"jump") and &"double_jump" in _abilities and $PlayerMovement.can_double_jump():
				_set_current_state(State.DOUBLE_JUMP)
			if is_on_floor():
				if input_axis:
					_set_current_state(State.RUN)
				else :
					_set_current_state(State.IDLE)
			
			$PlayerMovement.do_horizontal()
			$PlayerMovement.update_jump()
		State.KNOCKBACK:
			if not $EffectHandler.is_on_knockback():
				if not is_on_floor():
					_set_current_state(State.FALL)
				else :
					if input_axis:
						_set_current_state(State.RUN)
					else :
						_set_current_state(State.IDLE)
			
			$EffectHandler.update_knockback(delta)
	
	if $EffectHandler.is_on_knockback():
		_set_current_state(State.KNOCKBACK)
	
	move_and_slide()

func receive_attack(attack_data: AttackData):
	$Health.take_damage(attack_data.DAMAGE)
	for effect in attack_data.effects:
		$EffectHandler.apply_effect(effect)

func reset():
	$Health.reset()
	$PlayerMovement.reset()
	set_deferred(&"collision_layer", 2)
	set_deferred(&"collision_mask", 1)

func _jump_condition_meets():
	if Input.is_action_just_pressed(&"jump") and $PlayerMovement.can_jump():
		return true
	return false

func _set_current_state(new_state: State):
	_current_state = new_state
	match _current_state:
		State.IDLE:
			$AnimationPlayer.play(&"idle")
			$PlayerMovement.double_jump = true
		State.RUN:
			$AnimationPlayer.play(&"run")
			$PlayerMovement.double_jump = true
		State.JUMP:
			$PlayerMovement.do_jump()
			$AnimationPlayer.play(&"jump")
			$Gravity.set_gravity($PlayerMovement.jump_gravity)
		State.DOUBLE_JUMP:
			$PlayerMovement.do_double_jump()
			$AnimationPlayer.play(&"jump")
			$Gravity.set_gravity($PlayerMovement.jump_gravity)
		State.FALL:
			$AnimationPlayer.play(&"jump")
			$Gravity.set_gravity($PlayerMovement.fall_gravity)

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
