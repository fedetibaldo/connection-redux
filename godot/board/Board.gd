extends Node2D

class_name Board

func initialize():
	for child in get_children():
		child.initialize(self)

func _on_tile_selected(tile: TileView):
	tile.highlight()
