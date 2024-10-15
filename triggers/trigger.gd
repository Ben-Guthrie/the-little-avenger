extends Area2D

class_name Trigger
signal complete

@export var targets: Array[Node] = []
@export var exclude: Array[Node] = []
@export var one_off = true

func trigger(target: Node):
	if (len(targets) == 0 or target in targets) and len(exclude) == 0 or !(target in exclude):
		if one_off:
			set_collision_layer_value(2, false)
		trigger_effect(target)
	else:
		complete.emit.call_deferred()
		

func trigger_effect(_target: Node):
	pass
