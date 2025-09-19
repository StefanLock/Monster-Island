extends CharacterBody2D

@export var stats: EnemyStats

var max_health: int

func ready() -> void:
	if not EnemyStats:
		print("Error: Enemy stats not loaded")
		queue_free()
		return
	max_health = stats.health
	print(stats.enemy_name, "Has spawned with ", stats.health, " health.")

func take_damage(damage_amount: int) -> void:
	if not stats:
		return
	
	max_health -= damage_amount
	
	if max_health <= 0:
		die()

func die() -> void:
	queue_free()
	
