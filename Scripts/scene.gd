extends Node2D

@onready var tilemap: Node2D = $TileMap as Node2D
@onready var camera: Camera2D = $TileMap/Camera2D
@onready var grid: GridContainer = $Grid
@onready var element_selector: PanelContainer = $CanvasLayer_UI/Element_Selector
@onready var timer_ui: Control = $CanvasLayer_UI/TimerUI
@onready var label: Label = $CanvasLayer_UI/Label

var selected_element_type: int = -1
var current_cost: int = 5
var cost_max: int = 15

var zoom_min := 0.5
var zoom_max := 2.0
var zoom_speed := 0.1

const element_cost = [2, 5, 10, 2, 2]

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

var is_dragging := false
var drag_start := Vector2()

func _ready() -> void:
	gridSize = Vector2(grid.cellWidth, grid.cellHeight)
	camera.position = Vector2(550, 550) #相机初始位置
	
	if element_selector:
		element_selector.element_selected.connect(_on_element_selected)
		print("已连接元素选择信号")
	else:
		print("element_selector 没找到，检查路径")
		
	if timer_ui:
		timer_ui.time_up.connect(_on_time_up)

	_update_ui()

	
func _on_element_selected(element_type: int):
	if current_cost < element_cost[element_type]:
		selected_element_type = -1
		return
	
	selected_element_type = element_type
	var element_scene = element_scenes[element_type]
	object = element_scene.instantiate()
	get_tree().current_scene.add_child(object)

	object.global_position = get_global_mouse_position()
	is_placing = true


func _on_time_up():
	grid.settle_all_tiles()
	_print_map()
	current_cost += 2
	if current_cost > cost_max:
		current_cost = cost_max
	_update_ui()

func _zoom_camera(delta: float, focus_pos: Vector2):
	var new_zoom = camera.zoom * (1 + delta)
	new_zoom.x = clamp(new_zoom.x, zoom_min, zoom_max)
	new_zoom.y = clamp(new_zoom.y, zoom_min, zoom_max)

	var world_pos_before = camera.get_global_transform().affine_inverse().basis_xform(focus_pos)
	camera.zoom = new_zoom
	var world_pos_after = camera.get_global_transform().affine_inverse().basis_xform(focus_pos)
	var offset = world_pos_after - world_pos_before
	camera.position += offset

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_zoom_camera(zoom_speed, event.position)  # 滚轮向上放大
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_zoom_camera(-zoom_speed, event.position)  # 滚轮向下缩小
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			is_dragging = event.pressed
			if is_dragging:
				drag_start = event.position
	
	elif event is InputEventMouseMotion and is_dragging:
		camera.position -= event.relative / camera.zoom
	
	if Input.is_action_just_pressed("leftClick") and is_placing:
		if targetCell:
			_place_element(targetCell)
		is_placing = false
		selected_element_type = -1
		element_selector.clear_selection()
		_reset_highlight()
		if object:
			object.queue_free()
			object = null
		_update_ui()

func _process(delta):
	if is_placing and object:
		object.global_position = get_global_mouse_position()
		
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
	_reset_highlight()
	if cell:
		cell.change_color(Color(0, 1, 0, 0.5))

func _reset_highlight():
	for child: Control in grid.get_children():
		child.change_color(Color(0.5, 0.5, 0.5, 0.5))

func _place_element(TargetCell):
	print("放置了元素类型 ", selected_element_type, " 在位置 ", TargetCell)
	current_cost -= element_cost[selected_element_type]
	
	# 对目标单元格产生影响
	TargetCell.element_react(selected_element_type)
	_sync_cell_to_map(TargetCell)
	# 某些特定元素可以对周围产生影响
	if _should_affect_surrounding(selected_element_type):
		_affect_surrounding_cells(TargetCell, selected_element_type)
	
	_reset_highlight()
	_update_ui()
	_print_map()


func _should_affect_surrounding(element_type: int) -> int:
	# 定义哪些元素类型会影响周围，以及影响范围
	# 返回值：0=不影响，1=九宫格(3x3)，2=右下三方向(当前+右+下+右下)
	match element_type:
		0: # 地元素 - 右下三方向
			return 2
		1: # 火元素 - 九宫格
			return 1
		2: # 水元素 - 右下三方向
			return 2
		4: # 冰元素 - 右下三方向
			return 2
		_:
			return 0

func _affect_surrounding_cells(center_cell, element_type: int):
	# 获取影响范围类型
	var range_type = _should_affect_surrounding(element_type)
	if range_type == 0:
		return
	
	# 根据范围类型获取周围的单元格
	var surrounding_cells = _get_surrounding_cells(center_cell, range_type)
	
	# 对每个周围的单元格产生影响
	for cell in surrounding_cells:
		if cell and cell != center_cell:
			# 根据元素类型决定影响方式
			match element_type:
				0: # 地元素
					cell.element_react(element_type)
					_sync_cell_to_map(cell)
				1: # 火元素 - 燃烧效果
					cell.element_react(element_type)
					_sync_cell_to_map(cell)
				2: # 水元素 - 湿润效果
					cell.element_react(element_type)
					_sync_cell_to_map(cell)
				4: # 冰元素 - 冰冻效果
					cell.element_react(element_type)
					_sync_cell_to_map(cell)

func _get_surrounding_cells(center_cell, range_type: int) -> Array:
	var surrounding_cells = []
	var cells = grid.get_children()
	var center_index = cells.find(center_cell)
	
	if center_index == -1:
		return surrounding_cells
	
	var center_x = center_index % grid.columns
	var center_y = center_index / grid.columns
	
	match range_type:
		1: # 九宫格范围：中心点及其周围8个方向 (3x3)
			for dy in range(-1, 2):
				for dx in range(-1, 2):
					var new_x = center_x + dx
					var new_y = center_y + dy
					
					# 检查边界
					if new_x >= 0 and new_x < grid.columns and new_y >= 0 and new_y < grid.get_child_count() / grid.columns:
						var index = new_y * grid.columns + new_x
						if index >= 0 and index < cells.size():
							surrounding_cells.append(cells[index])
		
		2: # 右下三方向范围：当前+右+下+右下
			var directions = [
				Vector2i(0, 0),   # 当前
				Vector2i(1, 0),   # 右
				Vector2i(0, 1),   # 下
				Vector2i(1, 1)    # 右下
			]
			for dir in directions:
				var new_x = center_x + dir.x
				var new_y = center_y + dir.y
				
				# 检查边界
				if new_x >= 0 and new_x < grid.columns and new_y >= 0 and new_y < grid.get_child_count() / grid.columns:
					var index = new_y * grid.columns + new_x
					if index >= 0 and index < cells.size():
						surrounding_cells.append(cells[index])
	
	return surrounding_cells

func _sync_cell_to_map(cell):
	var cells = grid.get_children()
	var idx = cells.find(cell)
	if idx != -1:
		var x = idx / grid.columns
		var y = idx % grid.columns
		grid.Map[x][y] = cell.Tile_type

func _update_ui():
	label.text = "Cost: %d / %d" % [current_cost, cost_max]
	
func _print_map():
	for row in grid.Map:
			print(row)
	print(" ")
