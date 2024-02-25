extends Node2D

func play_awful():
	$awfulJob.play()

func play_meh():
	$mehJob.play()

func play_good():
	$goodJob.play()

func play_great():
	$greatJob.play()

func go_to_select_song():
	print('aaaa')
	get_tree().change_scene("res://Scenes/SongSelect.tscn")
