extends Node2D

class_name Board

export(PackedScene) var tile_scene

export(Array, Array, Resource) var tiles = [
	[null, null, null],
	[null, null, null],
	[null, null, null],
	[null, null, null],
]

onready var connection := $Connection
onready var matrix := $Matrix

func _ready():
	matrix.connect("tile_selected", self, "_on_tile_selected")

var coords_selected = []
var tiles_selected = []

func initialize():
	var col = 0
	for column in tiles:
		for tile in column:
			matrix.add_tile(tile, col)
		col += 1

func _is_legal_move(new_coord: Vector2) -> bool:
	if coords_selected.size():
		for coord in coords_selected:
			if new_coord == coord:
				return false
		if new_coord.distance_to(coords_selected.back()) > 1:
			return false
	return true

func _get_tile_position(tile: BoardTile):
	var offset = tile.rect_size * tile.coord
	offset.x += matrix.get_constant('separation') * tile.coord.x
	offset.y += matrix.get_constant('separation') * tile.coord.y
	return offset

func _on_tile_selected(_matrix, tile: TileData, coord: Vector2):
	if _is_legal_move(coord):
		# tiles and coords logic
		coords_selected.push_back(coord)
		tiles_selected.push_back(tile)
		# highlight new coordinate
		matrix.highlight(coord)
		#connection.add_point(
		#	_get_tile_position(tile) + tile.rect_size / 2,
		#	connection.points.size() - 1
		#)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.button_index == BUTTON_LEFT and not event.pressed:
			for coord in coords_selected:
				matrix.remove(coord)
			coords_selected = []
			# connection.points = PoolVector2Array()

func _process(_delta):
	if connection.points.size() and Input.is_mouse_button_pressed(BUTTON_LEFT):
		if connection.points.size() == 1:
			connection.add_point(Vector2.ZERO)
		connection.set_point_position(connection.points.size() - 1, to_local(get_viewport().get_mouse_position()))
