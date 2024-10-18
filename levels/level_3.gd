extends Level

func _ready() -> void:
	SignalBus.trigger_dialogue.connect(play_dialogue)
	super._ready()
	$Characters/Timmy.play_idle(Vector2.LEFT)
	if Game.resets == 0:
		$LevelStartTimer.start()
		await $LevelStartTimer.timeout
		play_intro.call_deferred()

func play_intro():
	await play_dialogue("level_3")
	Game.main_scene.start()

func play_dialogue(title: String):
	SignalBus.pause_animation.emit()
	print("dialogue triggered: ", title)
	if !(title in ["bomb", "chest", "bomb_death"]):
		title = "none"
	DialogueManager.show_dialogue_balloon(preload("res://globals/dialogue/general.dialogue"), title)
	await DialogueManager.dialogue_ended
	SignalBus.resume_animation.emit()
	SignalBus.dialogue_triggered.emit.call_deferred()


func _on_timmy_timmy_dies() -> void:
	SignalBus.reset.emit()
