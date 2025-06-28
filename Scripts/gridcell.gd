extends PanelContainer

@export var full = false
@export var Tile_type : int = -1

@onready var texture_rect: TextureRect = $TextureRect

const Tiles_pic = [
	preload("res://Assets/Object/tile_0.jpg"),
	preload("res://Assets/Object/tile_1.jpg"),
	preload("res://Assets/Object/tile_2.jpg"),
	preload("res://Assets/Object/tile_3.jpg"),
	preload("res://Assets/Object/tile_4.jpg"),
	preload("res://Assets/Object/tile_5.jpg"),
	preload("res://Assets/Object/tile_6.jpg"),
	preload("res://Assets/Object/tile_7.jpg"),
]


func _ready() -> void:
	pass



func change_color(color:Color):
	var styleBox := get_theme_stylebox("panel").duplicate()
	styleBox.bg_color = color
	add_theme_stylebox_override("panel",styleBox)
	
func set_tile_id(typeID: int):
	Tile_type = typeID
	update_visual()
	
func update_visual():
	if Tile_type == -1:
		return
	$TextureRect.texture = Tiles_pic[Tile_type]
	
func element_react(elementID: int):
	var Target_Tile: int = -1
	match Tile_type:
		0:
			match elementID:
				2:
					Target_Tile = 6
				4:
					Target_Tile = 6
		1:
			match elementID:
				1:
					Target_Tile = 7
				2:
					Target_Tile = 2
				4:
					Target_Tile = 5
		2:
			match elementID:
				1: 
					Target_Tile = 1
		3:
			match elementID:
				0:
					Target_Tile = 1
				4:
					Target_Tile = 5
		4:
			match elementID:
				2:
					Target_Tile = 1
		5:
			match elementID:
				1:
					Target_Tile = 7
		6:
			match elementID:
				0:
					Target_Tile = 4
				1:
					Target_Tile = 0
				2:
					Target_Tile = 4
				4:
					Target_Tile = 5
		7:
			match elementID:
				1:
					Target_Tile = 4
				2:
					Target_Tile = 1
				4:
					Target_Tile = 5
	print(Target_Tile)
	set_tile_id(Target_Tile)

func tile_react(tile_around: Array):
	pass
