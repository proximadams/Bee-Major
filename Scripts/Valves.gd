extends Node2D

const NOTE_START_Y = 300
const DIST_BETWEEN_NOTE = 3000

var noteRes = load('res://Scenes/Note.tscn')

export var song = 'scale'

var lastNote

# TODO use flats not sharps
var valveNoteMap = [
	null,
	[false, false, false],#. C
	[true, true, true],#. D♭
	[true, false, true],#. D
	[false, true, true],#. E♭
	[true, true, false],#. E
	[true, false, false],#. F
	[false, true, false],#. G♭
	[false, false, false],#. G
	[false, true, true],#. A♭
	[true, true, false],#. A
	[true, false, false],#. B♭
	[false, true, false],#. B
	[false, false, false]#. C
]

func _ready():
	var file = File.new()
	var songArr
	file.open('res://Songs/' + song + '.json', File.READ)
	songArr = parse_json(file.get_as_text())
	file.close()
	_generate_notes(songArr)
	pass

func _generate_notes(songArr):
	var positionY = NOTE_START_Y
	# loop over array. For each, generate a note scene
	for note in songArr:
		positionY -= DIST_BETWEEN_NOTE# TODO move to constant
		if note:
			lastNote = noteRes.instance()
			lastNote.finger1down = valveNoteMap[note][0]
			lastNote.finger2down = valveNoteMap[note][1]
			lastNote.finger3down = valveNoteMap[note][2]
			$notes/list.add_child(lastNote)
			lastNote.position.y = positionY

func move_list_down():
	$notes/list.global_position.y += 900

func _loop():
	var noteArr = $notes/list.get_children()
	$notes.global_position.y = 0
	$notes/list.global_position.y = -900

	for noteInst in noteArr:
		noteInst.reset_alpha()

func _process(_delta):
	if 900 < lastNote.global_position.y:
		_loop()
