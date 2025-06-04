extends Node


var deck: Deck = null

var hide_next = false


func _on_card_drawn(card_drawn : Card):
	if hide_next:
		hide_next = false
		card_drawn.hide_card_on_draw()
		return
	
	var power_type = card_drawn.data.power_type
	PowerTypes.apply_power(power_type, card_drawn, deck)


func set_hide_next(state: bool):
	hide_next = state


func should_hide_next() -> bool:
	return hide_next


func set_deck(new_deck: Deck) -> void:
	deck = new_deck
	# Connecter ou reconnecter le signal, par exemple
	if deck:
		deck.card_drawn.connect(_on_card_drawn)
