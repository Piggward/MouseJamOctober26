extends Sprite2D

var was_visible = false
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	was_visible = self.visible
	
func _process(delta):
	if visible and not was_visible:
		audio_stream_player_2d.pitch_scale = randf_range(0.9, 1.1)
		audio_stream_player_2d.play()
	was_visible = visible
