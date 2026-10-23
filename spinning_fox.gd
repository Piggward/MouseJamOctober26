extends Node2D

var target_position: Vector2
@onready var bark: AudioStreamPlayer2D = $bark

func _process(delta: float) -> void:
	position = position.move_toward(target_position, delta * 250)
	pass

func _ready():
	bark.pitch_scale = randf_range(0.9, 1.1)
	bark.play()

func _on_area_2d_area_entered(area: Area2D) -> void:
	bark.pitch_scale = randf_range(0.9, 1.1)
	bark.play()
	pass # Replace with function body.
