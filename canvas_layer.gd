extends CanvasLayer
@onready var label: Label = $Control/MarginContainer/TextureRect/Control/Label

func _ready():
	var level: Level = get_tree().get_first_node_in_group("Level")
	label.text = "LEVEL " + str(level.level_number)
