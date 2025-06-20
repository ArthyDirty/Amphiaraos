class_name PowerTypes

extends Node

enum PowerType {
	NONE,
	HIDE_WHEN_PLACED,
	HIDE_NEXT,
	COPY,
	HIDE_PLACED_CARDS
}

var last_card

static func apply_power(power_type: PowerType, card: Card, deck: Deck = null):
	match power_type:
		PowerType.HIDE_WHEN_PLACED:
			card.hide_card()

		PowerType.HIDE_NEXT:
			if deck:
				PowerManager.set_hide_next(true)

		PowerType.COPY:
			PowerManager.copy_card(card)
			
		
		PowerType.HIDE_PLACED_CARDS:
			card.can_move = false
			PowerManager.hide_placed_cards()
			card.card_animated_sprite.material = preload("res://Scenes/Test/dissolve_test.tres")
			card.shadow.material = preload("res://Scenes/Test/dissolve_test.tres")
			card.card_animated_sprite.play_dissolve()
			WinManager.cards_in_game.pop_back()

		PowerType.NONE:
			pass


	
