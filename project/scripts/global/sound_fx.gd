extends Node

# These are the AudioStream resources. Set them in the Autoload Inspector.
@export var menu_music: AudioStream
@export var game_music: AudioStream
@export var chest_sound: AudioStream

# This is the AudioStreamPlayer node.
var sfx_player := AudioStreamPlayer.new()

func _ready() -> void:
	if not is_inside_tree():
		push_warning("SoundFx autload not present")
		return
	
	add_child(sfx_player)
	sfx_player.bus = "SFX"
	
	# Connect to the EventBus signal using modern Godot 4 syntax
	EventBus.open_chest_requested.connect(_on_open_chest_requested)

func _on_open_chest_requested() -> void:
	# This should now work without any errors
	if chest_sound:
		sfx_player.stream = chest_sound
		sfx_player.play()
	else:
		push_warning("Chest Open SFX sound not assigned in autload export")
