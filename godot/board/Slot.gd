extends Position2D

var tile_scene = preload("res://tiles/TileView.tscn")

func initialize():
	for child in get_children():
		if child is Tile:
			add_tile(child as Tile)

func add_tile(tile: Tile):
	var tile_view = tile_scene.instance()
	add_child(tile_view)
	tile_view.initialize(tile)
