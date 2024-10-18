extends Area2D

@export var tooltip_text: String


func _on_mouse_entered() -> void:
	SignalBus.show_tooltip.emit(tooltip_text)


func _on_mouse_exited() -> void:
	SignalBus.hide_tooltip.emit()
