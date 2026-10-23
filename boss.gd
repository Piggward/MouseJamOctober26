extends Sprite2D

const FOX_DEAD = preload("uid://cyosyxbsns1dw")
const FOX_DOWN_MEAN = preload("uid://c3y4y2t2d76l")
const WHITE_PER_HIT := 0.4
const SPIKES_BOSS = preload("uid://bd82f6hmj4sx7")
const FOX_PROJECTILE = preload("uid://bkjm6ho2yqpgu")
const SHOOT_1 = preload("uid://1hco3m0rna1a")
const SHOOT_2 = preload("uid://cwrfl6f0u6efi")
const SHOOT_3 = preload("uid://d1t4r6dgcc5fr")
const SHOOT_4 = preload("uid://b1q57d0esrvk7")
@onready var cheese: Node2D = $"../Cheese"

var shot_sounds = [
	SHOOT_1,
	SHOOT_2,
	SHOOT_3,
	SHOOT_4
]
@onready var hit_s_ound: AudioStreamPlayer2D = $HitSOund

var _whiteness := 0.0
var min = 150
var max = 1000
var current = "min"
var speed = 3.6
var _move_tween: Tween

var max_spike = 4.0
var min_spike = 0.75

var max_fox = 1.0
var min_fox = 0.25
@onready var glitch_sprite_2: Sprite2D = $GlitchSprite2

@onready var hurt_timer: Timer = $HurtTimer
@onready var projectiles: Node2D = $"../Projectiles"
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var spike_timer: Timer = $SpikeTimer
@onready var fox_timer: Timer = $FoxTimer
@onready var glitch_sound: AudioStreamPlayer2D = $Glitch_sound
@onready var mouse_down: AnimatedSprite2D = $"../MouseDown"
@onready var glimmer: AudioStreamPlayer2D = $"../Glimmer"

func _on_area_2d_area_entered(area: Area2D) -> void:
	if progress_bar.value <= 0:
		return
	#take dmg
	progress_bar.value -= 1.0
	if progress_bar.value <= 0:
		die()
		return
	hit_s_ound.stream = shot_sounds.pick_random()
	hit_s_ound.pitch_scale = randf_range(0.95, 1.05)
	hit_s_ound.play()
	update_timers()
	_whiteness = minf(_whiteness + WHITE_PER_HIT, 1.0)
	self.texture = FOX_DEAD
	hurt_timer.start()
	pass # Replace with function body.
	
func die():
	mouse_down.stop_shooting()
	fox_timer.stop()
	spike_timer.stop()
	_move_tween.pause()
	self.texture = FOX_DEAD
	for child in projectiles.get_children():
		child.queue_free()
	self.material = null
	progress_bar.visible = false
	GameManager.music.stop()
	await get_tree().create_timer(1).timeout
	glitch_sprite_2.visible = true
	glitch_sound.play()
	await glitch_sound.finished
	self.visible = false
	cheese.position = self.position
	cheese.visible = true
	cheese.modulate *= 2
	cheese.scale *= 3.0
	await get_tree().create_timer(1).timeout
	var tween = create_tween()
	glimmer.play()
	tween.tween_property(cheese, "global_position", Vector2(cheese.global_position.x, mouse_down.global_position.y), 4)
	
func update_timers():
	var progress = progress_bar.value / progress_bar.max_value
	spike_timer.wait_time = lerp(min_spike, max_spike, progress)
	fox_timer.wait_time = lerp(min_fox, max_fox, progress)
	
func _ready():
	get_parent().restart_requested.connect(_on_restart)
	await get_parent().level_ready
	start_moving()
	fox_timer.start()
	spike_timer.start()
	
func _on_restart():
	fox_timer.stop()
	spike_timer.stop()
	_move_tween.pause()
	await get_parent().level_ready
	progress_bar.value = 150
	_move_tween.play()
	fox_timer.start(max_fox)
	spike_timer.start(max_spike)
	
func spawn_spike():
	var sb = SPIKES_BOSS.instantiate()
	projectiles.add_child(sb)
	sb.position = self.position + Vector2(0, 70)
	
func spawn_fox():
	var fp = FOX_PROJECTILE.instantiate()
	fp.position = self.position
	fp.position.x = randf_range(min, max)
	projectiles.add_child(fp)
	
func _process(delta: float) -> void:
	if material == null:
		return
	_whiteness = clamp(_whiteness - delta * 1.8, 0, 1.0)
	material.set_shader_parameter("whiteness", _whiteness)
	
func start_moving() -> void:
	_move_tween = create_tween().set_loops()
	_move_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	_move_tween.tween_property(self, "position:x", max, speed)
	_move_tween.tween_property(self, "position:x", min, speed)

func _on_hurt_timer_timeout() -> void:
	self.texture = FOX_DOWN_MEAN
	pass # Replace with function body.


func _on_spike_timer_timeout() -> void:
	spawn_spike()
	pass # Replace with function body.


func _on_fox_timer_timeout() -> void:
	spawn_fox()
	pass # Replace with function body.
