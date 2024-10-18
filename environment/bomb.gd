extends Sprite2D

signal hit

@export var throw_distance = 4

var armed = true

var explosion_scene = preload("res://environment/Explosion.tscn")

# Called when the node enters the scene tree for the first time.
func throw(direction: Vector2):
	$AnimationPlayer.play("pick_up")
	await $AnimationPlayer.animation_finished
	$ThrowComponent.throw(direction, throw_distance)

func _on_hit(target):
	#print("hit at ", global_position)
	if armed:
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		get_parent().add_child.call_deferred(explosion)
		await explosion.animation_finished
		#print(explosion.global_position)
		check_if_targets_in_explosion.call_deferred(explosion)
		queue_free.call_deferred()
	else:
		hit.emit.call_deferred()

func check_if_targets_in_explosion(explosion):
	await Game.main_scene.current_scene.check_triggers(explosion.get_node("Trigger"))
	#print("hit emit")
	hit.emit.call_deferred()
	queue_free.call_deferred()


func _on_signal_haunt_selected() -> void:
	armed = false
	$HauntableComponent/HauntUI/Options/Signal.hide()
