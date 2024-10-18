extends PopupMenu

func _ready() -> void:
	SignalBus.open_menu.connect(show)


func _on_id_pressed(id: int) -> void:
	print("menu pressed:", id)
	if id == 0:
		return
	elif id == 1:
		SignalBus.open_options.emit()
	elif id == 2:
		SignalBus.return_to_menu.emit()
	hide()


func _on_index_pressed(index: int) -> void:
	print("index pressed: ", index)
