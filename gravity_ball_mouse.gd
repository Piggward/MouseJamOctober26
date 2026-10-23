extends RigidBody2D

var tile_size = Vector2(16 * 8, 16*4)

var dead = false
var cd = false
const MOUSE_DEAD = preload("uid://bbvldj7v4ayf")
const MOUSE_DOWN_2X = preload("uid://j62xu0bms81g")
@onready var sprite_2d: Sprite2D = $Sprite2D
signal died
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var teleport_to = null
var level: Level
var _prev_velocity := Vector2.ZERO

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if teleport_to != null:
		self.modulate.a = 1.0
		state.transform = Transform2D(rotation, teleport_to)
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0
		sprite_2d.texture = MOUSE_DOWN_2X
		dead = false
		teleport_to = null

func _ready():
	tile_size *= 0.5
	collision_shape_2d.disabled = true
	level = get_tree().get_first_node_in_group("Level")
	await level.level_ready
	collision_shape_2d.disabled = false
	

func _physics_process(_delta: float) -> void:
	_prev_velocity = linear_velocity
	
func _process(delta: float) -> void:
	if dead and teleport_to == null:
		self.position.y -= 100 * delta
		self.modulate.a -= delta
		if modulate.a <= 0:
			teleport_to = get_parent().respawn_point
		return

func _on_area_2d_area_entered(area: Area2D) -> void:
	await get_tree().create_timer(0.1).timeout
	dead = true
	sprite_2d.texture = MOUSE_DEAD
	pass # Replace with function body.


func _on_body_entered(body: Node) -> void:
	var impact := (_prev_velocity - linear_velocity).length()
	if impact < 2.0:
		return
	audio_stream_player_2d.pitch_scale = randf_range(2.8, 3.2)
	audio_stream_player_2d.play()
	pass # Replace with function body.
