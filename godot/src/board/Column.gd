extends VBoxContainer

export(PackedScene) var tile_scene
export(NodePath) var tween

var falling_tiles := 3

func _ready():
	tween = get_node(tween)

func add_tile(tile: TileData):
	# Instance tile node
	var tile_node = tile_scene.instance()
	add_child(tile_node)
	tile_node.initialize(tile)
	falling_tiles += 1

func _drop_tiles_from_above():
	var tiles = get_children()
	for i in range(falling_tiles):
		var tile = tiles[i] as Control
		var end_position = tile.rect_position
		# Assume all the child controls have the same size
		var start_position = Vector2(0, tile.rect_size.y * -(falling_tiles - i))
		# Move down
		(tween as Tween).interpolate_property(
			tile, 'rect_position',
			start_position, end_position, 0.2 + 0.1 * falling_tiles,
			Tween.TRANS_LINEAR, Tween.EASE_OUT, (3 - (i + 1)) * 0.05
		)
		# Fade in
		(tween as Tween).interpolate_property(
			tile, 'modulate',
			Color.transparent, Color.white, 0.2 + 0.1 * falling_tiles,
			Tween.TRANS_LINEAR, Tween.EASE_OUT, (3 - (i + 1)) * 0.05
		)
	falling_tiles = 0
	tween.start()

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		_drop_tiles_from_above()
