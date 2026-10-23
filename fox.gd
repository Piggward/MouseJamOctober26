extends AnimatedSprite2D

@export var start_move = 1
@export var start_dir = 1
@onready var path: Line2D = $FoxPath
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

var move = 1
var dir = null
var level: Level

func _ready():
	if not path.closed:
		move = start_move
		dir = start_dir
	level = get_tree().get_first_node_in_group("Level")
	await level.level_ready
	_move()

func _move():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	var go = get_next_dir()
	tween.tween_property(self, "position", position + go * Vector2(64, 32), 0.3)
	await tween.finished
	increase_move()
	go = get_next_dir()
	await get_tree().create_timer(0.25).timeout
	animation = "down" if go == Vector2.DOWN else "left" if go == Vector2.LEFT else "right" if go == Vector2.RIGHT else "up"
	await get_tree().create_timer(0.25).timeout
	_move()
	
func increase_move():
	if path.closed:
		move = wrap(move+1, 0, path.points.size())
		return
	else:
		move += dir
		if move == 0 or move == path.points.size() - 1:
			dir *= -1
		return
	pass
	
func get_last_pos():
	if path.closed:
		return wrap(move-1, 0, path.points.size())
	else:
		if move == 0:
			return 1
		if move == path.points.size() - 1:
			return move - 1
		return move - dir
	pass
	
func get_next_dir():
	var last_pos = get_last_pos()
	var pos = path.points[move] - path.points[last_pos]
	var go = Vector2.ZERO
	if abs(pos.x) > abs(pos.y):
		go = Vector2.LEFT if pos.x < 0 else Vector2.RIGHT
	if abs(pos.y) > abs(pos.x):
		go = Vector2.UP if pos.y < 0 else Vector2.DOWN
	return go


func _on_area_2d_area_entered(area: Area2D) -> void:
	audio.play(0.1)
	pass # Replace with function body.
