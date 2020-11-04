extends Node2D

class_name Board

var tile_scene = preload("res://src/board/Tile.tscn")

export(Array, Array, Resource) var tiles = [
	[null, null, null, null],
	[null, null, null, null],
	[null, null, null, null],
]

onready var connection := $Connection

var tiles_selected = []

func initialize():
	var row = 0
	for tile_row in tiles:
		var col = 0
		for tile in tile_row:
			var scene = tile_scene.instance()
			add_child(scene)
			scene.initialize(tile, Vector2(col, row))
			scene.connect("tile_selected", self, "_on_tile_selected")
			col += 1
		row += 1

func _index_to_coord(index: int) -> Vector2:
	return Vector2(index % 4, floor(index / 4))

func _coord_to_index(coord: Vector2) -> int:
	return int(coord.y * 4 + coord.x)

func _is_legal_move(new_coord: Vector2) -> bool:
	if tiles_selected.size():
		for tile in tiles_selected:
			if new_coord == tile.coord:
				return false
		if new_coord.distance_to(tiles_selected.back().coord) > 1:
			return false
	return true

func _on_tile_selected(tile: Tile):
	if _is_legal_move(tile.coord):
		# tiles and coords logic
		tile.highlight()
		tiles_selected.push_back(tile)
		connection.add_point(
			tile.position + Vector2(tile.size, tile.size) / 2,
			connection.points.size() - 1
		)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.button_index == BUTTON_LEFT and not event.pressed:
			for tile in tiles_selected:
				tile = tile as Tile
				tile.undo_highlight()
			tiles_selected = []
			connection.points = PoolVector2Array()

func _process(_delta):
	if connection.points.size() and Input.is_mouse_button_pressed(BUTTON_LEFT):
		if connection.points.size() == 1:
			connection.add_point(Vector2.ZERO)
		connection.set_point_position(connection.points.size() - 1, to_local(get_viewport().get_mouse_position()))
