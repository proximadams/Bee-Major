extends AudioStreamPlayer2D

var soundResArr = [
	null,
	load('res://mp3_files/_C4.mp3'),# 1
	load('res://mp3_files/_D4.mp3'),# 2
	load('res://mp3_files/_D♭4.mp3'),# 3
	load('res://mp3_files/_E4.mp3'),# 4
	load('res://mp3_files/_E♭4.mp3'),# 5
	load('res://mp3_files/_F4.mp3'),# 6
	load('res://mp3_files/_G4.mp3'),# 7
	load('res://mp3_files/_G♭4.mp3'),# 8
	load('res://mp3_files/A4.mp3'),# 9
	load('res://mp3_files/A♭4.mp3'),# 10
	load('res://mp3_files/B4.mp3'),# 11
	load('res://mp3_files/B♭4.mp3'),# 12
	load('res://mp3_files/C5.mp3')# 13
]

var currValvesPressed = [false, false, false]

func _set_stream():
	# TODO change to make note match current song note when ambiguous
	# _ _ _ means all valves pressed and T T T means no valves pressed
	if currValvesPressed[0]:
		# _ ? ?
		pass
		if currValvesPressed[1]:
			# _ _ ?
			if currValvesPressed[2]:
				# _ _ _
				stream = soundResArr[8]
			else:
				# _ _ T
				stream = soundResArr[9]
		else:
			# _ T ?
			if currValvesPressed[2]:
				# _ T _
				stream = soundResArr[7]
			else:
				# _ T T
				stream = soundResArr[12]
	else:
		# T ? ?
		pass
		if currValvesPressed[1]:
			# T _ ?
			if currValvesPressed[2]:
				# T _ _
				stream = soundResArr[5]
			else:
				# T _ T
				stream = soundResArr[11]
		else:
			# T T ?
			if currValvesPressed[2]:
				# T T _ (equivalent of _ _ T)
				stream = soundResArr[9]
			else:
				# T T T
				stream = soundResArr[1]

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
