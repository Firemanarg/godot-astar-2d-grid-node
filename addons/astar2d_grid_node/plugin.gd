@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type(
		"AStar2DGridNode",
		"Node2D",
		preload("astar2d_grid_node.gd"),
		preload("grid_node_icon.svg"))
	pass


func _exit_tree():
	remove_custom_type("AStar2DGridNode")
	pass
