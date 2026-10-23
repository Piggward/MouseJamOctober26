extends TileMapLayer

var keep_randomizing = false

func _ready() -> void:
	randomize_tiles()
	
func set_randomizing(value: bool):
	keep_randomizing = value
	if value:
		randomize_tile()

func randomize_tiles() -> void:
	var source_id := tile_set.get_source_id(8)
	var source := tile_set.get_source(source_id) as TileSetAtlasSource
	var tiles: Array[Vector2i] = []
	for i in source.get_tiles_count():
		tiles.append(source.get_tile_id(i))
		

	for cell in get_used_cells():
		set_cell(cell, source_id, tiles.pick_random())
		
	randomize_tile()

func randomize_tile():
	var source_id := tile_set.get_source_id(8)
	var source := tile_set.get_source(source_id) as TileSetAtlasSource
	var tiles: Array[Vector2i] = []
	for i in source.get_tiles_count():
		tiles.append(source.get_tile_id(i))
		
	var cell = get_used_cells().pick_random()
	var cell2 = get_used_cells().pick_random()
	set_cell(cell, source_id, tiles.pick_random())
	set_cell(cell2, source_id, tiles.pick_random())
		
	if not keep_randomizing:
		return
	await get_tree().create_timer(0.1).timeout
	randomize_tile()
