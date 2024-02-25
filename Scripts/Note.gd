extends Node2D

var finger1down = false
var finger2down = false
var finger3down = false
var missedThisNote = false
var playedNoteInWindow = false

# 0 = miss, 1 = good, 2 = perfect
var window = 0

onready var valves = get_tree().get_root().find_node('Valves', true, false)

func _ready():
	if finger1down:
		$Finger1.texture = load('res://Sprites/Valves/Finger1Filled.png')
	if finger2down:
		$Finger2.texture = load('res://Sprites/Valves/Finger2Filled.png')
	if finger3down:
		$Finger3.texture = load('res://Sprites/Valves/Finger3Filled.png')

func _process(_delta):
	if 400 < self.global_position.y and self.global_position.y < 500:
		var valveStr = MyUtil.valve_array_to_str([finger1down, finger2down, finger3down])
		window = 1# good
		if 440 < self.global_position.y and self.global_position.y < 460:
			window = 2# perfect
		valves.setWindowValue(window, valveStr)

		if Input.is_action_pressed('blow'):
			playedNoteInWindow = true
	elif window != 0:
		var valveStr = MyUtil.valve_array_to_str([finger1down, finger2down, finger3down])
		window = 0# miss
		valves.setWindowValue(window, valveStr)
	
	if 500 <= self.global_position.y and !playedNoteInWindow and !missedThisNote:
		valves.find_node('TargetAnimationPlayer', true, false).play('miss')
		missedThisNote = true

	if 450 < self.global_position.y and self.modulate.a == 1.0:
		self.modulate.a = 0.1

func reset_alpha():
	self.modulate.a = 1.0
