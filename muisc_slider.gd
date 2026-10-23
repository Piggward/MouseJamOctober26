extends HSlider

var max_volume: float

func _ready():
	var db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	value = db_to_linear(db)

func _on_value_changed(value: float) -> void:
	var volume_db: float = linear_to_db(value)

	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_db)
	pass # Replace with function body.
