# enemy.gd
extends CharacterBody2D

@export var stats: EnemyStats
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
# Use a specific reference to the damage area for clarity.
@onready var damage_area: Area2D = $Damage_area
@onready var detection_area: Area2D = $Detection_area
@onready var attack_area: Area2D = $Attack_area

enum States {IDLE, FOLLOWING, ATTACKING, TAKING_DAMAGE, DEAD}
var state: States = States.IDLE
var current_health: int
var target: Node

func _ready() -> void:
	if not stats:
		print("Error: Enemy stats not loaded!")
		queue_free()
		return

	current_health = stats.health
	print(stats.enemy_name, " has spawned with ", current_health, " health.")

	damage_area.body_entered.connect(_on_damage_area_body_entered)
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)
	attack_area.body_entered.connect(_on_attack_area_body_entered)

func _physics_process(_delta: float) -> void:
	
	if state == States.IDLE:
		IDLE()
	elif state == States.FOLLOWING:
		FOLLOWING()
	elif state == States.ATTACKING:
		move_and_slide()
	elif state == States.TAKING_DAMAGE:
		pass
	elif state == States.DEAD:
		die()
	else:
		state = States.IDLE

func IDLE() -> void:
	animated_sprite_2d.play("idle")

func FOLLOWING() -> void:
	var direction : Vector2 = global_position.direction_to(target.global_position)
		
	if abs(direction.x) > abs(direction.y):
		animated_sprite_2d.play("move_right" if direction.x > 0 else "move_left")
	else:
		animated_sprite_2d.play("move_down" if direction.y > 0 else "move_up")

	velocity = direction * stats.speed
	move_and_slide()

func _on_detection_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		target = body
		state = States.FOLLOWING

func _on_detection_area_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		state = States.IDLE

func _on_damage_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		state = States.TAKING_DAMAGE
		take_damage(50)

func _on_attack_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		state = States.ATTACKING
		attack()

func attack() -> void:
	if not target: 
		state = States.IDLE
		return
	
	await get_tree().create_timer(0.2).timeout
	
	var lunge_dir : Vector2 = global_position.direction_to(target.global_position)
	var lunge_speed : float = 800.0
	velocity = lunge_dir * lunge_speed 
	
	var tween : Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "velocity", Vector2.ZERO, 0.4) 
	
	tween.parallel().tween_property(animated_sprite_2d, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(animated_sprite_2d, "scale", Vector2(1.0, 1.0), 0.2)

	await tween.finished
	
	await get_tree().create_timer(0.5).timeout
	state = States.FOLLOWING

func take_damage(damage_amount: int) -> void:
	state = States.TAKING_DAMAGE
	if current_health <= 0:
		return

	current_health -= damage_amount
	print(stats.enemy_name, " took ", damage_amount, " damage. Health is now ", current_health)
	
	var tween : Tween = create_tween()
	tween.tween_property(animated_sprite_2d, "modulate", Color.DARK_RED , 0.2)
	tween.tween_property(animated_sprite_2d, "modulate", Color.WHITE , 0.2)
	await tween.finished
	
	if current_health <= 0:
		state = States.DEAD


func die() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(animated_sprite_2d, "modulate", Color.DARK_RED , 0.1)
	tween.tween_property(animated_sprite_2d, "rotation", PI, 0.6)
	await tween.finished
	queue_free()
	
	EventBus.enemy_died.emit()
	print(stats.enemy_name, " has died.")
