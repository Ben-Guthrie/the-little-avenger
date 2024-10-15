extends Control

signal start
signal reset

func update_energy():
	var energy_icons = $VBoxContainer.get_children()
	for i in range(len(energy_icons)):
		if i < Game.haunt_energy:
			energy_icons[i].show()
		else:
			energy_icons[i].hide()

func _ready() -> void:
	SignalBus.energy_updated.connect(update_energy)
	for child in $Highlights.get_children():
		if child is ColorRect:
			child.hide()
	SignalBus.reset.connect($StartButton.show)

func highlight_buttons():
	$Highlights/AnimationPlayer.play("flash_buttons")

func highlight_energy():
	$Highlights/AnimationPlayer.play("flash_energy")

func stop_highlight():
	$Highlights/AnimationPlayer.stop()


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start.emit()


func _on_reset_button_pressed() -> void:
	SignalBus.reset.emit()
