extends Node2D

@export var drop_height := 600.0
@export var min_drop_time := 1.0
@export var max_drop_time := 0.4
@export var stagger := 0.004
const THUDS = preload("uid://dh8fgndl71axk")

signal drop_complete

func _ready():
	for c in get_parent().get_children():
		if c is CustomTileMapLayer:
			c.map_loaded.connect(_on_map_loaded)
	for c in get_children():
		c.position.y -= drop_height
		
func _on_map_loaded():
	for i in get_child_count():
		_drop(get_child(i), i * stagger, i == get_child_count() - 1)

func _drop(node: Node2D, delay: float, last: bool) -> void:
	var tween := create_tween()
	tween.tween_interval(delay)
	var drop_time = randf_range(min_drop_time, max_drop_time)
	tween.tween_property(node, "position", node.position + Vector2(0, drop_height), drop_time).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	if last:
		await tween.finished
		drop_complete.emit()
		return
	var audio = AudioStreamPlayer2D.new()
	audio.stream = THUDS
	audio.pitch_scale = randf_range(0.5, 0.6)
	get_parent().add_child(audio)
	get_tree().create_timer(drop_time * 0.4).timeout.connect(func(): 
		audio.play())
	get_tree().create_timer(drop_time).timeout.connect(func(): 
		audio.play())
