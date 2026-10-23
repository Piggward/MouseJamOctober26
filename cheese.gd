extends Node2D

var level

func _ready():
	level = get_tree().get_first_node_in_group("Level")

func _on_area_2d_area_entered(area: Area2D) -> void:
	level.cheese_picked_up(self)
	self.queue_free()
	pass # Replace with function body.
