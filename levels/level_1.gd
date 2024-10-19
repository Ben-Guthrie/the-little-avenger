extends Level
var dialogue = load("res://globals/dialogue/intro.dialogue")

func _ready() -> void:
	super._ready()
	if Game.resets == 0:
		unhighlight_all_hauntable()
		play_intro()
	elif Game.resets == 1:
		play_tutorial()
	elif Game.resets == 2:
		DialogueManager.show_dialogue_balloon(dialogue, "lie")

func play_intro():
	$Characters/Timmy/AnimatedSprite2D.play("idle_up")
	DialogueManager.dialogue_ended.connect(func (_res): Game.main_scene.start(), CONNECT_ONE_SHOT)
	DialogueManager.show_dialogue_balloon(dialogue, "intro")

func play_tutorial():
	DialogueManager.show_dialogue_balloon(dialogue, "tutorial")
