extends VBoxContainer

signal selected
signal haunted(energy_cost: int)

func _ready() -> void:
	for option in $Options.get_children():
		if option is HauntOption:
			option.option_clicked.connect(_on_option_clicked)
			option.haunted.connect(haunted.emit)
	SignalBus.cancel.connect(hide)

func _on_option_clicked():
	selected.emit()
