@tool
extends Node2D


@onready var astar_grid = get_node("AStar2DGridNode")
@onready var character = get_node("Character")
@onready var camera = get_node("Camera2D")
@onready var obstacles = get_node("Obstacles")


func _ready():
	_disable_obstacles(1)


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


func _disable_obstacles(margin: float = 0.0) -> void:
	for obstacle in obstacles.get_children():
		_disable_obstacle(obstacle, margin)


func _disable_obstacle(obstacle: Node2D, margin: float = 0.0):
	if obstacle is PhysicsBody2D:
		var coll_shape: CollisionShape2D = obstacle.get_node("CollisionShape2D")
		var shape = coll_shape.shape
		var points: Array[Vector2i] = []

		if shape is CircleShape2D:
			# Call get_id_list_inside_circle to get all point ids inside a circle
			points = astar_grid.get_id_list_inside_circle(
						coll_shape.global_position,
						shape.radius, margin)

		elif shape is RectangleShape2D:
			var shape_rect: Rect2 = shape.get_rect()
			var rect: Rect2 = Rect2(
								shape_rect.position + coll_shape.global_position,
								shape_rect.size)

			# Call get_id_list_inside_rect to get all point ids inside a rectangle
			points = astar_grid.get_id_list_inside_rect(
						rect,
						margin)
		astar_grid.disable_points(points)
