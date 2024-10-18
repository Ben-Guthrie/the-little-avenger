extends Level

var dialogue = load("res://globals/dialogue/intro.dialogue")

func _ready() -> void:
	SignalBus.trigger_dialogue.connect(_on_dialogue_triggered)
	super._ready()
	$Characters/Timmy.play_idle(Vector2.LEFT)
	if Game.resets == 0:
		play_intro.call_deferred()

func play_intro():
	Game.main_scene.start()

func _on_timmy_timmy_dies() -> void:
	SignalBus.reset.emit()

func _on_dialogue_triggered(title: String):
	SignalBus.pause_animation.emit()
	#print("dialogue triggered: ", title)
	if !(title in ["warrior", "bow", "chest"]):
		title = "none"
	DialogueManager.show_dialogue_balloon(preload("res://globals/dialogue/general.dialogue"), title)
	await DialogueManager.dialogue_ended
	SignalBus.resume_animation.emit()
	SignalBus.dialogue_triggered.emit()
