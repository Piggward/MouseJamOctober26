extends Node2D

const TILE_SIZE = Vector2(64, 32)

func _ready():
	var parent = get_parent()
	parent.global_position = (parent.global_position / TILE_SIZE).floor() * TILE_SIZE
	parent.global_position += TILE_SIZE / 2.0
