extends Control

@onready var star_counter: Label = $MarginContainer/HBoxContainer/TextureRect/StarCounter

func _ready():
	star_counter.text = str(GameManager.completed_levels.size())
