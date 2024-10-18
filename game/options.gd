extends ColorRect

func _ready() -> void:
	SignalBus.open_options.connect(show)

func _on_close_button_pressed() -> void:
	hide()
	
