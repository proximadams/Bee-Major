extends Node


# Declaring member variables
var selected_song = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set focus to EasyButton by default
	$VBoxContainer/EasyButton.grab_focus()

# Handle input events
func _input(event):
	# Check if game is paused (to prevent accidental input during pause
	if Input.is_action_just_pressed("ui_accept"):
		# Get the currently focused UI element
		var focused_control = Input.get_current_scene_focus()
		# Check if the focused button is a song button
		if focused_control and focused_control.has_method("get_song"):
			selected_song = focused_control	.get_song()
			# Load the selected song
			load_selected_song(selected_song)
			
# Load selected song
func load_selected_song(song):
	if song:
		print("Loading: ", song)
		var song_audio = load(song.filepath)
		if song_audio:
			$AudioStreamPlayer.stream = song_audio
			$AudioStreamPlayer.play()
		else:
			print("Failed to load audio file.")
	else:
		print("Nothing selected!")


func _on_EasyButton_pressed():
	MyUtil.selected_song = "scale"
	get_tree().change_scene("res://Scenes/MainScene.tscn")

func _on_MediumButton_pressed():
	MyUtil.selected_song = "WhenTheSaintsGoMarchingIn"
	get_tree().change_scene("res://Scenes/MainScene.tscn")
	
func _on_HardButton_pressed():
	MyUtil.selected_song = "ForTheBuzzards"
	get_tree().change_scene("res://Scenes/MainScene.tscn")
