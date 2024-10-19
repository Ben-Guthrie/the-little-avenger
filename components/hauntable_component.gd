extends Area2D

signal haunted

@export var sprite: Node
@export var haunt_options: Array[Node]

var hovered = false
var active = false
var disabled = false

func _ready():
	SignalBus.cancel.connect(func (): 
		active = false
		disabled = false
		$HauntUI.hide())

func set_highlight(highlight: bool):
	sprite.material.set("shader_parameter/onoff", highlight)

func _on_mouse_exited() -> void:
	SignalBus.cursor_arrow.emit()
	hovered = false
	#set_highlight(false)


func _on_mouse_entered() -> void:
	if disabled or !Game.can_haunt:
		return
	SignalBus.cursor_pointer.emit()
	hovered = true
	#set_highlight(true)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if disabled or !Game.can_haunt:
		return
	if event is InputEventMouseButton and event.pressed:
		SignalBus.cancel.emit()
		if Game.ghost:
			Game.ghost.haunt(self)
		active = true
		$HauntUI.show()
		get_viewport().set_input_as_handled()


func _on_haunt_ui_selected() -> void:
	disabled = true
	$HauntUI.hide()


func _on_haunt_ui_haunted(energy_cost: int) -> void:
	haunted.emit()
	Game.haunt_energy -= energy_cost
	SignalBus.energy_updated.emit()
	var timer = Timer.new()
	add_child(timer)
	timer.start(0.5)
	timer.timeout.connect(func (): disabled = false; timer.queue_free())
