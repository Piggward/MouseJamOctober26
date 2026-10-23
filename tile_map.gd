extends TileMapLayer
class_name CustomTileMapLayer

@export var drop_height := 600.0
@export var min_drop_time := 1.4
@export var max_drop_time := 0.7
@export var stagger := 0.004
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

signal map_loaded

func _ready():
	# Remember every tile, then empty the layer.
	var tiles := []
	for cell in get_used_cells():
		tiles.append({
			"cell": cell,
			"source": get_cell_source_id(cell),
			"atlas": get_cell_atlas_coords(cell),
			"alt": get_cell_alternative_tile(cell),
		})
	clear()

	# Back rows first, so tiles in front land on top of them.
	tiles.sort_custom(func(a, b): return a.cell.y < b.cell.y or (a.cell.y == b.cell.y and a.cell.x < b.cell.x))

	for i in tiles.size():
		_drop(tiles[i], i * stagger, i == tiles.size() - 1)
		

func _drop(tile: Dictionary, delay: float, last: bool) -> void:
	var source := tile_set.get_source(tile.source) as TileSetAtlasSource
	if source == null:
		set_cell(tile.cell, tile.source, tile.atlas, tile.alt)
		return

	var sprite := Sprite2D.new()
	sprite.texture = source.texture
	sprite.region_enabled = true
	sprite.region_rect = source.get_tile_texture_region(tile.atlas)
	var target := map_to_local(tile.cell)
	sprite.position = target - Vector2(0, drop_height)
	sprite.modulate.a = 0.0
	add_child(sprite)

	var tween := create_tween()
	tween.tween_interval(delay)
	var drop_time = randf_range(min_drop_time, max_drop_time)
	tween.tween_property(sprite, "position", target, drop_time).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(sprite, "modulate:a", 1.0, drop_time * 0.3)
	get_tree().create_timer(drop_time * 0.4).timeout.connect(func(): 
		audio_stream_player_2d.play())
	get_tree().create_timer(drop_time * 0.7).timeout.connect(func(): 
		audio_stream_player_2d.play())
	tween.tween_callback(func():
		set_cell(tile.cell, tile.source, tile.atlas, tile.alt)
		sprite.queue_free()
		audio_stream_player_2d.play())
	if last:
		await tween.finished
		map_loaded.emit()
