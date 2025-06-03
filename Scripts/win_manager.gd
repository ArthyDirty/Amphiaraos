extends Node

@export var deck : Deck

var Emplacements

var col_max = 0
var row_max = 0

var card_in_game = []
var jeu = []
var jeu_emplacements = []

func _ready() -> void:
	deck.card_drawn.connect(_on_card_drawn)
	
	Emplacements = get_tree().get_nodes_in_group("emplacements")
	for element in Emplacements:
		element.card_placed.connect(_on_card_placed)
		var col = element.get_col()
		var row = element.get_row()
		if col > col_max:
			col_max = col
		if row > row_max:
			row_max = row
	
	for i in range(col_max + 1):
		var col = []
		for j in range(row_max + 1):
			col.append("")
		jeu.append(col)
	
	for i in range(col_max + 1):
		var col = []
		for j in range(row_max + 1):
			col.append("")
		jeu_emplacements.append(col)

# appelée lorsqu'une carte est placée sur un emplacement
func _on_card_placed(emp_col, emp_row, card_name, node):
	jeu[emp_col][emp_row] = card_name
	jeu_emplacements[emp_col][emp_row] = node
	_check_alignement()

#verifie les alignements plus grand que 3
func _check_alignement():
	var max_len = max(col_max + 1,row_max + 1)
	for n in range(max_len):
		if max_len - n > 2:
			_check_n_align(max_len - n)


func _on_card_drawn(card_drawn):
	var card = card_drawn.get_child(1)
	card_in_game.append(card)


func win():
	for card in card_in_game:
		card.show_card()

#verifie si n mêmes cartes sont alignées
func _check_n_align(n_align: int = 3) -> bool:
	var directions = [
		Vector2(1, 0),   # → horizontal
		Vector2(0, 1),   # ↓ vertical
		Vector2(1, 1),   # ↘ diagonale
		Vector2(-1, 1),  # ↙ diagonale inversée
	]

	for dir in directions:
		var dx = int(dir.x)
		var dy = int(dir.y)

		for x in range(col_max + 1):
			for y in range(row_max + 1):
				var last_card := ""
				var count := 0
				var positions := []
				var i := 0

				while true:
					var cx = x + dx * i
					var cy = y + dy * i

					if cx < 0 or cy < 0 or cx > col_max or cy > row_max:
						break

					var card = jeu[cx][cy]

					if card == last_card and card != "":
						count += 1
						positions.append(Vector2(cx, cy))
						if count >= n_align:
							for k in range(n_align):
								var pos = positions[-(k + 1)]
								jeu_emplacements[pos.x][pos.y].three_in_row_animated_sprite.play("threeinrow")
							win()
							return true
					else:
						last_card = card
						count = 1 if card != "" else 0
						positions = [Vector2(cx, cy)] if card != "" else []

					i += 1

	return false
