extends Node2D

class_name Level

var units_to_move = 0
var units_moved = 0
var units
@export var energy: int = 1
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	units = $Characters.get_children()
	SignalBus.energy_updated.emit()
	if Game.pathfinder:
		Game.pathfinder.initialize()
	SignalBus.start.connect(_on_start)
	highlight_all_hauntable()

func _on_start():
	await check_triggers()
	unhighlight_all_hauntable()
	move_units()

func check_triggers(trigger_target = null):
	SignalBus.pause_animation.emit()
	for character in $Characters.get_children():
		if paused:
			return
		if is_instance_valid(character) and character.has_node("TriggerComponent") and !character.get("is_dead"):
			#print("checking trigger")
			var trigger = character.get_node("TriggerComponent").check_for_trigger()
			if trigger != null:
				if trigger_target != null and trigger != trigger_target:
					#print("wrong trigger: ", trigger)
					continue
				#print("trigger")
				trigger.trigger(character)
				await trigger.complete
				#print("complete")


func move_units():
	units_to_move = 0
	SignalBus.new_turn.emit()
	for unit in $Characters.get_children():
		#print("is alive: ", !unit.get("is_dead"))
		if "path" in unit and !unit.get("is_dead"):
			move_unit(unit, unit.path)

func move_unit(unit: Node2D, path_markers: Node2D):
	if paused:
		return
	if path_markers.get_child_count() == 0:
		#print("no path")
		return
	var destination = path_markers.get_child(0).global_position
	#print("move ", unit, " to ", destination)
	var path = Game.pathfinder.find_path(unit.global_position, destination)
	#print(path)
	var move_component = unit.get_node('MoveComponent')
	if path:
		if len(path) == 1:
			path_markers.remove_child(path_markers.get_child(0))
			if path_markers.get_child_count() > 0:
				return move_unit(unit, path_markers)
			return
		
		units_to_move += 1
		move_component.moved.connect(_on_object_moved, CONNECT_ONE_SHOT)
		move_component.move(path[1]*Constants.TILE_SIZE-unit.global_position + Vector2.ONE*Constants.TILE_SIZE/2)

func _on_object_moved(_from: Vector2, _to: Vector2):
	#print("moved")
	if units_to_move != 0:
		units_moved += 1
		#print(units_moved, units_to_move)
		if units_moved == units_to_move:
			##print("moving")
			units_moved = 0
			units_to_move = 0
			await check_triggers()
			move_units()

func highlight_hauntable(n: Node, should_highlight = true):
	if n.has_node("HauntableComponent"):
		n.get_node("HauntableComponent").set_highlight(should_highlight)
		

func highlight_all_hauntable():
	for c in get_children():
		call_children(highlight_hauntable.bind(true), c)

func unhighlight_all_hauntable():
	for c in get_children():
		call_children(highlight_hauntable.bind(false), c)


func call_children(f: Callable, n: Node):
	f.call(n)
	for c in n.get_children():
		call_children(f, c)
