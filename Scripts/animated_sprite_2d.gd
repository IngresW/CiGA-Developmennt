extends AnimatedSprite2D

func _ready():
	# 游戏开始时调用一次
	update_scale_to_fill_parent()

func _process(delta):
	# 如果你需要在编辑器中拖动父节点大小时实时更新，可以保留这部分
	if Engine.is_editor_hint():
		update_scale_to_fill_parent()

func update_scale_to_fill_parent():
	# 1. 获取父节点，并确保它是一个Control节点
	var parent = get_parent()
	if not parent or not parent.has_method("get_size"):
		# 如果父节点不是Control类型，它没有size属性，无法填充
		return

	# 2. 获取父节点的尺寸
	var parent_size = parent.size

	# 3. 获取当前动画帧的原始尺寸
	if not sprite_frames or not sprite_frames.has_animation(animation):
		return
	
	# 使用第一帧的纹理作为尺寸参考
	var frame_texture = sprite_frames.get_frame_texture(animation, 0)
	if not frame_texture:
		return
	var frame_size = frame_texture.get_size()

	# 4. 避免除以零的错误
	if frame_size.x == 0 or frame_size.y == 0:
		return

	# 5. 计算需要的缩放比例
	var scale_x = parent_size.x / frame_size.x
	var scale_y = parent_size.y / frame_size.y

	# 6. 应用缩放
	self.scale = Vector2(scale_x, scale_y)
	
	# 提示：如果你想保持宽高比，可以使用以下代码替换第6步
	# var uniform_scale = min(scale_x, scale_y) # 取较小的缩放值以保证完整显示
	# self.scale = Vector2(uniform_scale, uniform_scale)
	# self.position = parent_size / 2 # 并将其居中
