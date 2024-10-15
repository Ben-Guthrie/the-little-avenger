extends Node2D

@export var current_level = 1
var level_scenes = {
	1: preload("res://levels/level_1.tscn"),
	2: preload("res://levels/level_2.tscn"),
	3: preload("res://levels/level_3.tscn"),
	4: preload("res://levels/level_4.tscn")
}
var current_scene

func _ready() -> void:
	Game.main_scene = self
	SignalBus.reset.connect(reset_level)
	SignalBus.level_complete.connect(next_level)
	$GameUI.start.connect(start)
	
	if $MouseMask.get_child_count() == 0:
		create_level()
		if current_level == 1:
			$GameUI.hide()
	else:
		current_scene = $MouseMask.get_child(0)
		Game.can_haunt = true

func start():
	SignalBus.cancel.emit()
	Game.can_haunt = false
	$Pathfinder.initialize()
	SignalBus.start.emit()

func reset_level():
	Game.resets += 1
	Game.haunt_energy = current_scene.energy
	current_scene.queue_free()
	$SceneTransition.play("fade_in")
	await $SceneTransition.animation_finished
	create_level()
	$GameUI.show()
	Game.can_haunt = true
	$SceneTransition.play("fade_out")

func create_level():
	if current_level not in level_scenes.keys():
		return_to_title()
		return
	print("starting level ", current_level)
	current_scene = level_scenes[current_level].instantiate()
	$MouseMask.add_child(current_scene)

func next_level():
	print("next level")
	Game.resets = 0
	current_scene.queue_free()
	$SceneTransition.play("fade_in")
	await $SceneTransition.animation_finished
	current_level += 1
	create_level()
	$SceneTransition.play("fade_out")

func return_to_title():
	queue_free()

func highlight_buttons():
	$GameUI.highlight_buttons()

func highlight_energy():
	$GameUI.highlight_energy()

func stop_highlight():
	$GameUI.stop_highlight()
