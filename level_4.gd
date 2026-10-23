extends Level
@onready var glitch_sprite: Sprite2D = $GlitchSprite
@onready var mouse_down: Mouse = $MouseDown
@onready var texture_rect: TextureRect = $CanvasLayer/Control2/MarginContainer/HBoxContainer/TextureRect2

func win():
	super()
	texture_rect.visible= false
	
func _ready():
	super()
	level_ready.connect(glitching)
	
func glitching():
	glitch_sprite.visible = true
	await get_tree().create_timer(1.0).timeout
	mouse_down.position = start_point.position
	glitch_sprite.visible = false
	
