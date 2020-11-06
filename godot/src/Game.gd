extends Node2D

export(Array, Resource) var starting_combination = [null, null, null, null]

onready var board = $Board
onready var display = $Display

func _ready():
	initialize()

func initialize():
	board.initialize()
	display.initialize(starting_combination)
