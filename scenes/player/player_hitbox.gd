extends Area2D

@export var cooldown: float = 1.0
@export var attack: AttackData
var can_attack = true
var hit_list = []
@onready var anim_player = $"AnimationPlayer"
@onready var effect_handler = $"../EffectHandler"
@onready var movement = $"../PlayerMovement"


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"attack") and can_attack:
		can_attack = false
		set_deferred(&"monitoring", true)
		await get_tree().process_frame
		
		if movement.last_facing_direction == Vector2.RIGHT:
			anim_player.play(&"slash_right")
		else :
			anim_player.play(&"slash_left")
		$Cooldown.start(cooldown)

func _ready() -> void:
	$Cooldown.timeout.connect(_on_cooldown_timeout)
	anim_player.connect(&"animation_finished", _on_animation_finished)

func _on_cooldown_timeout():
	can_attack = true

func _on_body_entered(body: Node2D) -> void:
	if not hit_list.has(body):
		hit_list.append(body)
	else :
		return
	
	for effect in attack.effects:
		if effect.type == EffectHandler.EffectType.KNOCKBACK:
			var direction = (body.global_position - global_position).normalized()
			effect.data["direction"] = direction
	body.receive_attack(attack)
	
	var attack_knockback = EffectData.new()
	attack_knockback.type = EffectHandler.EffectType.KNOCKBACK
	attack_knockback.data = {
			"force": 100.0,
			"direction": -movement.last_facing_direction
	}
	effect_handler.apply_effect(attack_knockback)

func _on_animation_finished(anim_name):
	if anim_name == &"slash":
		set_deferred(&"monitoring", false)
	hit_list.clear()
