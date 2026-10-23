extends Level
class_name RotatableLevel

@onready var camera: Camera2D = $Camera2D
@onready var check_point: Node2D = $FloorObjects/CheckPoint
@onready var mouse_down: RigidBody2D = $MouseDown
@onready var glitch_sprite: Sprite2D = $GlitchSprite
@export var gravity = 0.5

var rotate_speed = 1.5
var angle = deg_to_rad(0)
var is_ready = false

func _ready():
	super()
	mouse_down.gravity_scale = 0.0
	check_point.checkpoint_reached.connect(func(): respawn_point = check_point.global_position)
	level_ready.connect(_on_ready)
	
func _on_ready():
	await get_tree().create_timer(0.5).timeout
	glitch_sprite.visible = true
	await get_tree().create_timer(2.0).timeout
	glitch_sprite.visible = false
	mouse_down.gravity_scale = gravity
	is_ready = true
		
func _physics_process(delta):
	if not is_ready:
		return
	angle -= Input.get_axis("ui_left", "ui_right") * rotate_speed * delta
	camera.rotation = angle
	PhysicsServer2D.area_set_param(
		get_viewport().find_world_2d().space,
		PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR,
		Vector2.DOWN.rotated(angle))
