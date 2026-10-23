extends Node2D
class_name MoveComponent

@onready var down_floor_cast: RayCast2D = $FloorRayCasts/DownCast
@onready var left_floor_cast: RayCast2D = $FloorRayCasts/LeftCast
@onready var right_floor_cast: RayCast2D = $FloorRayCasts/RightCast
@onready var up_floor_cast: RayCast2D = $FloorRayCasts/UpCast

@onready var down_obstacle_cast: RayCast2D = $ObstacleRayCasts/DownCast
@onready var left_obstacle_cast: RayCast2D = $ObstacleRayCasts/LeftCast
@onready var right_obstacle_cast: RayCast2D = $ObstacleRayCasts/RightCast
@onready var up_obstacle_cast: RayCast2D = $ObstacleRayCasts/UpCast


@export var move_cd = 0.3
@export var reverse = false

var parent

func _ready():
	parent = get_parent()

func move(pos: Vector2):
	if not can_move(pos) and not reverse:
		return false
		
	if can_move(pos) and reverse:
		return false
		
	if is_outside_viewport(parent.position + pos):
		return false
		
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(parent, "position", parent.position + pos, move_cd / 2)
	
	return true
	
func can_move(pos):
	if (not down_floor_cast.is_colliding() or down_obstacle_cast.is_colliding()) and pos.y > 0:
		return false
	if (not left_floor_cast.is_colliding() or left_obstacle_cast.is_colliding()) and pos.x < 0:
		return false
	if (not right_floor_cast.is_colliding() or right_obstacle_cast.is_colliding()) and pos.x > 0:
		return false
	if pos.y < 0 and (not up_floor_cast.is_colliding() or up_obstacle_cast.is_colliding()):
		return false
	return true
	
func is_outside_viewport(global_pos: Vector2) -> bool:
	var screen_pos := get_viewport().get_canvas_transform() * global_pos
	return not get_viewport_rect().has_point(screen_pos)
