extends AnimatedSprite2D

@export var target: Node
@onready var return_position = position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.cancel.connect(return_to_position)
	Game.ghost = self
	target.get_node("MoveComponent").moved.connect(follow_move)


func follow_move(to: Vector2, from: Vector2):
	$MoveComponent.move(from - position)

func haunt(haunt_target: Node):
	haunt_target.haunted.connect(_on_haunted, CONNECT_ONE_SHOT)
	#SignalBus.cancel.connect(func(): haunt_target.haunted.disconnect(_on_haunted), CONNECT_ONE_SHOT)
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", haunt_target.global_position, 0.1)
	tween.tween_callback(func(): self.hide())

func _on_haunted():
	return_to_position()

func return_to_position():
	show()
	var tween = create_tween()
	tween.tween_property(self, "position", return_position, 0.1)
