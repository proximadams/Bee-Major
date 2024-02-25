extends Node

var scoreArr = [
	0,# miss
	0,# good
	0# perfect
]

func valve_array_to_str(valveArr):
	var valveStr = ''
	if valveArr[0]:
		valveStr += '_ '
	else:
		valveStr += 'T '
	if valveArr[1]:
		valveStr += '_ '
	else:
		valveStr += 'T '
	if valveArr[2]:
		valveStr += '_'
	else:
		valveStr += 'T'
	return valveStr

func check_fail_song():
	var songFinishedSound = get_tree().get_root().find_node('SongFinishedSound', true, false)
	if 1 < scoreArr[0] and scoreArr[1] < scoreArr[0] and scoreArr[2] < scoreArr[0]:
		songFinishedSound.play_awful()
		get_tree().paused = true
