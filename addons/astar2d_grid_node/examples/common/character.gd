extends CharacterBody2D


@export var speed: int = 150

var _movement_path: Array = []

@onready var anim_player = get_node("AnimationPlayer")
@onready var sprite = get_node("Sprite2D")


func _ready():
	pass


func _physics_process(delta):
	var target: Vector2
	var direction: Vector2
	var has_moved: bool = false

	if not _movement_path.is_empty():
		target = _movement_path[0]
		direction = (target - global_position).normalized()
		velocity = direction * speed
		has_moved = not move_and_slide()
		if global_position.distance_to(target) < 3:
			_movement_path.pop_front()
	else:
		velocity = Vector2.ZERO
	if has_moved:
		anim_player.play("Walk")
		if velocity.x < 0:
			sprite.scale.x = -1 * abs(sprite.scale.x)
		else:
			sprite.scale.x = abs(sprite.scale.x)
	else:
		anim_player.play("Idle")


func move_along_path(path: Array):
	_movement_path = path


func get_movement_path() -> Array:
	return (_movement_path)
