extends Node

@export var self_node: Node
@onready var grid_size = get_viewport().get_visible_rect().size
@export var speed_multiplier = 4.
@onready var speed = Constants.GAME_SPEED / speed_multiplier
signal hit(target)
signal moved

func throw(direction: Vector2, distance=INF):
	#print(distance)
	if (distance <= 0):
		hit.emit.call_deferred(null)
	else:
		var success = await move(direction)
		distance -= 1
		if success:
			throw(direction, distance)

func move(direction: Vector2):
	if direction.length() > 0:
		var movement = Vector2.DOWN
		if direction.y > 0: movement = Vector2.DOWN
		elif direction.y < 0: movement = Vector2.UP
		elif direction.x > 0: movement = Vector2.RIGHT
		elif direction.x < 0: movement = Vector2.LEFT

		$RayCast2D.target_position = (movement * Constants.TILE_SIZE).rotated(- $RayCast2D.global_rotation)
		$RayCast2D.force_raycast_update() # Update the `target_position` immediately
		if $RayCast2D.is_colliding():
			hit.emit.call_deferred($RayCast2D.get_collider())
			return false
		
		var new_position = self_node.global_position + (movement * Constants.TILE_SIZE)
		if new_position.x > grid_size.x || new_position.y > grid_size.y || new_position.x < 0 || new_position.y < 0:
			#print(new_position, grid_size)
			hit.emit(null)
			return false
		
		var tween = create_tween()
		tween.tween_property(self_node, "global_position", new_position, speed).set_trans(Tween.TRANS_LINEAR)
		await tween.finished
		return true
