extends AnimatedSprite2D

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var move_component: MoveComponent = $MoveComponent
@onready var glitch_sprite: Sprite2D = $GlitchSprite
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

var tile_size = Vector2(16 * 8, 16*4)
var dead = false
var cd = false

func _ready():
	tile_size *= 0.5
	glitch_sprite.visible = false
	
func _process(delta: float) -> void:
	if dead:
		self.position.y -= 100 * delta
		self.modulate.a -= delta
		if modulate.a <= 0:
			self.queue_free()
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
	pos *= -1
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
	glitch_sprite.visible = true
	await get_tree().create_timer(move_component.move_cd).timeout
	cd = false
	animation = "cheese"
	glitch_sprite.visible = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	var level: Level = get_tree().get_first_node_in_group("Level")
	level.cheese_picked_up(self)
	self.queue_free()
	pass # Replace with function body.
