extends Node2D

onready var board = $Board

func _ready():
	initialize()

func initialize():
	board.initialize()
