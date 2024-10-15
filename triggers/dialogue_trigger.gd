extends Trigger

@export var dialogue_resource: DialogueResource
@export var title: String

func trigger_effect(_target: Node):
	DialogueManager.dialogue_ended.connect(func(_res): complete.emit(), CONNECT_ONE_SHOT)
	DialogueManager.show_dialogue_balloon(dialogue_resource, title, [self])
