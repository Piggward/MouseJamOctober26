extends Control
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var gpu_particles_2d_2: GPUParticles2D = $GPUParticles2D2

func _ready():
	gpu_particles_2d.emitting = true
	gpu_particles_2d_2.emitting = true
	if not GameManager.start:
		GameManager.music.play()
		GameManager.start = true
