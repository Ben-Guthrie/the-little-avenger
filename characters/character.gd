extends Sprite2D

class_name Character

@export var path: Node2D = Node2D.new()
var is_dead = false

func kill():
	is_dead = true
	var tween = create_tween()
	SignalBus.moved.emit(Vector2(-1,-1), global_position)
	for child in get_children():
		child.free()
	tween.tween_callback(queue_free).set_delay(0.2)
	
