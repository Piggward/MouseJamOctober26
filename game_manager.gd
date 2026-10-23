extends Node

const LEVEL_1 = preload("uid://b4ye6csu0oto8")
const LEVEL_2 = preload("uid://uxp7ccxki3s3")
const LEVEL_3 = preload("uid://bse8j8k5jw1s2")
const LEVEL_4 = preload("uid://mh44hmm22lc8")
const LEVEL_5 = preload("uid://bet1t5nkqshv6")
const LEVEL_6 = preload("uid://dl88x18eg32xx")
const CARPE_DIEM = preload("uid://b5rgoeiw6s4sm")
const MISTAKE_THE_GETAWAY = preload("uid://c204je22h4thf")
const LEVEL_7 = preload("uid://6imipd4pa7e")
const LEVEL_OVERVIEW = preload("uid://jrdsqk86t8ea")

var levels = [
	LEVEL_1,
	LEVEL_2,
	LEVEL_3,
	LEVEL_4,
	LEVEL_5,
	LEVEL_6,
	LEVEL_7
]

var completed_levels = []
var music: AudioStreamPlayer
var start = false
var slow_tween: Tween

func get_level_count():
	return levels.size()

func _ready():
	slow_tween = create_tween()
	music = AudioStreamPlayer.new()
	add_child(music)
	music.stream = CARPE_DIEM
	music.volume_db = -15
	music.bus = "Music"
	music.process_mode = Node.PROCESS_MODE_ALWAYS
	
func slow_music():
	slow_tween = create_tween()
	slow_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).tween_property(music, "pitch_scale", 0.0, 12.0)

func play_boss_music():
	music.stream = MISTAKE_THE_GETAWAY
	music.pitch_scale = 1.0
	music.play()

func load_overview():
	get_tree().change_scene_to_packed(LEVEL_OVERVIEW)
	slow_tween.stop()
	music.pitch_scale = 1.0
	if music.stream != CARPE_DIEM or not music.playing:
		music.stream = CARPE_DIEM
		music.play()

func load_level(l: int):
	slow_tween.stop()
	music.pitch_scale = 1.0
	var level = levels[l-1]
	if music.stream != CARPE_DIEM:
		music.stream = CARPE_DIEM
	get_tree().change_scene_to_packed(level)
	
func level_completed(l: int):
	if completed_levels.has(l):
		return
	completed_levels.append(l)
	
func is_completed(l: int):
	return completed_levels.has(l)
	
