extends Node2D

signal checkpoint_reached
@onready var area_2d: Area2D = $Area2D
@onready var flag: Sprite2D = $Flag

func _on_area_2d_area_entered(area: Area2D) -> void:
	checkpoint_reached.emit()
	flag.modulate = Color.WHITE
	area_2d.queue_free()
	pass # Replace with function body.
