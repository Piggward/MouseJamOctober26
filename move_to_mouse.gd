extends AnimatedSprite2D
class_name MoveToMouse

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var move_component: MoveComponent = $MoveComponent

var tile_size = Vector2(16 * 8, 16*4)

var dead = false
var cd = false

var mouse_pos: Vector2

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	var level:Level = get_tree().get_first_node_in_group("Level")
	await level.level_ready
	process_mode = Node.PROCESS_MODE_INHERIT
	mouse_pos = get_global_mouse_position()
	tile_size *= 0.5
	
	
func _process(delta: float) -> void:
	if dead:
		self.position.y -= 100 * delta
		self.modulate.a -= delta
		if modulate.a <= 0:
			self.position = get_tree().get_first_node_in_group("Level").respawn_point
			self.modulate.a = 1.0
			dead = false
			animation = "down"
		return
		
	var mouse = get_global_mouse_position()
	if mouse != mouse_pos:
		mouse_pos = mouse
		self.position = position.move_toward(mouse_pos, 700 * delta)
		return
		
	if cd:
		return
	var x_dir = Input.get_axis("ui_left", "ui_right")
	var y_dir = Input.get_axis("ui_up", "ui_down")
	
	if x_dir != 0:
		try_move(Vector2(tile_size.x * x_dir, 0))
		return
		
	if y_dir != 0:
		try_move(Vector2(0, tile_size.y * y_dir))
		return
		
func try_move(pos):
	var success = move_component.move(pos)
	if success:
		set_cd()
		var dir = "up" if pos.y < 0 else "down" if pos.y > 0 else "left" if pos.x < 0 else "right" if pos.x > 0 else "error"
		if dir == "error":
			return
		animation = dir
		gpu_particles_2d.rotation = pos.angle()
		gpu_particles_2d.restart()
	
func set_cd():
	cd = true
	await get_tree().create_timer(move_component.move_cd).timeout
	cd = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	await get_tree().create_timer(0.1).timeout
	dead = true
	animation = "die"
	pass # Replace with function body.
