extends Label

@onready var scene_node = get_tree().get_root().get_node("Main/Scene")

func _process(delta: float) -> void:
	self.text = str(scene_node.current_cost) + "c"
	self.modulate = Color.BLACK
