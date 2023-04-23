@tool
extends StaticBody2D


@export_enum("Blue", "Red") var color = "Blue":
	set = set_color

@onready var sprite = get_node("Sprite2D")
@onready var coll_shape = get_node("CollisionShape2D")


func _ready():
	pass


func _process(delta):
	pass


func set_color(new_color: String):
	color = new_color
	if is_inside_tree():
		if color == "Blue":
			sprite.frame = 0
			sprite.position = Vector2(-4, -30)
		elif color == "Red":
			sprite.frame = 1
			sprite.position = Vector2(-2, -30)
