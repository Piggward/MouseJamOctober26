extends AnimatedSprite2D
const PROJECTILE = preload("uid://cguy7hxu1w462")
@onready var projectiles: Node2D = $"../Projectiles"
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var hit_timer: Timer = $HitTimer
@onready var star: AudioStreamPlayer2D = $star
@onready var h_box_container: VBoxContainer = $"../HBoxContainer"

@export var speed = 500
@export var cdt = 0.1
var cd = false
var go = false
var lives = 3
var finish = false

func _ready():
	await get_parent().level_ready
	go = true
	get_parent().restart_requested.connect(_on_restart)
	
func _on_restart():
	go = false
	await get_parent().level_ready
	self.lives = 3
	for child in h_box_container.get_children():
		child.visible = true
	go = true

func _process(delta):
	if not go:
		return
	var x_dir = Input.get_axis("ui_left", "ui_right")
	var y_dir = Input.get_axis("ui_up", "ui_down")
	
	self.position.x += x_dir * delta * speed
	position.x = clamp(position.x, 150, 1000)
		
	if y_dir == -1 and not finish:
		shoot()
		
		
func shoot():
	if cd:
		return
	star.play(1.85)
	star.pitch_scale = randf_range(2.1, 2.3)
	set_cd()
	var p = PROJECTILE.instantiate()
	projectiles.add_child(p)
	p.global_position = global_position + Vector2(0, -50)
	return
	
func set_cd():
	cd = true
	await get_tree().create_timer(cdt).timeout
	cd = false

func stop_shooting():
	finish = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if lives == 0 or finish:
		return
	Engine.time_scale = 0.1
	await get_tree().create_timer(0.05).timeout
	audio_stream_player_2d.play(0.7)
	lives = clamp(lives-1, 0, 3)
	h_box_container.get_child(lives).visible = false
	if lives == 0:
		resolve_death()
	hit_timer.start()
	pass # Replace with function body.

func resolve_death():
	Engine.time_scale = 1.0
	get_parent().restart_requested.emit()
	

func _on_hit_timer_timeout() -> void:
	print("resetting engine scale")
	Engine.time_scale = 1.0
	pass # Replace with function body.
