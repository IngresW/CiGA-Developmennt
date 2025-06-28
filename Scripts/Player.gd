extends CharacterBody2D

@export var SPEED: float = 2000.0         # 左右移动速度
@export var jump_velocity: float = -2000  # 跳跃初始速度（负数表示向上）
@export var gravity: float = 9800.0      # 重力加速度（越大落得越快）
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var direction := Vector2.ZERO

func _physics_process(delta):
	# 横向输入


	# 应用重力（如果不在地面，就持续下落）
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0  # 确保站在地上时垂直速度归零

	# 跳跃：按下 Space 且站在地面
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# 移动
	var direction := Input.get_axis("Move_Left", "Move_Right")
	animated_sprite_2d.flip_h = direction >= 0
	
	if is_on_floor() :
		if direction == 0:
			animated_sprite_2d.play("Idle")
		else:
			animated_sprite_2d.play("Move")
	else:
		animated_sprite_2d.play("Jump")
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
