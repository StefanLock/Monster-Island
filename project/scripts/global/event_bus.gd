extends Node

# Player Events
signal player_died()

# Enemy Events
signal enemy_died()

# Game Events
signal game_over()

# Chest events
signal player_entered_chest_area()
signal player_exited_chest_area()
signal open_chest_requested()
