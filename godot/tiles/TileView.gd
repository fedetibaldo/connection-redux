extends Node2D

onready var sprite = $Sprite

func initialize(tile: Tile):
	sprite.texture = tile.sprite
