extends CharacterBody2D

@export var speed := 100.0
@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var _can_interact_with_chest : bool = false

func _ready() -> void:
	EventBus.connect("player_entered_chest_area", _on_player_entered_chest_area)
	
func get_input() -> void:
	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	var normalized_direction: Vector2 = input_direction.normalized()
	
	if normalized_direction:
		velocity = input_direction * speed
		
		if abs(normalized_direction.x) > abs(normalized_direction.y):
			if normalized_direction.x > 0:
				_animated_sprite_2d.play("walk_right")
			else:
				_animated_sprite_2d.play("walk_left")
		else:
			if normalized_direction.y > 0:
				_animated_sprite_2d.play("walk_down")
			else:
				_animated_sprite_2d.play("walk_up")
	else:
		velocity = Vector2.ZERO
		_animated_sprite_2d.stop()

func _on_player_entered_chest_area() -> void:
	_can_interact_with_chest = true

func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()
	
	if _can_interact_with_chest and Input.is_action_just_pressed("interact"):
		EventBus.emit_signal("open_chest_requested")
		print("player requested to open chest")
		_can_interact_with_chest = false
