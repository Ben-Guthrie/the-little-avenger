extends HauntOption

@export var move_range = 1
var location_selector = preload('res://utils/location_selector.tscn')

const directions = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]

func haunt():
	var destinations = []
	var raycast = RayCast2D.new()
	haunt_target.add_child(raycast)
	var search_origins = [Vector2.ZERO]
	var search_range = move_range
	# Find all destinations we can move to
	while search_range > 0:
		var new_locations = []
		for o in search_origins:
			raycast.position = o * Constants.TILE_SIZE
			for d in directions:
				raycast.target_position = (o + d) * Constants.TILE_SIZE
				raycast.force_raycast_update()
				#print(haunt_target.position)
				if !raycast.is_colliding() and o+d not in new_locations \
				 and o+d not in destinations and o+d != Vector2.ZERO:
					new_locations.append(o+d)
		destinations.append_array(new_locations)
		search_origins = new_locations
		search_range -= 1
	raycast.queue_free()
	# Add clickable target to all destinations and connect to the signal
	for cell in destinations:
		var selector = location_selector.instantiate()
		haunt_target.add_child(selector)
		selector.position = cell * Constants.TILE_SIZE
		selector.selected.connect(move_to.bind(cell))
		haunted.connect(func (_x): 
			if selector != null:
				selector.queue_free(), 
			CONNECT_ONE_SHOT)
		SignalBus.cancel.connect(selector.queue_free, CONNECT_ONE_SHOT)

func move_to(direction: Vector2):
	var new_position = haunt_target.position + direction * Constants.TILE_SIZE
	haunt_target.position = new_position
	haunted.emit(energy_cost)
