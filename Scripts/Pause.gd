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
    # Toggle the value of is_game_paused variable
    is_game_paused = !is_game_paused

    # Checking if the game is paused
    if is_game_paused:
        # Loading the pause menu scene if it is not already loaded
        if not pause_menu_instance:

 ##### NOTE: Do not forget to add actual pause screen scene once created #####           
            pause_menu_instance = load("").instance()
            add_child(pause_menu_instance)
        # Pausing the game by setting the tree's paused property to true
        get_tree().paused = true
        # Show pause menu
        pause_menu_instance.show()
    else:
        # Unpausing the game by setting the tree's paused property to false
        get_tree().paused = false
        # Hide and remove pause menu instance
        if pause_menu_instance:
            pause_menu_instance.hide()
            pause_menu_instance.queue_free()
            pause_menu_instance = null
