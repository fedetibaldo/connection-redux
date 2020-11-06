extends Position2D

var tile_scene = preload("res://src/tiles/Tile.tscn")

var current_combination = []

onready var container := $Container

func initialize(starting_combination):
	_instance_tiles(starting_combination)

func _instance_tiles(combination):
	var index = 0
	for tile in combination:
		var scene = tile_scene.instance()
		container.add_child(scene)
		scene.initialize(tile, Vector2(index, 0))
		index += 1
	if current_combination:
		# instance above and fade old tiles out
		pass
