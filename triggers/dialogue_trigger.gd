extends Trigger

@export var dialogue_resource: DialogueResource
@export var title: String

func trigger_effect(_target: Node):
	SignalBus.pause_animation.emit()
	DialogueManager.show_dialogue_balloon(dialogue_resource, title, [self])
	await DialogueManager.dialogue_ended
	SignalBus.resume_animation.emit()
	complete.emit()
