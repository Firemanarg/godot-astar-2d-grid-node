@tool
extends Node2D
class_name AStar2DGridNode


##
## A simple node implementation for the abstract class [AStarGrid2D], used
## for a better performance pathfinding.
##
## This is a simple implementation of the [AStarGrid2D] as a node. It is
## very useful to easily create grids and use them as paths. Some functions
## are provided to help the pathfinding process.
##


@export_group("")
@export var grid_size: Vector2i = Vector2i(32, 32):
	set = set_grid_size, get = get_grid_size
@export var cell_size: Vector2 = Vector2(16, 16):
	set = set_cell_size, get = get_cell_size
@export var disabled_points: Array[Vector2i] = []:
	set = set_disabled_points, get = get_disabled_points

@export_group("Debug")

## Enable or disable debug view. If [code]false[/code], grid points
## will not be visible.[br]
## [br]- To change size of points, set [member debug_point_size] or
## [member debug_point_border_size].
## [br]- To change color of enabled points, set
## [member enabled_point_fill_color] or [member enabled_point_border_color].
## [br]- To change color of disabled points, set
## [member disabled_point_fill_color] or [member disabled_point_border_color].
@export var enable_debug: bool = true:
	set = set_enable_debug, get = get_enable_debug

## Enable or disable debug view during play (out of editor).
## If [code]true[/code], grid points will be visible only on editor.
## [br]In case of [member enable_debug] is [code]false[/code],
## this is ignored and debug view is always disabled.
@export var debug_editor_only: bool = true:
	set = set_debug_editor_only, get = get_debug_editor_only

## Size of debug point fill.
@export var debug_point_size: float = 2.0:
	set = set_debug_point_size, get = get_debug_point_size

## Size of debug point border stroke.
@export var debug_point_border_size: float = 0.5:
	set = set_debug_point_border_size, get = get_debug_point_border_size


@export var enabled_point_fill_color: Color = Color.SALMON:
	set = set_enabled_point_fill_color, get = get_enabled_point_fill_color
@export var enabled_point_border_color: Color = Color.WHITE:
	set = set_enabled_point_border_color, get = get_enabled_point_border_color
@export var disabled_point_fill_color: Color = Color.SLATE_GRAY:
	set = set_disabled_point_fill_color, get = get_disabled_point_fill_color
@export var disabled_point_border_color: Color = Color.WHITE:
	set = set_disabled_point_border_color, get = get_disabled_point_border_color

var grid: AStarGrid2D = AStarGrid2D.new():
	set = set_grid, get = get_grid


# ------------------------------------------------------------------------------
# --- Built_in functions -------------------------------------------------------
# ------------------------------------------------------------------------------

func _ready():
	_update_grid()


func _process(delta):
	pass


func _draw():
	if enable_debug:
		if Engine.is_editor_hint() or not debug_editor_only:
			_draw_points()


# ------------------------------------------------------------------------------
# --- Public functions ---------------------------------------------------------
# ------------------------------------------------------------------------------

## Returns the nearest valid id of given coords. If coord is out of grid,
## a border nearest point inside the grid is returned.
## [br][br][b]See also:[/b]
## [method get_nearest_real_id].
func get_nearest_id(pos: Vector2) -> Vector2i:
	var id: Vector2i = get_nearest_real_id(pos)

	id.x = clamp(id.x, 0, grid_size.x - 1)
	id.y = clamp(id.y, 0, grid_size.y - 1)
	return (id)


## Return the nearest id of given coords, even if the coord is out of grid
## (return value can contain negative values).
## [br][br][b]See also:[/b]
## [method get_nearest_id].
func get_nearest_real_id(pos: Vector2) -> Vector2i:
	var offset_pos: Vector2 = pos - global_position
	var id: Vector2i

	id = Vector2i(round(offset_pos / cell_size))
	return (id)


## Calculate and return a path of points as an [PackedVector2Array],
## considering [code]from[/code] as start point and [code]to[/code] as
## destination point. Both arguments must use global coordinates. Each point
## of path is a [Vector2] containing the global coordinates of the grid point.
## [br][br][b]See also:[/b]
## [method calculate_point_path_by_id].
func calculate_point_path(from: Vector2, to: Vector2) -> PackedVector2Array:
	var path: PackedVector2Array = []
	var from_id: Vector2i = get_nearest_id(from)
	var to_id: Vector2i = get_nearest_id(to)

	path = grid.get_point_path(from_id, to_id)
	return (path)


## Calculate and return a path of points as an [Array], considering
## [code]from_id[/code] as the id of start point in grid and
## [code]to_id[/code] as the id of destination point in grid. Each point of
## path is a [Vector2] containing the global coordinates of the grid point.
## [br][br]This function is equivalent to:
## [codeblock]
## calculate_point_path(get_nearest_id(from), get_nearest_id(to)
## [/codeblock]
## [br][br][b]See also:[/b]
## [method calculate_point_path], [method get_nearest_id],
## [method get_nearest_id].
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


func disable_point(id: Vector2i) -> void:
	grid.set_point_solid(id)
	if not id in disabled_points:
		disabled_points.append(id)
	_redraw_grid()


func enable_point(id: Vector2i) -> void:
	grid.set_point_solid(id, false)
	disabled_points.erase(id)
	_redraw_grid()


func disable_points(ids: Array[Vector2i]) -> void:
	for id in ids:
		grid.set_point_solid(id)
		disabled_points.erase(id)
	_redraw_grid()


func enable_points(ids: Array[Vector2i]) -> void:
	for id in ids:
		grid.set_point_solid(id, false)
		if not id in disabled_points:
			disabled_points.append(id)
	_redraw_grid()


## Return an [Array] of [Vector2i] containing the IDs of the points overlapped
## by given [code]rect[/code] (global coords).
func get_id_list_inside_rect(rect: Rect2, margin: float = 0.0) -> Array[Vector2i]:
	var margin_vec: Vector2 = Vector2(margin, margin)
	var ids: Array[Vector2i] = []
	var start_id: Vector2i = get_nearest_id(rect.position - margin_vec)
	var end_id: Vector2i = get_nearest_id(rect.end + margin_vec)

	for x in range(start_id.x, end_id.x + 1):
		for y in range(start_id.y, end_id.y + 1):
			var id: Vector2i = Vector2i(x, y)
			ids.append(id)
	return (ids)


## Return an [Array] of [Vector2i] containing the IDs of the points overlapped
## by given circle ([code]origin[/code] use global coords).
func get_id_list_inside_circle(origin: Vector2, radius: float,
		margin: float = 0.0) -> Array[Vector2i]:
	var radius_vec: Vector2 = Vector2(radius, radius)
	var margin_vec: Vector2 = Vector2(margin, margin)
	var ids: Array[Vector2i] = []
	var rect: Rect2 = Rect2(origin - radius_vec - margin_vec,
								2 * (radius_vec + margin_vec))
	var start_id: Vector2i = get_nearest_id(rect.position)
	var end_id: Vector2i = get_nearest_id(rect.end)

	for x in range(start_id.x, end_id.x + 1):
		for y in range(start_id.y, end_id.y + 1):
			var id: Vector2i = Vector2i(x, y)
			var pos: Vector2 = grid.get_point_position(id)
			var dist: float = origin.distance_to(pos)

			if dist <= radius + margin:
				ids.append(id)
	return (ids)


## Return a Rect2 with local coords.
func get_local_rect() -> Rect2:
	var rect: Rect2 = Rect2(Vector2(0, 0), Vector2(grid_size) * cell_size)
	return (rect)


## Return a Rect2 with global coords.
func get_global_rect() -> Rect2:
	var rect: Rect2 = Rect2(global_position, Vector2(grid_size) * cell_size)
	return (rect)


## Return the position of the point with given [code]id[/code].
func get_point_position(id: Vector2i) -> Vector2:
	return (grid.get_point_position(id))


# --- Getters and Setters ------------------------------------------------------

func set_enable_debug(new_value: bool) -> void:
	enable_debug = new_value
	_redraw_grid()


func get_enable_debug() -> bool:
	return (enable_debug)


func set_debug_editor_only(new_value: bool) -> void:
	debug_editor_only = new_value
	_redraw_grid()


func get_debug_editor_only() -> bool:
	return (debug_editor_only)


func set_debug_point_size(new_value: float) -> void:
	debug_point_size = new_value
	_redraw_grid()


func get_debug_point_size() -> float:
	return (debug_point_size)


func set_debug_point_border_size(new_value: float) -> void:
	debug_point_border_size = new_value
	_redraw_grid()


func get_debug_point_border_size() -> float:
	return (debug_point_border_size)


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


func set_enabled_point_border_color(new_value: Color) -> void:
	enabled_point_border_color = new_value
	_redraw_grid()


func get_enabled_point_border_color() -> Color:
	return (enabled_point_border_color)


func set_enabled_point_fill_color(new_value: Color) -> void:
	enabled_point_fill_color = new_value
	_redraw_grid()


func get_enabled_point_fill_color() -> Color:
	return (enabled_point_fill_color)


func set_disabled_point_border_color(new_value: Color) -> void:
	disabled_point_border_color = new_value
	_redraw_grid()


func get_disabled_point_border_color() -> Color:
	return (disabled_point_border_color)


func set_disabled_point_fill_color(new_value: Color) -> void:
	disabled_point_fill_color = new_value
	_redraw_grid()


func get_disabled_point_fill_color() -> Color:
	return (disabled_point_fill_color)


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


func set_grid(new_value: AStarGrid2D) -> void:
	grid = new_value
	_update_grid()


func get_grid() -> AStarGrid2D:
	return (grid)


# ------------------------------------------------------------------------------
# --- Private Functions --------------------------------------------------------
# ------------------------------------------------------------------------------


func _draw_points() -> void:
	for x in range(grid.size.x):
		for y in range(grid.size.y):
			var point: Vector2 = Vector2(x, y)

			if grid.is_point_solid(point):
				_draw_disabled_point(point * cell_size)
			else:
				_draw_point(point * cell_size)


func _draw_point(point: Vector2i) -> void:
	var border_size: float = debug_point_size + debug_point_border_size

	draw_circle(point, border_size, enabled_point_border_color)
	draw_circle(point, debug_point_size, enabled_point_fill_color)


func _draw_disabled_point(point: Vector2i) -> void:
	var border_size: float = debug_point_size + debug_point_border_size

	draw_circle(point, border_size, disabled_point_border_color)
	draw_circle(point, debug_point_size, disabled_point_fill_color)


func _update_grid() -> void:
	if not grid_size == grid.size:
		grid.size = grid_size
	if not cell_size == grid.cell_size:
		grid.cell_size = cell_size
	if not grid.offset == position:
		grid.offset = position
	if grid.is_dirty():
		grid.update()
	_redraw_grid()


func _redraw_grid() -> void:
	queue_redraw()
