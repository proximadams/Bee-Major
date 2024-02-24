extends Node2D

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
	if self.global_position.y > 450:
		self.modulate.a = 0.1
