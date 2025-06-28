extends CharacterBody2D

@export var speed: float = 2000.0         # 左右移动速度
@export var jump_velocity: float = -2000  # 跳跃初始速度（负数表示向上）
@export var gravity: float = 9800.0      # 重力加速度（越大落得越快）

var direction := Vector2.ZERO

func _physics_process(delta):
	# 横向输入
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = direction.x * speed

	# 应用重力（如果不在地面，就持续下落）
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0  # 确保站在地上时垂直速度归零

	# 跳跃：按下 Space 且站在地面
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# 移动
	move_and_slide()
