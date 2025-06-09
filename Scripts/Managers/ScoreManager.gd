extends Node

var score = 0
var highscore = 0

func _ready() -> void:
	WinManager.score_changed.connect(_on_score_change)


func _on_score_change(points_scored):
	score += points_scored
	print("total score = ", score)

#reste à afficher le score et le highscore en UI

func cleanup():
	highscore = score
	score = 0
