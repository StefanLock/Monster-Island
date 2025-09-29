extends StaticBody2D

@export var is_open := false

@onready var animated_chest: AnimatedSprite2D = $AnimatedChest

func _ready() -> void:
	var chest_area: Area2D = $AnimatedChest/ChestArea

	chest_area.body_entered.connect(_on_chest_area_body_entered)
	chest_area.body_exited.connect(_on_chest_area_body_exited)
	
	EventBus.open_chest_requested.connect(_on_open_chest_requested)

# Change the function signature
func _on_chest_area_body_entered(body: Node) -> void:
	if is_open:
		print("Chest is already open")
		return
	elif body.is_in_group("player"):
		EventBus.player_entered_chest_area.emit()
		print("Player is near the chest")

func _on_chest_area_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		EventBus.player_exited_chest_area.emit()
		print("Player left the chest area")
	
func _on_open_chest_requested() -> void:
	if not is_open:
		animated_chest.play("default")
		
		is_open = true
	
