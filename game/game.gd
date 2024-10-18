extends Node2D

@export var current_level = 1
var level_scenes = {
	1: preload("res://levels/level_1.tscn"),
	2: preload("res://levels/level_2.tscn"),
	3: preload("res://levels/level_3.tscn"),
	4: preload("res://levels/level_4.tscn"),
	5: preload("res://levels/level_5.tscn")
}
var final_scene = preload("res://levels/end_scene.tscn")
var current_scene

func _ready() -> void:
	Game.main_scene = self
	SignalBus.reset.connect(reset_level)
	SignalBus.level_complete.connect(next_level)
	$GameUI.start.connect(start)
	if current_level != 1:
		SignalBus.allow_continue.emit()
	if get_tree().current_scene == self:
		create_level()

func continue_game():
	if current_scene != null:
		current_scene.queue_free()
	
	$SceneTransition.play("fade_in")
	await $SceneTransition.animation_finished
	create_level()
	$SceneTransition.play("fade_out")
	

func new_game():
	if current_scene != null:
		current_scene.queue_free()
	Game.resets = 0
	SignalBus.no_continue.emit()
	current_level = 1
	create_level()
	$SceneTransition.play("fade_in")
	await $SceneTransition.animation_finished
	$SceneTransition.play("fade_out")
	
	if current_level == 1:
		$GameUI.hide()


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
	if current_level != 1:
		$GameUI.show()
	elif current_level not in level_scenes.keys():
		$GameUI.hide()
	if !(current_level in level_scenes.keys()):
		current_scene = final_scene.instantiate()
		$MouseMask.add_child(current_scene)
		$GameUI.hide()
	else:
		#print("starting level ", current_level)
		current_scene = level_scenes[current_level].instantiate()
		$MouseMask.add_child(current_scene)

func next_level():
	#print("next level")
	Game.resets = 0
	current_scene.queue_free()
	$SceneTransition.play("fade_in")
	await $SceneTransition.animation_finished
	current_level += 1
	create_level()

	$SceneTransition.play("fade_out")

func end_game():
	SignalBus.no_continue.emit()
	current_level = 1
	var old_speed_scale = $SceneTransition.speed_scale
	$SceneTransition.play("fade_in", -1, 0.2)
	await $SceneTransition.animation_finished
	current_scene.queue_free()
	SignalBus.open_credits.emit()
	SignalBus.return_to_menu.emit()
	$SceneTransition.play("fade_out")

func highlight_buttons():
	$GameUI.highlight_buttons()

func highlight_energy():
	$GameUI.highlight_energy()

func stop_highlight():
	$GameUI.stop_highlight()
