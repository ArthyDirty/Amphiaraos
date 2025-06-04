extends Node


var deck: Deck = null

var hide_next = false


func _on_card_drawn(card_drawn : Card):
	if hide_next:
		hide_next = false
		card_drawn.hide_card_on_draw()
		return
	
	card_drawn.card_flipped.connect(_on_card_flipped)
	
	


func _on_card_flipped(card):
	var power_type = card.data.power_type
	PowerTypes.apply_power(power_type, card, deck)


func set_hide_next(state: bool):
	hide_next = state


func should_hide_next() -> bool:
	return hide_next


func copy_card(card):
	# reste à implémenter le choix de la carte et à charger le card_data correspondant
	# choix de la carte possible soit par sélection d'une carte déjà posée
	# soit une carte parmis les cartes intitialement présentes dans le deck
	
	var card_data = preload("res://Scenes/Cards/blank_card.tres")
	# transforme et brule la carte en la carte selectionnée (pour l'instant blank_card par défaut)
	card.set_card_data(card_data)
	card.burn_card()
	card.card_animated_sprite.play("verso")


func set_deck(new_deck: Deck) -> void:
	deck = new_deck
	# Connecter ou reconnecter le signal, par exemple
	if deck:
		deck.card_drawn.connect(_on_card_drawn)
