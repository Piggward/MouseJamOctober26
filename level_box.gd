extends TextureRect

const STAR = preload("uid://c2bgqfdhjfd3g")
const STAR_GREY = preload("uid://bpk7moor7yye3")

@onready var star_texture: TextureRect = $Control/Control/StarTexture
@onready var level_text: Label = $Control/LevelText
const GAME_START = preload("uid://gkm54a2eq7lb")
@onready var grid_container: GridContainer = get_tree().get_first_node_in_group("gridcontainer")
@onready var animation_player: AnimationPlayer = get_tree().get_first_node_in_group("anim")

@export var level_number: int
@onready var audio: AudioStreamPlayer2D = get_tree().get_first_node_in_group("audi")

func _ready():
	level_text.text = str(level_number)
	#check with game manager if level is completed
	var is_completed = GameManager.is_completed(level_number)
	
	star_texture.texture = STAR if is_completed else STAR_GREY
	

func _on_mouse_entered() -> void:
	if audio.stream == GAME_START:
		return
	audio.pitch_scale = randf_range(0.95, 1.05)
	audio.play()
	self_modulate = Color(1.5, 1.5, 1.5, 1.0)
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	self_modulate = Color.WHITE
	pass # Replace with function body.


func _on_button_pressed() -> void:
	audio.stream = GAME_START
	audio.pitch_scale = 1.0
	audio.play()
	animation_player.play("fade")
	await get_tree().create_timer(2.0).timeout
	GameManager.load_level(level_number)
	pass # Replace with function body.
