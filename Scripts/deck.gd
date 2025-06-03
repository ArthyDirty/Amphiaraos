class_name Deck

extends Node2D

@onready var deck_animated_sprite: AnimatedSprite2D = $DeckAnimatedSprite
@onready var surbrillance_animated_sprite: AnimatedSprite2D = $SurbrillanceAnimatedSprite

@export var deck: Array[PackedScene]

var deck_empty = true

signal card_drawn(card)

func _ready() -> void:
	if !deck.is_empty():
		deck_empty = false
		deck_animated_sprite.play("not_empty")
		deck.shuffle()


func _on_button_up() -> void:
	if !deck_empty:
		var card = deck[0].instantiate()
		card_drawn.emit(card)
		deck.remove_at(0)
		call_deferred("add_child", card)
	
	if deck.is_empty():
		deck_empty = true
		deck_animated_sprite.play("empty")


func _on_button_mouse_entered() -> void:
	if !deck_empty:
		surbrillance_animated_sprite.play("surbrillance")


func _on_button_mouse_exited() -> void:
	surbrillance_animated_sprite.play("nothing")
