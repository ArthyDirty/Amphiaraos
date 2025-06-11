extends Node


var cards_in_game: Array[Card] = []
var deck: Deck = null

var last_card_drawn: Card


func _ready() -> void:
	print("GameData loaded")


func _process(delta: float) -> void:
	clean_cards_in_game()


func _on_card_drawn(card: Card):
	cards_in_game.append(card)
	last_card_drawn = card


func clean_cards_in_game():
	var index = 0
	for card in cards_in_game:
		if !card:
			cards_in_game.remove_at(index)
		index += 1


func set_deck(new_deck: Deck) -> void:
	cards_in_game = []
	deck = new_deck
	if deck:
		deck.card_drawn.connect(_on_card_drawn)
