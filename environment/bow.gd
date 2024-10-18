extends AnimatedSprite2D

signal hit

var explosive = false
var arrow_scene = preload("res://environment/arrow.tscn")

# Called when the node enters the scene tree for the first time.
func shoot(direction: Vector2):
	global_rotation = Vector2.RIGHT.angle_to(direction)
	play("shoot")
	await animation_finished
	var arrow = arrow_scene.instantiate()
	add_child(arrow)
	arrow.global_position = global_position
	arrow.global_rotation = Vector2.UP.angle_to(direction)
	arrow.get_node("ThrowComponent").hit.connect(_on_hit.bind(arrow))
	arrow.show()
	arrow.get_node("ThrowComponent").throw(direction)

func _on_hit(target, arrow):
	#print("hit ", target)
	var tween = create_tween()
	if target != null:
		if target is StaticBody2D and target.get_parent().has_method("kill"):
			target.get_parent().kill()
		tween.tween_callback(arrow.queue_free).set_delay(0.2)
	else:
		arrow.global_position = arrow.global_position + Vector2.UP.rotated(arrow.global_rotation)*Constants.TILE_SIZE/4
		tween.tween_callback(arrow.queue_free).set_delay(0.2)
	hit.emit()
