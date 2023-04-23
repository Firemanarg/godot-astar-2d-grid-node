extends Node2D


@onready var astar_grid = get_node("AStar2DGridNode")
@onready var character = get_node("Character")
@onready var camera = get_node("Camera2D")


func _ready():
	pass


func _process(delta):
	pass


# Movement on mouse click
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var path: Array = astar_grid.calculate_point_path(
								character.global_position,
								get_global_mouse_position())
			character.move_along_path(path)
