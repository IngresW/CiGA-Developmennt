extends Sprite2D

@export var rect: Rect2
var building_type: int = 0

func set_building_type(type: int):
	building_type = type
	
func get_global_rect():
	return Rect2(
		global_position - rect.size / 2,
		rect.size
	)
	
func set_on_place():
	modulate.a = 1
