extends Node


var deck: Deck = null

var hide_next = false
var reveal_hidden_card = false

var cards_in_game: Array[Card] = []


func _process(delta: float) -> void:
	cards_in_game = GameData.cards_in_game


func _on_card_drawn(card_drawn : Card):
	cards_in_game.append(card_drawn)
	if hide_next:
		hide_next = false
		card_drawn.hide_card_on_draw()
		return
	card_drawn.card_flipped.connect(_on_card_flipped)


func _on_card_flipped(card):
	var power_type = card.data.power_type
	PowerTypes.apply_power(power_type, card, deck)


func on_card_clicked(card: Card):
	if reveal_hidden_card and card.card_hidden:
		card.show_card()
		reveal_hidden_card = false
		
		dissolve_last()
		

### Pouvoirs :

func set_hide_next(state: bool):
	hide_next = state


func should_hide_next() -> bool:
	return hide_next


func hide_placed_cards():
	for card in cards_in_game:
		if card:
			card.hide_card()


func copy_card(card : Card):
	card.can_move = false
	
	# choix d'une carte parmis celle du deck moon
	var copy_choice_scene = preload("res://Scenes/Utilities/copy_choice.tscn")
	var copy_choice = copy_choice_scene.instantiate()
	card.add_child(copy_choice)
	var selected_card_path = await copy_choice.copied_card
	
	var card_data = load(selected_card_path)
	# transforme et brule la carte en la carte selectionnée (pour l'instant blank_card par défaut)
	card.set_card_data(card_data)
	card.burn_card()
	card.card_animated_sprite.play("verso")
	
	card.can_move = true


func show_selected():
	for card  in cards_in_game:
		if card and card.card_hidden:
			reveal_hidden_card = true
			print("reveal selected card ", reveal_hidden_card)
			return
	dissolve_last()


func dissolve_last():
	var card = GameData.last_card_drawn
	card.card_animated_sprite.play_dissolve()


func set_deck(new_deck: Deck) -> void:
	cards_in_game = GameData.cards_in_game
	hide_next = false
	deck = new_deck
	# Connecter ou reconnecter le signal, par exemple
	if deck:
		deck.card_drawn.connect(_on_card_drawn)
