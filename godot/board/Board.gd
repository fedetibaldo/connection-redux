extends Node2D

func initialize():
	for child in get_children():
		child.initialize()
