extends Position2D

class_name Slot

signal tile_selected(tile, coord);

var tile_scene = preload("res://tiles/TileView.tscn")
var slot_coord: Vector2

func initialize(coord: Vector2):
	slot_coord = coord
	for child in get_children():
		if child is Tile:
			add_tile(child as Tile)

func add_tile(tile: Tile):
	var tile_view = tile_scene.instance()
	add_child(tile_view)
	tile_view.initialize(tile)
	tile_view.connect("tile_selected", self, "_on_tile_selected")

func _on_tile_selected(tile):
	emit_signal("tile_selected", tile, slot_coord)
