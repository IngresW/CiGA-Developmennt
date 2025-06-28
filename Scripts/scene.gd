extends Node2D

@onready var grid: GridContainer = $Grid
@onready var timer_ui: Control = $TimerUI


# 元素选择相关
@onready var element_selector: PanelContainer = $Element_Selector
var selected_element_type: int = -1  # 当前选中的元素类型 (-1表示未选择)

# 元素场景预加载
var element_scenes = [
	preload("res://Scenes/Element/Earth.tscn"),
	preload("res://Scenes/Element/Fire.tscn"), 
	preload("res://Scenes/Element/Water.tscn"),
	preload("res://Scenes/Element/Wind.tscn"),
	preload("res://Scenes/Element/Ice.tscn")
]

var gridSize: Vector2
var object = null
var is_placing = false
var targetCell = null

func _ready() -> void:
	gridSize = Vector2(grid.cellWidth, grid.cellHeight)
	if element_selector:
		element_selector.element_selected.connect(_on_element_selected)
		if timer_ui:
			timer_ui.time_up.connect(_on_time_up)
				
func _on_element_selected(element_type: int):
	selected_element_type = element_type
	
	var element_scene = element_scenes[element_type]
	object = element_scene.instantiate()
	add_child(object)
	object.global_position = get_global_mouse_position()
	is_placing = true
	print("开始放置建筑类型: ", selected_element_type)

func _on_time_up():
	pass
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftClick") and is_placing:
		# 固定元素，退出放置模式
		if targetCell:
			_place_element(targetCell)
		object = null
		is_placing = false
		selected_element_type = -1  # 清除选择
		element_selector.clear_selection()  # 清除UI选择状态
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

func _place_element(TargetCell):
	print("放置了元素类型 ", selected_element_type, " 在位置 ", TargetCell)
	# TODO
	_reset_highlight()
