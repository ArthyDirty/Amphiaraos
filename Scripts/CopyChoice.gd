extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var card_to_copy

signal copied_card(copied_card_path)

func _ready() -> void:
	card_to_copy = "res://Scenes/Cards/blank_card.tres"

func _on_new_moon_mouse_entered() -> void:
	animated_sprite_2d.play("new_moon")
	card_to_copy = "res://Scenes/Cards/new_moon.tres"


func _on_half_moon_mouse_entered() -> void:
	animated_sprite_2d.play("half_moon")
	card_to_copy = "res://Scenes/Cards/half_moon.tres"


func _on_full_moon_mouse_entered() -> void:
	animated_sprite_2d.play("full_moon")
	card_to_copy = "res://Scenes/Cards/full_moon.tres"


func _on_mouse_exited() -> void:
	animated_sprite_2d.play("default")
	card_to_copy = "res://Scenes/Cards/blank_card.tres"


func _on_button_up() -> void:
	copied_card.emit(card_to_copy)
	queue_free()
