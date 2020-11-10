extends Container

var triangle = preload("res://src/tiles/Triangle.tres")

export(PackedScene) var tile_scene
export(NodePath) var tween

signal tile_selected(this, tile, row)

var new_tiles := 0
var removed_tiles := []

func _ready():
	tween = get_node(tween)

func get_tiles():
	return get_children()

func get_tile(idx):
	idx = _normalize_index(idx)
	return get_tiles()[idx]

func _normalize_index(idx):
	return get_tiles().size() - idx

func _on_tile_selected(tile_node: BoardTile, tile: TileData, coord: Vector2):
	if not tween_in_progress:
		var idx = get_tiles().find(tile_node)
		coord.y = _normalize_index(idx)
		emit_signal("tile_selected", self, tile, coord)

func add_tile(tile: TileData):
	# Instance tile node
	var tile_node = tile_scene.instance() as BoardTile
	add_child(tile_node)
	move_child(tile_node, 0)
	tile_node.initialize(tile)
	tile_node.connect("tile_selected", self, "_on_tile_selected")
	new_tiles += 1
	tile_node.rect_position = -(tile_node.rect_size * new_tiles * Vector2.DOWN + 4 * new_tiles * Vector2.DOWN)

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		_resort_children()

func remove(row):
	var negative_pad = 0
	for idx in removed_tiles:
		if idx < row:
			negative_pad += 1
	remove_child(get_tile(row - negative_pad))
	removed_tiles.push_back(row)
	add_tile(triangle)

func highlight(row):
	get_tile(row).highlight()

func undo_highlight(row):
	get_tile(row).undo_highlight()

var prev_min_size = null
var tween_in_progress = false

func _resort_children():
	# Avoid rearrangements during animations
	if not tween_in_progress:
		
		# Calculate layout shift
		var min_size = _get_minimum_size()
		var layout_shift = prev_min_size - min_size if prev_min_size else Vector2.ZERO
		prev_min_size = min_size
		
		# Position children
		var offset = Vector2.ZERO
		var idx = 0
		for child in get_children():
			
			# Compensate for difference in origin position
			# NOTE: assumes the vertical size flag is set to "Shrink End"
			var prev_pos = (child.rect_position - layout_shift) * Vector2.DOWN
			
			# Animate from previous position to new offset
			(tween as Tween).interpolate_property(
				child, 'rect_position',
				prev_pos, offset, 1,
				Tween.TRANS_LINEAR, Tween.EASE_OUT, 0
			)
			
			# Fade in if new
			if idx < new_tiles:
				(tween as Tween).interpolate_property(
					child, 'modulate',
					Color.transparent, Color.white, 1,
					Tween.TRANS_LINEAR, Tween.EASE_OUT, 0
				)
			idx += 1
			
			# Accumulate offset
			var size = child.rect_size
			offset += 4 * Vector2.DOWN
			offset += size * Vector2.DOWN
		
		# Reset state trackers
		removed_tiles = []
		new_tiles = 0
		
		# Start animation and lock function entrance
		tween.start()
		tween_in_progress = true
		yield(tween, 'tween_all_completed')
		tween_in_progress = false

# Override
# @see https://docs.godotengine.org/en/stable/classes/class_control.html?#class-control-method-get-minimum-size
func _get_minimum_size():
	var offset = Vector2.ZERO
	for child in get_children():
		var size = child.rect_size
		offset += 4 * Vector2.DOWN
		offset += size * Vector2.DOWN
		if size.x > offset.x:
			offset.x = size.x
	return offset
