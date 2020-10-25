extends Position2D

var tile_scene = preload("res://tiles/TileView.tscn")

func initialize(board: Board):
	for child in get_children():
		if child is Tile:
			var tile = add_tile(child as Tile)
			tile.connect("tile_selected", board, "_on_tile_selected")

func add_tile(tile: Tile) -> TileView:
	var tile_view = tile_scene.instance()
	add_child(tile_view)
	tile_view.initialize(tile)
	return tile_view
