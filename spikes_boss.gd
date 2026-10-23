extends Node2D

var gravity = 1
@onready var metal: AudioStreamPlayer2D = $Metal
const METAL_HIT_2 = preload("uid://27skwdcegsqf")
const METAL_HIT = preload("uid://ctu05rvmsxj7x")
@onready var metal_2: AudioStreamPlayer2D = $Metal2
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _process(delta):
	self.position.y += delta * gravity
	gravity *= 1.0 + delta * 4

func _ready():
	audio_stream_player_2d.play(0.2)

func _on_timer_timeout() -> void:
	self.queue_free()
	pass # Replace with function body.


func _on_area_2d_area_entered(area: Area2D) -> void:
	var player = metal if randf_range(0.0, 1.0) > 0.3 else metal_2
	player.pitch_scale = randf_range(0.9, 1.1)
	player.play()
	pass # Replace with function body.
