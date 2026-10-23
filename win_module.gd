extends Control

@onready var next_level_button: Button = $MarginContainer/VBoxContainer/NextLevelButton
@onready var overview_button: Label = $MarginContainer/VBoxContainer/OverviewButton/OverviewButton
@export var level: int = 1
@onready var level_completed_label: Label = $Control/TextureRect/LevelCompletedLabel
const CLICK = preload("uid://f1g8jtlpxll4")
@onready var audio: AudioStreamPlayer2D = $Audio

const LEVEL_OVERVIEW = preload("uid://jrdsqk86t8ea")

func _ready():
	level_completed_label.text = "LEVEL " + str(level) + "
	COMPLETED"
	if level == GameManager.get_level_count():
		next_level_button.visible = false

func _on_overview_button_pressed() -> void:
	GameManager.load_overview()
	pass # Replace with function body.

func _on_next_level_button_pressed() -> void:
	GameManager.load_level(level + 1)
	pass # Replace with function body.
	
func _on_next_level_button_mouse_entered() -> void:
	audio.pitch_scale = randf_range(0.95, 1.05)
	audio.play()
	pass # Replace with function body.


func _on_overview_button_mouse_entered() -> void:
	audio.pitch_scale = randf_range(0.95, 1.05)
	audio.play()
	pass # Replace with function body.
