extends Node2D

const NOTE_START_Y = -300
const DIST_BETWEEN_NOTE = 3300

var noteRes = load('res://Scenes/Note.tscn')

export var song = 'scale'

var valveNoteMap = [
	null,
	[false, false, false],#. C
	[true, true, true],#. C#
	[true, false, true],#. D
	[false, true, true],#. D#
	[true, true, false],#. E
	[true, false, false],#. F
	[false, true, false],#. F#
	[false, false, false],#. G
	[false, true, true],#. G#
	[true, true, false],#. A
	[true, false, false],#. A#
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

func _generate_notes(songArr):
	var positionY = NOTE_START_Y
	# loop over array. For each, generate a note scene
	for note in songArr:
		positionY -= DIST_BETWEEN_NOTE# TODO move to constant
		if note:
			var noteInst = noteRes.instance()
			noteInst.finger1down = valveNoteMap[note][0]
			noteInst.finger2down = valveNoteMap[note][1]
			noteInst.finger3down = valveNoteMap[note][2]
			$notes.add_child(noteInst)
			noteInst.position.y = positionY

func _process(delta):
	$notes.position.y += 400 * delta
