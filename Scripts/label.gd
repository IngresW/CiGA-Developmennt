extends Label

@onready var scene_node = get_tree().get_root().get_node("Main/Scene")

func _process(delta: float) -> void:
	self.text = "Cost: " + str(scene_node.current_cost)
	self.text += "\nScore: " + str(scene_node.score)
	self.modulate = Color.BLACK
