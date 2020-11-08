extends Control

class_name BoardTile

onready var sprite = $"Tile Sprite"
onready var collision_area = $CollisionArea
onready var tween = $Tween

signal tile_selected(tile);

var tile: TileData
var coord: Vector2

func _ready():
	collision_area.connect("mouse_entered", self, "_on_collision_area_mouse_enter")
	collision_area.connect("input_event", self, "_on_collision_area_input_event")
	material = material.duplicate()

func initialize(_tile: TileData, _coord: Vector2):
	coord = _coord
	tile = _tile
	sprite.texture = tile.sprite

func highlight():
	# Stop any previous animation
	tween.stop(self, "_set_highlight_amount")
	# Immediatly set it to its maximum value (enchances player feedback)
	_set_highlight_amount(Vector3.ONE)

func undo_highlight():
	# Animate
	tween.interpolate_method(
		self, "_set_highlight_amount",
		Vector3.ONE, Vector3.ZERO, .2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()

func _on_collision_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("tile_selected", self)

func _on_collision_area_mouse_enter():
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		emit_signal("tile_selected", self)

func _get_highlight_amount() -> Vector3:
	return material.get_shader_param("highlight_amount")

func _set_highlight_amount(amount: Vector3):
	material.set_shader_param("highlight_amount", amount)
