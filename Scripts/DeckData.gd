class_name DeckData

extends Resource

@export var deck_name: String = ""
@export var cards: Array[PackedScene]

func get_deck_copy() -> Array[PackedScene]:
	return cards.duplicate(true)  # 'true' pour une duplication profonde
