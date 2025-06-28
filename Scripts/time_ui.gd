extends Control

@onready var timer_bar = $TimerBar
@onready var label: Label = $Label
@onready var pause_button: CheckButton = $PauseButton

var max_time: float = 15.0
var current_time: float = 15.0
var is_running: bool = false

signal time_up

func _ready():
	# 初始化进度条
	timer_bar.max_value = max_time
	timer_bar.value = current_time
	update_display()
	pause_button.pressed.connect(_on_pause_button_pressed)

func _process(delta):
	if is_running:
		current_time -= delta
		update_display()
		
		if current_time <= 0:
			time_up.emit()
			reset_timer()
			
func _on_pause_button_pressed():
	if not is_running:
		is_running = true
	else:
		is_running = false

func reset_timer():
	current_time = max_time
	update_display()

func update_display():
	timer_bar.value = current_time
	label.text = "%.1fs" % current_time
