extends Node2D
class_name Level

var tile_size = Vector2(16 * 8, 16*4)
@onready var tile_map: TileMapLayer = $TileMap
@onready var floor_objects: Node2D = $FloorObjects
@export var last_objects: Array[Node2D] = []
@onready var start_point: Marker2D = $StartPoint
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@export var level_number = 1
const WIN_MODULE = preload("uid://c5qi3x7or523t")
const THUDS = preload("uid://dh8fgndl71axk")
const MENU_MODULE = preload("uid://cud61e5v2gsxt")

var drop_height = 600
var respawn_point: Vector2
const STAR_PICKUP = preload("uid://d0vwru0qitcfg")

signal level_ready

func cheese_picked_up(cheese):
	win()
	return
	
func win():
	var w = WIN_MODULE.instantiate()
	w.level = level_number
	canvas_layer.add_child(w)
	GameManager.level_completed(level_number)
	self.process_mode = Node.PROCESS_MODE_DISABLED

func _ready():
	tile_size *= tile_map.scale
	respawn_point = start_point.position
	floor_objects.drop_complete.connect(_drop_rest)
	for c in last_objects:
		c.position.y -= drop_height
	if floor_objects.get_child_count() == 0:
		_drop_rest()
	
func _drop_rest():
	await get_tree().create_timer(0.5).timeout
	for i in last_objects:
		_drop(i)
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		var m = MENU_MODULE.instantiate()
		m.level = self.level_number
		canvas_layer.add_child(m)
		return
	
func _drop(node: Node2D) -> void:
	var tween := create_tween()
	tween.tween_property(node, "position", node.position + Vector2(0, drop_height), 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	await tween.finished
	level_ready.emit()
	var audio = AudioStreamPlayer2D.new()
	audio.stream = THUDS
	audio.pitch_scale = randf_range(3.5, 3.6)
	add_child(audio)
	audio.play()
