extends Node2D

@onready var game_scene = $Scene
@onready var start_menu = $StartMenu
@onready var game_ui = $Scene/CanvasLayer_UI
@onready var game_timer = $Scene/CanvasLayer_UI/TimerUI
@onready var help_ui = $Scene/CanvasLayer_UI/HelpLayer

func _ready():
	# 初始隐藏游戏和引导界面
	#game_scene.visible = false
	#tutorial.visible = false
	#start_menu.visible = true
	game_scene.visible = true
	game_ui.visible = false
	#tutorial.set_process(false)
	#game_scene.set_process(false)
	return#等会再说

func go_to_main_game():
	game_scene.visible = true
	start_menu.visible = false
	game_ui.visible = true
	game_timer.is_running = true


func _on_help_button_pressed() -> void:
	game_scene.visible = false
	game_ui.visible = false
	game_timer.is_running = false
	help_ui.visible = true

func _on_close_help_button_pressed() -> void:
	game_scene.visible = true
	game_ui.visible = true
	game_timer.is_running = true
	help_ui.visible = false
