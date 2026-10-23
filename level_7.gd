extends Level

signal restart_requested
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var projectiles: Node2D = $Projectiles
@onready var panel: Panel = $Panel

func start():
	level_ready.emit()
	GameManager.play_boss_music()

func cheese_picked_up(cheese):
	win()
	var s = STAR_PICKUP.instantiate()
	add_child(s)
	s.emitting = true
	s.position = cheese.position
	return
	
func win():
	var w = WIN_MODULE.instantiate()
	w.level = level_number
	canvas_layer.add_child(w)
	GameManager.level_completed(level_number)
	self.process_mode = Node.PROCESS_MODE_DISABLED

func _ready():
	GameManager.slow_music()
	tile_size *= tile_map.scale
	respawn_point = start_point.position
	floor_objects.drop_complete.connect(_drop_rest)
	for c in last_objects:
		c.position.y -= drop_height
	if floor_objects.get_child_count() == 0:
		_drop_rest()
	restart_requested.connect(_on_restart)
	
func _on_restart():
	GameManager.music.stop()
	animation_player.play("fade")
	await animation_player.animation_finished
	for child in projectiles.get_children():
		child.queue_free()
	await get_tree().create_timer(1.0).timeout
	GameManager.play_boss_music()
	await get_tree().create_timer(1.7).timeout
	level_ready.emit()
	panel.modulate.a = 0.0
	
func _drop_rest():
	await get_tree().create_timer(0.5).timeout
	for i in last_objects:
		_drop(i)
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		var m = MENU_MODULE.instantiate()
		m.level = self.level_number
		canvas_layer.add_child(m)
		return
	
func _drop(node: Node2D) -> void:
	var tween := create_tween()
	tween.tween_property(node, "position", node.position + Vector2(0, drop_height), 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	await tween.finished
	var audio = AudioStreamPlayer2D.new()
	audio.stream = THUDS
	audio.pitch_scale = randf_range(3.5, 3.6)
	add_child(audio)
	audio.play()
