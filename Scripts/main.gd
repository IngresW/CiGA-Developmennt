extends Node2D

@onready var game_scene = $Scene
@onready var start_menu = $StartMenu
@onready var tutorial = $TutorialScene

func _ready():
	# 初始隐藏游戏和引导界面
	#game_scene.visible = false
	#tutorial.visible = false
	#start_menu.visible = true
	start_menu.visible = false
	game_scene.visible = true
	
	#tutorial.set_process(false)
	game_scene.set_process(false)
	return#等会再说

func manage_scene():
	pass

func go_to_tutorial():
	tutorial.visible = true
	start_menu.visible = false
	tutorial.set_process(true)
	return
	
func go_to_main_game():
	game_scene.visible = true
	tutorial.visible = false
	start_menu.visible = false
	return
