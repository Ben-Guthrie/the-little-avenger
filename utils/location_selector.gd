extends Node2D

signal selected

func _on_node_2d_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		selected.emit()
		get_viewport().set_input_as_handled()
