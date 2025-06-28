@tool
extends GridContainer

@export var width := 20:
	set(value):
		width = value
		_remove_grid()
		_create_grid()
@export var height := 20:
	set(value):
		height = value
		_remove_grid()
		_create_grid()
@export var cellWidth = 50:
	set(value):
		cellWidth = value
		_remove_grid()
		_create_grid()
@export var cellHeight = 50:
	set(value):
		cellHeight = value
		_remove_grid()
		_create_grid()

var Map = [
	[-1,-1,-1,4,4,4,4,4,4,4,4,4,4,4,4,-1,-1,-1,-1,-1],
	[-1,-1,4,4,1,1,1,4,4,1,1,1,5,5,4,4,-1,-1,-1,-1],
	[-1,4,4,1,1,1,1,1,1,1,1,5,5,5,1,4,4,-1,-1,-1],
	[-1,4,1,1,2,1,1,1,1,1,1,1,5,1,1,1,4,4,-1,-1],
	[-1,4,1,2,0,2,1,1,1,1,1,1,1,1,1,1,1,4,4,-1],
	[4,4,1,1,2,2,1,1,6,1,1,1,1,1,1,1,1,1,4,4],
	[4,1,1,1,1,1,1,6,1,1,1,1,1,1,1,1,1,1,1,4],
	[4,1,1,1,1,6,1,1,1,1,1,1,1,1,2,2,1,1,1,4],
	[4,1,1,1,6,1,1,2,1,1,1,1,1,1,2,0,2,1,1],
	[4,4,1,1,1,2,2,2,2,1,1,1,1,1,1,1,1,1,1,4],
	[4,4,1,1,1,1,2,2,2,1,1,1,1,1,1,3,3,1,1,4],
	[4,4,1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,1,1,4],
	[4,1,1,1,1,1,1,1,1,4,1,1,1,1,1,3,1,1,1,4],
	[4,1,1,1,1,1,1,1,4,4,1,1,1,1,1,1,1,1,1,4],
	[4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4],
	[4,4,1,2,2,1,1,1,1,1,1,5,5,1,1,1,1,4,-1,-1],
	[-1,4,1,2,0,2,1,1,1,1,1,5,5,5,1,1,1,4,-1,-1],
	[-1,4,4,1,2,1,1,1,1,1,1,1,5,5,1,1,4,4,-1,-1],
	[-1,-1,4,1,1,1,1,1,1,4,4,1,1,1,1,4,4,-1,-1,-1],
	[-1,-1,4,4,4,4,4,4,4,4,4,4,4,4,4,4,-1,-1,-1,-1],
]

const GRID_CELL = preload("res://Scenes/grid_cell.tscn")
const borderSize = 4

func _ready() -> void:
	_create_grid()
	
func _create_grid():
	columns = width
	for i in range(width):
		for j in range(height):
			var gridCellNode = GRID_CELL.instantiate()
			gridCellNode.custom_minimum_size = Vector2(cellWidth, cellHeight)
			var tile_id = 0
			# print(i, j)
			# print("Size:", Map.size(), Map[i].size())
			if i < Map.size() and j < Map[i].size():
				tile_id = Map[i][j]
			gridCellNode.set_tile_id(tile_id)
			add_child(gridCellNode)
		
func _remove_grid():
	for node in get_children():
		node.queue_free()
