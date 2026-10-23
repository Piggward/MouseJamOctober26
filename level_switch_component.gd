extends Node2D

const scenes: Array[String] = [
	"res://level_1.tscn",
	"res://level_2.tscn",
	"res://level_3.tscn",
	"res://level_4.tscn",
	"res://level_5.tscn",
	"res://level_6.tscn",
	"res://level_7.tscn",
	"res://level_8.tscn"
]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("1"):
		get_tree().change_scene_to_file(scenes[0])
	if Input.is_action_just_pressed("2"):
		get_tree().change_scene_to_file(scenes[1])
	if Input.is_action_just_pressed("3"):
		get_tree().change_scene_to_file(scenes[2])
	if Input.is_action_just_pressed("4"):
		get_tree().change_scene_to_file(scenes[3])
	if Input.is_action_just_pressed("5"):
		get_tree().change_scene_to_file(scenes[4])
	if Input.is_action_just_pressed("6"):
		get_tree().change_scene_to_file(scenes[5])
	if Input.is_action_just_pressed("7"):
		get_tree().change_scene_to_file(scenes[6])
