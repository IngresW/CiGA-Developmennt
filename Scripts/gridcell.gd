extends PanelContainer

@export var full = false
@export var Tile_type : int = -1

@onready var texture_rect: TextureRect = $TextureRect
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const Tiles_pic = [
	preload("res://Assets/Object/tile_0.jpg"),
	preload("res://Assets/Object/tile_1.jpg"),
	preload("res://Assets/Object/tile_2.jpg"),
	preload("res://Assets/Object/tile_3.jpg"),
	preload("res://Assets/Object/tile_4.jpg"),
	preload("res://Assets/Object/tile_5.jpg"),
	preload("res://Assets/Object/tile_6.jpg"),
	preload("res://Assets/Object/tile_7.jpg"),
	preload("res://Assets/World_Assets/world_tileset.png")
]

const Tiles_animation = [
	"flow",
	"grass",
	"",
	"water",
	"",
	"",
	"",
	"",
]

# 在此处修改随机权重
const Tile_React_Weights = [
	[0  ,0,  0,  0,  0,  0,  0,100,100],
	[50,  0, 20, 20, 10,100,  0,  0,0],
	[100,  50,  0,  0,  0, 70,  0,  0,0],
	[100, 20, 10,  0, 20, 20,  0, 20,0],
	[100, 10, 20, 20,  0,  0,  0,  0,0],
	[100,  0,  0, 20,20,  0,70, 50,0],
	[100,100,100,100,100,100,100,100,0],
	[100, 50, 20, 20, 50, 30,  0,  0,100],
	[0,100,0,0,20,20,0,0,0]
]

#在此处修改规则
const Tile_React_Rules = [
	[ -1, 0, 0, 0, 0, 0, 0, 0, 8],
	[ 0,-1, 2, 2, 4, 1, 1, 1, 1],
	[ 7, 1,-1, 2, 2, 5, 2, 2, 2],
	[ 6, 3, 3,-1, 1, 3, 3, 1, 3],
	[ 6, 1, 4, 1,-1, 5, 4, 4, 4],
	[ 3, 5, 5, 5, 4,-1, 5, 1, 5],
	[ 6, 6, 6, 6, 6, 3,-1, 6, 6],
	[ 7, 1, 1, 1, 4, 1, 7,-1, 8],
	[ 8, 1, 8, 8, 4, 5, 8, 8, 8],
	]

func _ready() -> void:
	z_as_relative = false
	z_index = 10  #颜色优先级

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
	
	if Tile_type in [0,1,3]:
		$AnimatedSprite2D.animation = Tiles_animation[Tile_type]
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.visible = true
		$TextureRect.visible = false
		return
	else:
		$TextureRect.texture = Tiles_pic[Tile_type]
		$TextureRect.visible = true
		$AnimatedSprite2D.visible = false
		return
	
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
					Target_Tile = 8
				4:
					Target_Tile = 5
	print(Target_Tile)
	set_tile_id(Target_Tile)

func tile_react(neighbors: Array):
	# neighbors 是长度为4的数组，分别是上、下、左、右的地块类型
	# 边界块不反应
	if Tile_type == -1:
		return
	
	var effect_tile: int = -1
	var target_tile: int = -1
	# 开始处理随机 #
	var weights = []
	var types = []
	for n in neighbors:
		if n >= 0 and n < Tile_React_Weights[Tile_type].size():
			weights.append(Tile_React_Weights[Tile_type][n])
			types.append(n)
		else:
			# 边界或无效地块，权重为0，不参与
			pass

	# 如果没有有效邻居，返回自己
	if weights.size() == 0:
		return Tile_type

	# 权重随机选择
	var total = 0
	for w in weights:
		total += w

	if total == 0:
		return Tile_type  # 没有权重，保持不变

	var r = randi() % total
	var acc = 0
	for i in range(weights.size()):
		acc += weights[i]
		if r < acc:
			effect_tile = types[i]
			break
	# 结束处理随机 #
	
	# 开始处理交互 #
	if effect_tile != Tile_type:
		target_tile = Tile_React_Rules[Tile_type][effect_tile]
	
	set_tile_id(target_tile)
