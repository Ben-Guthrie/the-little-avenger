extends HauntOption

signal haunt_selected

func haunt():
	haunt_selected.emit()
	haunted.emit(energy_cost)
