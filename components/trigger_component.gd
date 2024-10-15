extends Node2D

func check_for_trigger():
	if $TriggerRayCast2D.is_colliding():
		var trigger_node = $TriggerRayCast2D.get_collider()
		return trigger_node
	return null
