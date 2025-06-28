extends PanelContainer

signal element_selected(element_type: int)

@onready var earth_button: TextureButton = $VBoxContainer/Earth
@onready var fire_button: TextureButton = $VBoxContainer/Fire
@onready var water_button: TextureButton = $VBoxContainer/Water
@onready var wind_button: TextureButton = $VBoxContainer/Wind

var selected_element: int = -1

func _ready():
	# 连接按钮信号
	earth_button.pressed.connect(_on_earth_pressed)
	fire_button.pressed.connect(_on_fire_pressed)
	water_button.pressed.connect(_on_water_pressed)
	wind_button.pressed.connect(_on_wind_pressed)
	
	# 初始化按钮状态
	_update_button_states()

func _on_earth_pressed():
	selected_element = 0
	_update_button_states()
	element_selected.emit(selected_element)
	print("Select Earth")

func _on_fire_pressed():
	selected_element = 1
	_update_button_states()
	element_selected.emit(selected_element)
	print("Select Fire")

func _on_water_pressed():
	selected_element = 2
	_update_button_states()
	element_selected.emit(selected_element)
	print("Select Water")

func _on_wind_pressed():
	selected_element = 3
	_update_button_states()
	element_selected.emit(selected_element)
	print("Select Wind")

func _update_button_states():
	# 重置所有按钮
	earth_button.modulate = Color.WHITE
	fire_button.modulate = Color.WHITE
	water_button.modulate = Color.WHITE
	wind_button.modulate = Color.WHITE
	
	# 高亮选中的按钮
	match selected_element:
		0: earth_button.modulate = Color.YELLOW
		1: fire_button.modulate = Color.YELLOW
		2: water_button.modulate = Color.YELLOW
		3: wind_button.modulate = Color.YELLOW

func get_selected_building() -> int:
	return selected_element

func clear_selection():
	selected_element = -1
	_update_button_states()
