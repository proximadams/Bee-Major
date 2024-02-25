extends Node

# Reference to the pause menu scene
var pause_menu_instance

# Tracking whether the game is paused or not
var is_game_paused = false

func _input(event):
	# Check if the game is paused
	if is_game_paused and pause_menu_instance:
		# Handle input events for the pause menu
		pause_menu_instance.input_event(event)
	else:
		# Handle input events for the main game
		if event.is_action_pressed("pause"):
			toggle_pause()

func toggle_pause():
	PauseScene.visible = get_tree().paused
	get_tree().paused = !get_tree().paused
