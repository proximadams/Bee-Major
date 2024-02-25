extends AudioStreamPlayer2D

var prevNoteIndex

var soundResArr = [
	null,
	load('res://mp3_files/_C4.mp3'),# 1. C
	load('res://mp3_files/_D♭4.mp3'),# 2. D♭
	load('res://mp3_files/_D4.mp3'),# 3. D
	load('res://mp3_files/_E♭4.mp3'),# 4. E♭
	load('res://mp3_files/_E4.mp3'),# 5. E
	load('res://mp3_files/_F4.mp3'),# 6. F
	load('res://mp3_files/_G♭4.mp3'),# 7. G♭
	load('res://mp3_files/_G4.mp3'),# 8. G
	load('res://mp3_files/A♭4.mp3'),# 9. A♭
	load('res://mp3_files/A4.mp3'),# 10. A
	load('res://mp3_files/B♭4.mp3'),# 11. B♭
	load('res://mp3_files/B4.mp3'),# 12. B
	load('res://mp3_files/C5.mp3')# 13. C
]

# _ _ _ means all valves are down
# T T T means all valves are up
var currAmbiguousNoteObj = {
	'_ _ _': 8,
	'_ _ T': 10,
	'_ T _': 3,
	'_ T T': 11,
	'T _ _': 9,
	'T _ T': 12,
	'T T _': 10,
	'T T T': 13,
}

var currValvesPressed = [false, false, false]

func current_note(valveStr, noteIndex):
	currAmbiguousNoteObj[valveStr] = noteIndex
	if prevNoteIndex != noteIndex and valveStr == 'T T T' and (currValvesPressed == [false, false, false] or !Input.is_action_pressed('blow')):
		_set_stream()
	prevNoteIndex = noteIndex

func _set_stream():
	var valveStr = MyUtil.valve_array_to_str(currValvesPressed)
	var noteIndex = currAmbiguousNoteObj[valveStr]
	stream = soundResArr[noteIndex]

func _refresh_stream():
	if Input.is_action_pressed('finger1') != currValvesPressed[0] or \
		Input.is_action_pressed('finger2') != currValvesPressed[1] or \
		Input.is_action_pressed('finger3') != currValvesPressed[2]:
		# set currValvesPressed to current state
		currValvesPressed = [
			Input.is_action_pressed('finger1'),
			Input.is_action_pressed('finger2'),
			Input.is_action_pressed('finger3')
		]
		_set_stream()

func _process(_delta):
	if Input.is_action_pressed('blow'):
		_refresh_stream()
		if !self.playing:
			self.play()
	else:
		self.playing = false
