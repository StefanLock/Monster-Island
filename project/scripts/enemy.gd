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
	
	var enemy_body: Area2D = $CollisionShape2D

	EventBus.connect("enemy_damaged", _on_enemy_damaged)
	EventBus.connect("enemy_died", _on_enemy_died)
	
	enemy_body.body_entered.connect(_on_enemy_damaged)

func _on_enemy_damaged(body: Node) -> void:
	if not stats:
		return
	
	if max_health <= 0:
		_on_enemy_died()
	
	if body.is_in_group("player"):
		max_health -= 2
		print("damaged enemy")
		print(max_health)
		

func _on_chest_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		EventBus.player_entered_chest_area.emit()
		print("Player is near the chest")

func _on_enemy_died() -> void:
	EventBus.enemy_died.emit()
	queue_free()
	
