extends Node2D

const NOTE_START_Y = 300
const DIST_BETWEEN_NOTE = 3000

var noteRes = load('res://Scenes/Note.tscn')

export var song = 'scale'

var lastNote

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
		if note[0] != 0:
			lastNote = noteRes.instance()
			lastNote.finger1down = valveNoteMap[note[0]][0]
			lastNote.finger2down = valveNoteMap[note[0]][1]
			lastNote.finger3down = valveNoteMap[note[0]][2]
			$notes/list.add_child(lastNote)
			lastNote.position.y = positionY

func move_list_down():
	$notes/list.global_position.y += 900

func onTimePerfect():
	$Target/AnimationPlayer.play('perfect')

func _loop():
	var noteArr = $notes/list.get_children()
	$notes.global_position.y = 0
	$notes/list.global_position.y = -900

	for noteInst in noteArr:
		noteInst.reset_alpha()

func _process(_delta):
	if 900 < lastNote.global_position.y:
		_loop()
