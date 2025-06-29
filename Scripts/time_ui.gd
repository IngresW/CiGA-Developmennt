extends Control

@onready var timer_bar = $TimerBar
@onready var label: Label = $Label
@onready var pause_button: Button = $Button  # 普通Button，不是CheckButton

var max_time: float = 2
var current_time: float = 2
var is_running: bool = true

signal time_up

func _ready():
	timer_bar.max_value = max_time
	timer_bar.value = current_time
	update_display()
	pause_button.text = "II"  # 初始化为暂停符号，表示当前是“运行中”
	pause_button.pressed.connect(_on_pause_button_pressed)

func _process(delta):
	if is_running:
		current_time -= delta
		update_display()
		if current_time <= 0:
			time_up.emit()
			reset_timer()

func _on_pause_button_pressed():
	is_running = !is_running
	pause_button.text = "▶" if !is_running else "⏸"  # 运行时显示暂停符号，暂停时显示播放符号

func reset_timer():
	current_time = max_time
	update_display()

func update_display():
	timer_bar.value = current_time
	label.text = "%.1fs" % current_time
