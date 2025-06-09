extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScoreManager.connect("score_changed",_on_score_change)
	text = "Score : %s  |  Highscore : %s" % [0, ScoreManager.highscore]


func _on_score_change():
	text = "Score : %s  |  Highscore : %s" % [ScoreManager.score, ScoreManager.highscore]
	
