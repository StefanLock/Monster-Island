extends StaticBody2D

@export var is_open := false
@onready var animated_chest: AnimatedSprite2D = $AnimatedChest

var player_in_range := false

func _ready() -> void:
	var chest_area: Area2D = $AnimatedChest/ChestArea
	
	EventBus.connect("player_action", _on_player_action)
	chest_area.body_entered.connect(_on_chest_area_body_entered)

# Change the function signature
func _on_chest_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		EventBus.player_entered_chest_area.emit()
		player_in_range = true

func _on_player_action() -> void:
	if player_in_range and not is_open:
		_on_chest_open()
		animated_chest.play("default")
		is_open = true

func _on_chest_open() -> void:
	EventBus.emit_signal("chest_open")
