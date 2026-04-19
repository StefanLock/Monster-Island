extends Node

# Player Events
signal player_died()
signal player_damage()
signal player_attack()
signal player_action()

# Enemy Events
signal enemy_died()
signal enemy_attacked()
signal enemy_damaged()

# Game Events
signal game_over()

# Chest events
signal player_entered_chest_area()
signal chest_open()
