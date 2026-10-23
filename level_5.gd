extends Level
@onready var glitch_sprite: Sprite2D = $GlitchSprite
@onready var cheese: Node2D = $Cheese
@onready var spinning_foxes: Node2D = $SpinningFoxes

func _drop(node: Node2D) -> void:
	var tween := create_tween()
	tween.tween_property(node, "position", node.position + Vector2(0, drop_height), 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	await tween.finished
	var audio = AudioStreamPlayer2D.new()
	audio.stream = THUDS
	audio.pitch_scale = randf_range(3.5, 3.6)
	add_child(audio)
	audio.play()
	glitch_sprite.visible = true
	await get_tree().create_timer(0.5).timeout
	var tween2 := create_tween()
	tween2.tween_property(cheese, "position", spinning_foxes.position, 1.0).set_trans(Tween.TRANS_LINEAR)
	await get_tree().create_timer(2.0).timeout
	for i in floor_objects.get_children():
		var tween3 := create_tween()
		tween3.tween_property(i, "global_position", spinning_foxes.global_position, 1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await get_tree().create_timer(1.5).timeout
	floor_objects.queue_free()
	glitch_sprite.visible = false
	level_ready.emit()
