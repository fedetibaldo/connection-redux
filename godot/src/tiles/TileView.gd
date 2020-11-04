extends Node2D

class_name TileView

onready var sprite = $Sprite
onready var collision_area = $CollisionArea
onready var tween = $Tween

signal tile_selected(tile);

func _ready():
	collision_area.connect("mouse_entered", self, "_on_collision_area_mouse_enter")
	collision_area.connect("input_event", self, "_on_collision_area_input_event")
	material = material.duplicate()

func initialize(tile: Tile):
	sprite.texture = tile.sprite

func highlight():
	# Stop any previous animation
	tween.stop(self, "set_highlight_amount")
	# Immediatly set it to its maximum value (enchances player feedback)
	set_highlight_amount(Vector3.ONE)

func undo_highlight():
	# Stop any previous animation
	tween.stop(self, "set_highlight_amount")
	# Modulate the duration based on the current state
	var start = get_highlight_amount()
	var stop = Vector3.ZERO
	var max_duration = .2
	var distance = stop.normalized().distance_to(start.normalized())
	var duration = max_duration * distance
	# Animate
	tween.interpolate_method(
		self, "set_highlight_amount",
		start, stop, duration,
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

func get_highlight_amount() -> Vector3:
	return material.get_shader_param("highlight_amount")

func set_highlight_amount(amount: Vector3):
	material.set_shader_param("highlight_amount", amount)