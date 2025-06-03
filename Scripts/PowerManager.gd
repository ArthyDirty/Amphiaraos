extends Node

@export var deck : Deck

var hide_next = false
var hidden = false

var card
var card_behaviour
var card_name

func _ready() -> void:
	deck.card_drawn.connect(_on_card_drawn)


func _on_card_drawn(card_drawn):
	card = card_drawn
	card_behaviour = card_drawn.get_child(1)
	card_name = card_behaviour.get_card_name()
	
	hide_next_card()
	hide_when_placed()


func hide_next_card():
	hidden = hide_next
	if hide_next:
		card_behaviour.hide_card()
		hide_next = false
	elif card_name == "New_moon" and !hidden:
		hide_next = true


func hide_when_placed():
	if card_name == "Half_moon" and !hidden:
		card_behaviour.hide_card_when_placed()
