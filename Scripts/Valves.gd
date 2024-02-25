extends Node2D

const NOTE_START_Y = 300
const DIST_BETWEEN_NOTE = 3000

var noteRes = load('res://Scenes/Note.tscn')

var song = 'output'

var lastNote
var songArr
var timerSoFar = 0.0
var windowObj

onready var trumpetAudio = get_tree().get_root().find_node('TrumpetAudio', true, false)

# TODO use flats not sharps
var valveNoteMap = [
	null,
	[false, false, false],# 1. C
	[true, true, true],# 2. D♭
	[true, false, true],# 3. D
	[false, true, true],# 4. E♭
	[true, true, false],# 5. E
	[true, false, false],# 6. F
	[false, true, false],# 7. G♭
	[false, false, false],# 8. G
	[false, true, true],# 9. A♭
	[true, true, false],# 10. A
	[true, false, false],# 11. B♭
	[false, true, false],# 12. B
	[false, false, false]# 13. C
]

func _ready():
	var file = File.new()
	file.open('res://Songs/' + song + '.json', File.READ)
	songArr = parse_json(file.get_as_text())
	file.close()
	_generate_notes()
	pass

func _generate_notes():
	var positionY = NOTE_START_Y
	# loop over array. For each, generate a note scene
	for note in songArr:
		positionY -= DIST_BETWEEN_NOTE# TODO move to constant
		if note[0] != 0:
			lastNote = noteRes.instance()
			lastNote.finger1down = valveNoteMap[note[0]][0]
			lastNote.finger2down = valveNoteMap[note[0]][1]
			lastNote.finger3down = valveNoteMap[note[0]][2]
			$notes/list.add_child(lastNote)
			lastNote.position.y = positionY

func move_list_down():
	$notes/list.global_position.y += 900

func setWindowValue(window, valveStr):
	var animName = 'miss'
	if window == 1:
		animName = 'good'
	elif window == 2:
		animName = 'perfect'
	windowObj = {
		'animName': animName,
		'valveStr': valveStr
	}

func _loop():
	var noteArr = $notes/list.get_children()
	$notes.global_position.y = 0
	$notes/list.global_position.y = -900
	timerSoFar = 0.0

	for noteInst in noteArr:
		noteInst.reset_alpha()

func _process(delta):
	if 900 < lastNote.global_position.y:
		_loop()

	timerSoFar += delta
	var noteInSongIndex = int(timerSoFar + 0.5) - 2
	if 0 <= noteInSongIndex and noteInSongIndex < songArr.size():
		# the note to play which is an index of valveNoteMap
		var noteIndex = songArr[noteInSongIndex][0]
		var valveArr = valveNoteMap[noteIndex]
		if valveArr:
			var valveStr = MyUtil.valve_array_to_str(valveArr)
			trumpetAudio.current_note(valveStr, noteIndex)
