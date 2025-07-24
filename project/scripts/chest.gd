extends Node2D

@onready var animated_chest: AnimatedSprite2D = $AnimatedChest

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedChest/ChestArea.connect("body_entered",  _on_area_2d_area_entered)
	
	EventBus.connect("open_chest_requested", _on_open_chest_requested)

func _on_area_2d_area_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player"):
		EventBus.emit_signal("player_entered_chest_area")
		print("player is near the chest")
		
func _on_open_chest_requested() -> void:
	animated_chest.play("default")
