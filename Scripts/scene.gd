extends Node2D

@onready var tilemap: Node2D = $TileMap as Node2D
@onready var camera: Camera2D = $TileMap/Camera2D
@onready var grid: GridContainer = $Grid
@onready var element_selector: PanelContainer = $CanvasLayer_UI/Element_Selector
@onready var timer_ui: Control = $CanvasLayer_UI/TimerUI
@onready var label: Label = $CanvasLayer_UI/Label

# vars for score calculation
var score: int = 0

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
	TargetCell.element_react(selected_element_type)
	_reset_highlight()
	_update_ui()

func _update_ui():
	label.text = "Cost: %d / %d" % [current_cost, cost_max]
