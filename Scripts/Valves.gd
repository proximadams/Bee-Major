extends Node2D

const NOTE_START_Y = 300
const DIST_BETWEEN_NOTE_FULL = 6000
const DIST_BETWEEN_NOTE_HALF = 3000
const DIST_BETWEEN_NOTE_QUARTER = 1500
const DIST_BETWEEN_NOTE_EIGHTH = 750

var noteRes = load('res://Scenes/Note.tscn')

var song = 'output'

var lastNote
var nextDist = -1800
var songArr
var windowObj

# onready var trumpetAudio = get_tree().get_root().find_node('TrumpetAudio', true, false)

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
	var currNoteInSongIndex = 0
	var positionY = NOTE_START_Y
	# loop over array. For each, generate a note scene
	for note in songArr:
		positionY -= nextDist
		if note[1] == 1:
			# if note[0] == 0:
			# 	nextDist = DIST_BETWEEN_NOTE_FULL + DIST_BETWEEN_NOTE_QUARTER
			# else:
			nextDist = DIST_BETWEEN_NOTE_FULL
		elif note[1] == 2:
			nextDist = DIST_BETWEEN_NOTE_HALF
		elif note[1] == 3:
			nextDist = DIST_BETWEEN_NOTE_HALF + DIST_BETWEEN_NOTE_QUARTER
		elif note[1] == 4:
			nextDist = DIST_BETWEEN_NOTE_QUARTER
		elif note[1] == 6:
			nextDist = DIST_BETWEEN_NOTE_QUARTER + DIST_BETWEEN_NOTE_EIGHTH
		elif note[1] == 8:
			nextDist = DIST_BETWEEN_NOTE_EIGHTH
		else:
			print('ERROR. note[1] = ' + str(note[1]))
		if note[0] != 0:
			lastNote = noteRes.instance()
			lastNote.finger1down = valveNoteMap[note[0]][0]
			lastNote.finger2down = valveNoteMap[note[0]][1]
			lastNote.finger3down = valveNoteMap[note[0]][2]
			$notes/list.add_child(lastNote)
			lastNote.position.y = positionY
			lastNote.noteInSongIndex = currNoteInSongIndex
		currNoteInSongIndex += 1

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

	for noteInst in noteArr:
		noteInst.reset_alpha()

func _process(_delta):
	if 900 < lastNote.global_position.y:
		_loop()
