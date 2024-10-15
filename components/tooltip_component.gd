extends Area2D

@export var tooltip_text: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer/Label.text = tooltip_text

func _on_mouse_entered() -> void:
	$CenterContainer.show()


func _on_mouse_exited() -> void:
	$CenterContainer.hide()
