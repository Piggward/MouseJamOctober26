extends AnimatedSprite2D
class_name Mouse

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var move_component: MoveComponent = $MoveComponent
@onready var move: AudioStreamPlayer2D = $Move

var tile_size = Vector2(16 * 8, 16*4)

var dead = false
var cd = false

func _ready():
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
		move.pitch_scale = randf_range(3.5, 3.8)
		move.play(0.6)
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
