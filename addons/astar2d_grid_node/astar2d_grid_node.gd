@tool
extends Node2D


var grid: AStarGrid2D = AStarGrid2D.new()

@export_group("")
@export var grid_size: Vector2i = Vector2i(32, 32):
	set = set_grid_size, get = get_grid_size
@export var cell_size: Vector2 = Vector2(16, 16):
	set = set_cell_size, get = get_cell_size
@export var disabled_points: Array[Vector2i] = []:
	set = set_disabled_points, get = get_disabled_points
@export var enable_grid_during_play: bool = false:
	set = set_enable_grid_during_play

@export_group("Debug Colors")
@export var _enabled_point_fill_color: Color = Color.SALMON:
	set = _set_enabled_point_fill_color
@export var _enabled_point_border_color: Color = Color.WHITE:
	set = _set_enabled_point_border_color
@export var _disabled_point_fill_color: Color = Color.SLATE_GRAY:
	set = _set_disabled_point_fill_color
@export var _disabled_point_border_color: Color = Color.WHITE:
	set = _set_disabled_point_border_color


func _ready():
	_update_grid()


func _process(delta):
	pass


func _draw():
	if Engine.is_editor_hint() or enable_grid_during_play:
		_draw_points()


func _draw_points() -> void:
	for x in range(grid.size.x):
		for y in range(grid.size.y):
			var point: Vector2i = Vector2i(x, y)
			if grid.is_point_solid(point):
				_draw_disabled_point(grid.get_point_position(point))
			else:
				_draw_point(grid.get_point_position(point))


func _draw_point(point: Vector2i) -> void:
	draw_circle(point, 2.5, _enabled_point_border_color)
	draw_circle(point, 2, _enabled_point_fill_color)


func _draw_disabled_point(point: Vector2i) -> void:
	draw_circle(point, 2.5, _disabled_point_border_color)
	draw_circle(point, 2, _disabled_point_fill_color)


func _update_grid() -> void:
	if not grid_size == grid.size:
		grid.size = grid_size
	if not cell_size == grid.cell_size:
		grid.cell_size = cell_size
	if grid.is_dirty():
		grid.update()
	_redraw_grid()


func _set_enabled_point_border_color(new_value: Color) -> void:
	_enabled_point_border_color = new_value
	_redraw_grid()


func _set_enabled_point_fill_color(new_value: Color) -> void:
	_enabled_point_fill_color = new_value
	_redraw_grid()


func _set_disabled_point_border_color(new_value: Color) -> void:
	_disabled_point_border_color = new_value
	_redraw_grid()


func _set_disabled_point_fill_color(new_value: Color) -> void:
	_disabled_point_fill_color = new_value
	_redraw_grid()


func _redraw_grid() -> void:
	if Engine.is_editor_hint() or enable_grid_during_play:
		queue_redraw()


func set_enable_grid_during_play(new_value: bool) -> void:
	enable_grid_during_play = new_value
	_redraw_grid()


func set_grid_size(new_value: Vector2i) -> void:
	grid_size = new_value
	_update_grid()


func get_grid_size() -> Vector2i:
	return (grid_size)


func set_cell_size(new_value: Vector2) -> void:
	cell_size = new_value
	_update_grid()


func get_cell_size() -> Vector2:
	return (cell_size)


func set_disabled_points(new_value: Array[Vector2i]) -> void:
	for old_point in disabled_points:
		if not old_point in new_value:
			grid.set_point_solid(old_point, false)
	disabled_points = new_value
	for point in disabled_points:
		grid.set_point_solid(point)
	_redraw_grid()


func get_disabled_points() -> Array[Vector2i]:
	return (disabled_points)


func get_nearest_id(pos: Vector2) -> Vector2i:
	var id: Vector2i

	id = Vector2i(
		clamp(round(pos.x / (cell_size.x * 1.0)), 0, grid.size.x - 1),
		clamp(round(pos.y / (cell_size.y * 1.0)), 0, grid.size.y - 1)
	)
	id.clamp(Vector2.ZERO, grid.size)
	return (id)


func calculate_point_path(from: Vector2, to: Vector2) -> Array:
	var path: Array = []
	var from_id: Vector2i = get_nearest_id(from)
	var to_id: Vector2i = get_nearest_id(to)

	path = Array(grid.get_point_path(from_id, to_id))
	return (path)


func calculate_point_path_by_id(from_id: Vector2i, to_id: Vector2i) -> Array:
	var path: Array = []

	path = Array(grid.get_point_path(from_id, to_id))
	return (path)


func calculate_id_path(from: Vector2, to: Vector2) -> Array:
	var path: Array = []
	var from_id: Vector2i = get_nearest_id(from)
	var to_id: Vector2i = get_nearest_id(to)

	path = Array(grid.get_id_path(from_id, to_id))
	return (path)


func calculate_id_path_by_id(from_id: Vector2i, to_id: Vector2i) -> Array:
	var path: Array = []

	path = Array(grid.get_id_path(from_id, to_id))
	return (path)


func disable_point(id: Vector2i):
	grid.set_point_solid(id)
	_redraw_grid()


func enable_point(id: Vector2i):
	grid.set_point_solid(id, false)
	_redraw_grid()
