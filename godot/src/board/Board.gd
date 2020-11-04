extends Node2D

class_name Board

onready var connection = $Connection
var tiles_selected = []
var coords_selected = []

func initialize():
	var index = 0
	for child in get_slots():
		child.initialize(_index_to_coord(index))
		child.connect("tile_selected", self, "_on_tile_selected")
		index += 1

func get_slots():
	var slots = []
	for child in get_children():
		if child is Slot:
			slots.push_back(child)
	return slots

func _index_to_coord(index: int) -> Vector2:
	return Vector2(index % 4, floor(index / 4))

func _coord_to_index(coord: Vector2) -> int:
	return int(coord.y * 4 + coord.x)

func _is_legal_move(new_coord: Vector2) -> bool:
	if coords_selected.size():
		for coord in coords_selected:
			if new_coord == coord:
				return false
		if new_coord.distance_to(coords_selected.back()) > 1:
			return false
	return true

func _on_tile_selected(tile: TileView, coord: Vector2):
	if _is_legal_move(coord):
		# tiles and coords logic
		tile.highlight()
		tiles_selected.push_back(tile)
		coords_selected.push_back(coord)
		connection.add_point(
			# Ugly code ahead
			coord * 21 + Vector2(17/2, 17/2) + Vector2(3/2, 0),
			connection.points.size() - 1
		)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.button_index == BUTTON_LEFT and not event.pressed:
			for tile in tiles_selected:
				tile = tile as TileView
				tile.undo_highlight()
			tiles_selected = []
			coords_selected = []
			connection.points = PoolVector2Array()

func _process(_delta):
	if connection.points.size() and Input.is_mouse_button_pressed(BUTTON_LEFT):
		if connection.points.size() == 1:
			connection.add_point(Vector2.ZERO)
		connection.set_point_position(connection.points.size() - 1, to_local(get_viewport().get_mouse_position()))
