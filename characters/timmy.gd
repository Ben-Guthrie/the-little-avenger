extends Node2D

signal timmy_dies
@export var path: Node2D = Node2D.new()

func _ready():
	# Snap to center of grid
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2)
	$AnimatedSprite2D.play("idle_down")
	$MoveComponent.moving.connect(moving_animation)
	SignalBus.pause_animation.connect($AnimatedSprite2D.pause)
	SignalBus.resume_animation.connect($AnimatedSprite2D.play)

func _process(_delta):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	$MoveComponent.move(input_direction)

func moving_animation(moving_direction: Vector2) -> void:
	var animation_state: StringName = $AnimatedSprite2D.animation
	var vectorDirection = vector2Direction(moving_direction)
	
	if moving_direction.length() > 0:
		animation_state = "walk_" + vectorDirection
	else:
		vectorDirection = animation_state.get_slice("_", 1)
		animation_state = "idle_" + vectorDirection
			
	$AnimatedSprite2D.play(animation_state)

func vector2Direction(vec: Vector2) -> String:
	var direction = "down"
	if vec.y > 0: direction = "down"
	elif vec.y < 0: direction = "up"
	elif vec.x > 0:
		$AnimatedSprite2D.flip_h = true
		direction = "left"
	elif vec.x < 0:
		# Horizontal flip since we have one animation for both left and right walking and idle
		$AnimatedSprite2D.flip_h = false
		direction = "left"
		
	return direction

func stop_animation():
	$AnimatedSprite2D.stop()

func play_idle(direction = null):
	if direction:
		$AnimatedSprite2D.play("idle_" + vector2Direction(direction))
	else:
		$AnimatedSprite2D.play("idle_"+vector2Direction($MoveComponent.moving_direction))

func kill():
	timmy_dies.emit()
