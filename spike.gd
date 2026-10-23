extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var spike: AudioStreamPlayer2D = $spike
const SPIKE1 = preload("uid://dmhwjrohfwchj")


func _on_area_2d_area_entered(area: Area2D) -> void:
	var audio = AudioStreamPlayer2D.new()
	audio.volume_db = -5
	audio.stream = SPIKE1
	audio.pitch_scale = randf_range(0.9, 1.1)
	get_parent().add_child(audio)
	audio.play(0.3)
	animated_sprite_2d.animation = "active"
	pass # Replace with function body.


func _on_area_2d_area_exited(area: Area2D) -> void:
	await get_tree().create_timer(0.1).timeout
	animated_sprite_2d.animation = "inactive"
	pass # Replace with function body.
