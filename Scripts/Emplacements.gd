class_name Emplacement

extends Area2D

@onready var emplacement: Emplacement = $"."
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


@export var emp_col = 0
@export var emp_row = 0

var card_owned_name = ""

signal card_placed(emp_col, emp_row, card_name, emplacement)


func get_col():
	return emp_col
	
func get_row():
	return emp_row


func place_card(card_name):
	card_owned_name = card_name
	card_placed.emit(emp_col, emp_row, card_owned_name, emplacement)


func is_free():
	if card_owned_name == "":
		return true
	else:
		return false
