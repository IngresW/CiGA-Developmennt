extends Node2D

@onready var grid: GridContainer = $Grid

const OBJECT = preload("res://Scenes/object.tscn")

var gridSize: Vector2
var object = null
var is_placing = false
var targetCell = null


func _ready() -> void:
	gridSize = Vector2(grid.cellWidth, grid.cellHeight)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick"):
		if not is_placing:
			# 第一次点击，生成 object，进入放置模式
			var newPlacement = OBJECT.instantiate()
			add_child(newPlacement)
			newPlacement.global_position = get_global_mouse_position()
			object = newPlacement
			is_placing = true
		else:
			# 再次点击，固定 object，退出放置模式
			if targetCell:
				_place_element(targetCell, object)
			object = null
			is_placing = false
			_reset_highlight()

func _process(delta):
	if is_placing and object:
		object.global_position = get_global_mouse_position()
		
		# 实时高亮鼠标所在 cell
		var mousePosition = get_global_mouse_position()
		var newTargetCell = _get_target_cell(mousePosition)
		if newTargetCell != targetCell:
			targetCell = newTargetCell
			_highlight_cell(targetCell)

func _get_target_cell(targetPosition):
	for child: Control in grid.get_children():
		if child.get_global_rect().has_point(targetPosition):
			return child
	return null

func _highlight_cell(cell):
	# 先重置所有 cell 颜色
	_reset_highlight()
	# 高亮当前 cell
	if cell:
		cell.change_color(Color(0, 1, 0, 0.5)) # 绿色

func _reset_highlight():
	for child: Control in grid.get_children():
		child.change_color(Color(0.5, 0.5, 0.5, 0.5))

func _place_element(targetCell, object):
	print("放置了一个元素，在", targetCell)
	## TODO
	_reset_highlight()
