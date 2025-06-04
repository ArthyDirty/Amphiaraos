class_name PowerTypes

extends Node

enum PowerType {
	NONE,
	HIDE_WHEN_PLACED,
	HIDE_NEXT,
	COPY,
}

static func apply_power(power_type: PowerType, card: Card, deck: Deck = null):
	match power_type:
		PowerType.HIDE_WHEN_PLACED:
			card.hide_card_when_placed()

		PowerType.HIDE_NEXT:
			if deck:
				PowerManager.set_hide_next(true)

		PowerType.COPY:
			PowerManager.copy_card(card)
			

		PowerType.NONE:
			pass
