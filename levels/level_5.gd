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
	DialogueManager.show_dialogue_balloon(preload("res://globals/dialogue/intro.dialogue"), "level_5")
	await DialogueManager.dialogue_ended
	Game.main_scene.start()

func play_dialogue(title: String):
	print("dialogue triggered: ", title)
	if title == "bomb_death":
		title = "level_5_death"
	if !(title in ["level_5_death"]):
		title = "none"
	DialogueManager.show_dialogue_balloon(preload("res://globals/dialogue/general.dialogue"), title)
	await DialogueManager.dialogue_ended
	SignalBus.dialogue_triggered.emit()


func _on_timmy_timmy_dies() -> void:
	SignalBus.reset.emit()
