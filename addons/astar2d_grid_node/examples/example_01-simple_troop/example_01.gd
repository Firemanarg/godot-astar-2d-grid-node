extends Node2D


@onready var astar_grid = get_node("AStar2DGridNode")
@onready var troop = get_node("SimpleTroop")
@onready var camera = get_node("Camera2D")


func _ready():
	pass


func _process(delta):
	pass


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var path: Array = astar_grid.calculate_point_path(
								troop.global_position,
								get_global_mouse_position())
			troop.set_movement_path(path)
