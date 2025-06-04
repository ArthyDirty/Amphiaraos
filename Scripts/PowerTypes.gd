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
			#reste à implémenter le choix de la carte et à charger le card_data correspondant
			card.set_card_data(preload("res://Scenes/Cards/new_moon.tres"))
			card.burn_card()
			card.card_animated_sprite.play("verso")

		PowerType.NONE:
			pass
