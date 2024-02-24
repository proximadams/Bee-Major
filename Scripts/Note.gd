extends Node2D

onready var valves = get_tree().get_root().find_node('Valves', true, false)

var finger1down = false
var finger2down = false
var finger3down = false

func _ready():
	if finger1down:
		$Finger1.texture = load('res://Sprites/Valves/Finger1Filled.png')
	if finger2down:
		$Finger2.texture = load('res://Sprites/Valves/Finger2Filled.png')
	if finger3down:
		$Finger3.texture = load('res://Sprites/Valves/Finger3Filled.png')

func _process(_delta):
	if self.global_position.y > 450 and self.modulate.a == 1.0:
		self.modulate.a = 0.1
		valves.onTimePerfect()

func reset_alpha():
	self.modulate.a = 1.0
