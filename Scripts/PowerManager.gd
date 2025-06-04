class_name PowerManager

extends Node


const PowerTypes = preload("res://Scripts/PowerTypes.gd")
@onready var deck: Deck = $".."

var hide_next = false

func _ready() -> void:
	deck.card_drawn.connect(_on_card_drawn)


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
