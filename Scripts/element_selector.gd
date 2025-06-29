extends PanelContainer

signal element_selected(element_type: int)

@onready var earth_button: TextureButton = $VBoxContainer/Earth/TextureButton
@onready var fire_button: TextureButton = $VBoxContainer/Fire/TextureButton
@onready var water_button: TextureButton = $VBoxContainer/Water/TextureButton
@onready var wind_button: TextureButton = $VBoxContainer/Wind/TextureButton
@onready var ice_button: TextureButton = $VBoxContainer/Ice/TextureButton

@onready var earth_label: Label = $VBoxContainer/Earth/Label
@onready var fire_label: Label = $VBoxContainer/Fire/Label
@onready var water_label: Label = $VBoxContainer/Water/Label
@onready var wind_label: Label = $VBoxContainer/Wind/Label
@onready var ice_label: Label = $VBoxContainer/Ice/Label

const element_cost = [2, 5, 10, 2, 2]
var selected_element: int = -1

func _ready():
	earth_button.pressed.connect(_on_earth_pressed)
	fire_button.pressed.connect(_on_fire_pressed)
	water_button.pressed.connect(_on_water_pressed)
	wind_button.pressed.connect(_on_wind_pressed)
	ice_button.pressed.connect(_on_ice_pressed)

	earth_label.text = str(element_cost[0]) + "c"
	fire_label.text = str(element_cost[1]) + "c"
	water_label.text = str(element_cost[2]) + "c"
	wind_label.text = str(element_cost[3]) + "c"
	ice_label.text = str(element_cost[4]) + "c"

	_update_button_states()
	
func _update_button_states():
	earth_button.modulate = Color.WHITE
	fire_button.modulate = Color.WHITE
	water_button.modulate = Color.WHITE
	wind_button.modulate = Color.WHITE
	ice_button.modulate = Color.WHITE

	match selected_element:
		0:
			earth_button.modulate = Color(1, 1, 0) # 黄色
		1:
			fire_button.modulate = Color(1, 1, 0)
		2:
			water_button.modulate = Color(1, 1, 0)
		3:
			wind_button.modulate = Color(1, 1, 0)
		4:
			ice_button.modulate = Color(1, 1, 0)

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
	
func _on_ice_pressed():
	selected_element = 4
	_update_button_states()
	element_selected.emit(selected_element)
	print("Select Ice")

func get_selected_building() -> int:
	return selected_element

func clear_selection():
	selected_element = -1
	_update_button_states()
