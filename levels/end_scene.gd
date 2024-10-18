extends Level

func _ready() -> void:
	super._ready()
	$LevelStartTimer.start()
	await $LevelStartTimer.timeout
	play_intro.call_deferred()



func play_intro():
	print("end scene")
	DialogueManager.show_dialogue_balloon.call_deferred(preload("res://globals/dialogue/intro.dialogue"), "end_intro")
	await DialogueManager.dialogue_ended
	print("dialogue ended")
	SignalBus.start.emit.call_deferred()
