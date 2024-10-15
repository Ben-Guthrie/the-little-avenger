extends VBoxContainer

class_name HauntOption

signal option_clicked
signal haunted(energy_cost: int)

@export var haunt_target: Node
@export var energy_cost = 1

func _ready():
	if energy_cost > 1:
		for i in energy_cost - 1:
			var icon = $HBoxContainer/ColorRect.duplicate()
			$HBoxContainer.add_child(icon)
	check_if_disabled()
	SignalBus.energy_updated.connect(check_if_disabled)

func check_if_disabled():
	if Game.haunt_energy < energy_cost:
		$Button.disabled = true

func _on_button_pressed() -> void:
	option_clicked.emit()
	haunt()
	
func haunt():
	pass
