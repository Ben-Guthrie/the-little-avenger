extends Control

func _ready() -> void:
	SignalBus.cursor_pointer.connect(func (): mouse_default_cursor_shape = CURSOR_POINTING_HAND)
	SignalBus.cursor_arrow.connect(func (): mouse_default_cursor_shape = CURSOR_ARROW)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if Game.can_haunt:
			SignalBus.cancel.emit()
