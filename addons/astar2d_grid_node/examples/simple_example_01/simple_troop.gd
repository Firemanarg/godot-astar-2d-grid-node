extends CharacterBody2D


const SPEED = 300.0

var _movement_path: Array = []


func _ready():
	pass


func _physics_process(delta):
	var target: Vector2
	var direction: Vector2

	if not _movement_path.is_empty():
		target = _movement_path[0]
		direction = (target - global_position).normalized()
		velocity = direction * SPEED
		move_and_slide()
	if global_position.distance_to(target) < 3:
		_movement_path.pop_front()


func set_movement_path(new_path: Array):
	_movement_path = new_path


func get_movement_path() -> Array:
	return (_movement_path)
