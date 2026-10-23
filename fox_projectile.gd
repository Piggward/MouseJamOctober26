extends Node2D

@export var fall_speed := 75.0   # pixels per second
@export var amplitude := 100.0     # pixels left/right of center
@export var frequency := 0.4     # full waves per second
@onready var bark: AudioStreamPlayer2D = $Bark
@onready var area_2d: Area2D = $Area2D

var _time := 0.0
@onready var _base_x := position.x

func _process(delta: float) -> void:
	_time += delta
	position.y += fall_speed * delta
	position.x = _base_x + sin(_time * frequency * TAU) * amplitude


func _on_area_2d_area_entered(area: Area2D) -> void:
	visible = false
	area_2d.queue_free()
	bark.pitch_scale = randf_range(0.9, 1.1)
	bark.play()
	await bark.finished
	queue_free()
	pass # Replace with function body.
