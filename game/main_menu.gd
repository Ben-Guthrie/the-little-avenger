extends MarginContainer

signal new_game
signal continue_game

func _ready() -> void:
	if Game.main_scene and Game.main_scene.current_level != 1:
		$Control/HBoxContainer/ContinueButton.show()
	SignalBus.allow_continue.connect($Control/HBoxContainer/ContinueButton.show)
	SignalBus.no_continue.connect($Control/HBoxContainer/ContinueButton.hide)

func _on_new_game_button_pressed() -> void:
	new_game.emit()


func _on_options_button_pressed() -> void:
	SignalBus.open_options.emit()


func _on_continue_button_pressed() -> void:
	continue_game.emit()


func _on_credits_button_pressed() -> void:
	SignalBus.open_credits.emit()
