extends HSlider

@export var bus_name: String

@onready var bus_index = AudioServer.get_bus_index(bus_name)


func _on_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
