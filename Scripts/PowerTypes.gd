extends Node

enum PowerType {
	NONE,
	HIDE_WHEN_PLACED,
	HIDE_NEXT,
	COPY,
}

static func apply_power(power_type: PowerType, card, deck = null):
	match power_type:
		PowerType.HIDE_WHEN_PLACED:
			card.hide_card_when_placed()

		PowerType.HIDE_NEXT:
			if deck:
				deck.get_node("PowerManager").set_hide_next(true)

		PowerType.COPY:
			print("Pouvoir COPY non encore implémenté")

		PowerType.NONE:
			pass
