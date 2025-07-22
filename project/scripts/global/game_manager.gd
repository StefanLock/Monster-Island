extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	# Gives the game a chance to load
	await get_tree().process_frame
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
