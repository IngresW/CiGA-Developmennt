extends Label
@onready var scene: Node2D = $".."

func _process(delta: float) -> void:
	self.text = str(scene.current_cost) + "c"
