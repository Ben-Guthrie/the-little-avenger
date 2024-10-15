extends Node

var astar = AStar2D.new()
@onready var grid_size = get_viewport().get_visible_rect().size / Constants.TILE_SIZE

var directions = [Vector2.DOWN, Vector2.UP, Vector2.RIGHT, Vector2.LEFT]

func _ready() -> void:
	Game.pathfinder = self
	SignalBus.moved.connect(_on_object_moved)


# Initialize AStar2D and RayCast2D
func initialize():
	astar.clear()
	var raycast = $RayCast2D
	#raycast.target_position = Vector2.RIGHT * Constants.TILE_SIZE

	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var tile_position = Vector2(x, y)
			
			# Set RayCast2D properties to check tile center
			raycast.position = tile_position * Constants.TILE_SIZE + Vector2(0.5, 0.5) * Constants.TILE_SIZE
			raycast.force_raycast_update()
			add_point_at_tile(tile_position)
			if raycast.is_colliding():
				astar.set_point_disabled(tile_to_point_id(tile_position))


func _on_object_moved(new_position: Vector2, old_position: Vector2):
	var old_tile = world_to_tile(old_position)
	var new_tile = world_to_tile(new_position)
	if astar.has_point(tile_to_point_id(new_tile)):
		astar.set_point_disabled(tile_to_point_id(new_tile))
	if astar.has_point(tile_to_point_id(old_tile)):
		astar.set_point_disabled(tile_to_point_id(old_tile), false)


func find_path(start_position: Vector2, end_position: Vector2) -> Array:
	# Convert world positions to tile grid positions
	var start_tile = world_to_tile(start_position)
	var end_tile = world_to_tile(end_position)
	print(start_tile, end_tile)

	# Get unique point IDs for A* based on tile positions
	var start_point_id = tile_to_point_id(start_tile)
	var end_point_id = tile_to_point_id(end_tile)
	print(start_point_id, astar.has_point(start_point_id))
	print(end_point_id, astar.has_point(end_point_id))
	
	astar.set_point_disabled(start_point_id, false)

	var path = []
	if astar.has_point(start_point_id) and astar.has_point(end_point_id):
		# Find the path between the two points (returns an array of tile positions)
		if astar.is_point_disabled(end_point_id):
			astar.set_point_disabled(end_point_id, false)
			path = Array(astar.get_point_path(start_point_id, end_point_id, true))
			astar.set_point_disabled(end_point_id)
			path.pop_back()
		else:
			path = astar.get_point_path(start_point_id, end_point_id, true)

	astar.set_point_disabled(start_point_id, true)
	return path



# Helper function to convert world position to tile position
func world_to_tile(world_position: Vector2) -> Vector2:
	return floor(world_position / Constants.TILE_SIZE)


# Helper function to convert tile position to A* point ID
func tile_to_point_id(tile_position: Vector2) -> int:
	return int(tile_position.x * grid_size.y + tile_position.y)

func add_point_at_tile(tile_position: Vector2):
	var tile_id = tile_to_point_id(tile_position)
	astar.add_point(tile_id, tile_position)
	for direction in directions:
		var neighbor = tile_position + direction
		if neighbor.x >= 0 and neighbor.x < grid_size.x and neighbor.y >= 0 and neighbor.y < grid_size.y:
			var neighbor_id = tile_to_point_id(neighbor)
			if astar.has_point(neighbor_id):
				astar.connect_points(tile_id, neighbor_id, Constants.TILE_SIZE)
