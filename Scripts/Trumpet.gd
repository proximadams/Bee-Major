extends AudioStreamPlayer2D

var prevNoteIndex

var headNormalRes = load('res://Sprites/Bee/HeadNormal.png')
var headStressedRes = load('res://Sprites/Bee/HeadStressed.png')
var headStressed2Res = load('res://Sprites/Bee/HeadStressed2.png')

var soundResArr = [
	null,
	load('res://OGGs/C4.ogg'),# 1. C
	load('res://OGGs/C#3.ogg'),# 2. D♭
	load('res://OGGs/D3.ogg'),# 3. D
	load('res://OGGs/D#3.ogg'),# 4. E♭
	load('res://OGGs/E3.ogg'),# 5. E
	load('res://OGGs/F3.ogg'),# 6. F
	load('res://OGGs/F#3.ogg'),# 7. G♭
	load('res://OGGs/G3.ogg'),# 8. G
	load('res://OGGs/G#3.ogg'),# 9. A♭
	load('res://OGGs/A3.ogg'),# 10. A
	load('res://OGGs/A#3.ogg'),# 11. B♭
	load('res://OGGs/B3.ogg'),# 12. B
	load('res://OGGs/C3.ogg')# 13. C
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

onready var beeHead = get_tree().get_root().find_node('Head', true, false)
onready var targetAnimationPlayer = get_tree().get_root().find_node('TargetAnimationPlayer', true, false)
onready var valves = get_tree().get_root().find_node('Valves', true, false)

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
			# Show perfect or good
			if valves.windowObj:
				if valves.windowObj.valveStr == MyUtil.valve_array_to_str(currValvesPressed):
					targetAnimationPlayer.play(valves.windowObj.animName)
					if valves.windowObj.animName == 'good':
						beeHead.texture = headStressedRes
						MyUtil.scoreArr[1] += 1
					elif valves.windowObj.animName == 'perfect':
						beeHead.texture = headNormalRes
						MyUtil.scoreArr[2] += 1
				else:
					targetAnimationPlayer.play('miss')
					MyUtil.scoreArr[0] += 1
					beeHead.texture = headStressed2Res
				MyUtil.check_fail_song()
	else:
		self.playing = false
