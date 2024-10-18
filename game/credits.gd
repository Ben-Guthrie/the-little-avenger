extends Control


func _ready() -> void:
	SignalBus.open_credits.connect(show)



func _on_close_button_pressed() -> void:
	hide()
