extends Node

@onready var menu = $MainMenu

func _ready() -> void:
	SignalBus.return_to_menu.connect(_on_return_to_main)


func _on_main_menu_new_game() -> void:
	menu.queue_free()
	$Game.new_game.call_deferred()


func _on_main_menu_continue_game() -> void:
	menu.queue_free()
	$Game.continue_game.call_deferred()

func _on_return_to_main():
	$Game.hide()
	menu = preload("res://game/main_menu.tscn").instantiate()
	add_child(menu)
	move_child(menu, 1)
	menu.continue_game.connect(_on_main_menu_continue_game)
	menu.new_game.connect(_on_main_menu_new_game)
