extends Control

@onready var next_level_button: Button = $MarginContainer/VBoxContainer/NextLevelButton
@onready var overview_button: Label = $MarginContainer/VBoxContainer/OverviewButton/OverviewButton
@export var level: int
@onready var audio: AudioStreamPlayer2D = $Audio

func _ready():
	get_tree().paused = true
	
func _on_overview_button_pressed() -> void:
	get_tree().paused = false
	GameManager.load_overview()
	pass # Replace with function body.

func _on_next_level_button_pressed() -> void:
	get_tree().paused = false
	GameManager.load_level(level)
	pass # Replace with function body.
	
func _on_next_level_button_mouse_entered() -> void:
	audio.pitch_scale = randf_range(0.95, 1.05)
	audio.play()
	pass # Replace with function body.


func _on_overview_button_mouse_entered() -> void:
	audio.pitch_scale = randf_range(0.95, 1.05)
	audio.play()
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		close()

func close():
	get_tree().paused = false
	self.queue_free()

func _on_button_pressed() -> void:
	close()
	pass # Replace with function body.
