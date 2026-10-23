extends Sprite2D

var speed = 1500

func _ready():
	await get_tree().create_timer(3).timeout
	self.queue_free()

func _process(delta: float) -> void:
	self.position.y -= speed * delta


func _on_area_2d_area_entered(area: Area2D) -> void:
	self.queue_free()
	pass # Replace with function body.
