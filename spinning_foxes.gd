extends Node2D

@export var radius = 50
@export var ring_amount = 7
@export var dir = 1
@export var speed = 1.0
@export var time := 0.0
const SPINNING_FOX = preload("uid://cc4x2rgafwyel")
const BUBBLE_2 = preload("uid://bdaid52f3ttxl")

func _ready():
	var level:Level = get_tree().get_first_node_in_group("Level")
	await level.level_ready
	rotation = deg_to_rad(radius * 4)
	await get_tree().create_timer(time).timeout
	for i in ring_amount - 2:
		var sprite = SPINNING_FOX.instantiate()
		sprite.target_position = Vector2(0, -radius).rotated((deg_to_rad(360) / ring_amount) * i)
		add_child(sprite)
		var audio = AudioStreamPlayer2D.new()
		audio.stream = BUBBLE_2
		audio.pitch_scale = randf_range(0.92, 1.08)
		get_parent().add_child(audio)
		audio.play()
		await get_tree().create_timer(0.05).timeout

		
func _process(delta: float) -> void:
	self.rotation += delta * dir * speed
