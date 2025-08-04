extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	# Gives the game a chance to load
	await get_tree().process_frame
	
	EventBus.connect("player_died", _on_player_died)

func _on_player_died() -> void:
	get_tree().quit()
#	probably needs to be pause rather than quite
