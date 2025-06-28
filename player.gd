extends CharacterBody2D

@export var move_speed :int = 100
@export var animator : AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#d	velocity =Vector2(50,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = Input.get_vector("move_left","move_right","move_up","move_down")*move_speed
	#如果速度为0，播放待机动画
	if velocity == Vector2.ZERO:
		animator.play("idle")
	#如果速度不为0，播放跑步动画
	else:
		animator.play("run")
	move_and_slide()
