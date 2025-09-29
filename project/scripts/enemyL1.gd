# enemy.gd
extends CharacterBody2D

@export var stats: EnemyStats

var current_health: int

# Use a specific reference to the damage area for clarity.
@onready var damage_area: Area2D = $Damage_area

func _ready() -> void:
	if not stats:
		print("Error: Enemy stats not loaded!")
		queue_free()
		return

	current_health = stats.health
	print(stats.enemy_name, " has spawned with ", current_health, " health.")

	damage_area.body_entered.connect(_on_damage_area_body_entered)

	EventBus.connect("enemy_damaged", take_damage)


func _on_damage_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		take_damage(50)


func take_damage(damage_amount: int) -> void:
	if current_health <= 0:
		return

	current_health -= damage_amount
	print(stats.enemy_name, " took ", damage_amount, " damage. Health is now ", current_health)
	
	if current_health <= 0:
		die()


func die() -> void:
	EventBus.enemy_died.emit()
	print(stats.enemy_name, " has died.")
	queue_free()
