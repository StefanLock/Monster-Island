# res://resources/EnemyStats.gd
# Make sure this file is saved in a 'resources' folder or similar.
class_name EnemyStats extends Resource

@export var health: int = 100
@export var attack_damage: int = 10
@export var speed: int = 100
@export var xp_on_death: int = 50
@export var enemy_name: String = "Unnamed Enemy"
@export var description: String = "A generic enemy."
@export var unique_ability: String = "" # e.g., "Fire Breath", "Stun"

func _init(h: int = 100, ad: int = 10, s: int = 100, xp: int = 50, name: String ="Enemy", desc: String ="") -> void:
	health = h
	attack_damage = ad
	speed = s
	xp_on_death = xp
	enemy_name = name
	description = desc
