extends Character

signal hit

func _on_triggers_shoot() -> void:
	$Bow.shoot(Vector2.DOWN)
	await $Bow.hit
	hit.emit()
