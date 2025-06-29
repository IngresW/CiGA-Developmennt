extends CanvasLayer

var score = 100

func update_score():
	$ScoreLabel.text = str(score)

func change_score_reacted(tile1: int, tile2: int):
	pass

func change_score_changed(tile: int):
	pass

func _on_reacted(tile1: int, tile2: int):
	change_score_reacted(tile1,tile2)
	update_score()

func _on_tile_changed(tile:int):
	change_score_changed(tile)
	update_score()
