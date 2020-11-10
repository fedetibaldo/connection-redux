extends HBoxContainer

signal tile_selected(this, tile, coord)

func _ready():
	for column in get_columns():
		column.connect("tile_selected", self, "_on_tile_selected")

func get_columns():
	return get_children()

func get_column(idx):
	return get_columns()[idx]

func _on_tile_selected(column_node, tile, coord):
	coord.x = get_columns().find(column_node)
	emit_signal("tile_selected", self, tile, coord)

func add_tile(tile, col):
	get_columns()[col].add_tile(tile)

func remove(coord: Vector2):
	get_column(coord.x).remove(coord.y)

func highlight(coord: Vector2):
	get_column(coord.x).highlight(coord.y)

func undo_highlight(coord: Vector2):
	get_column(coord.x).undo_highlight(coord.y)
