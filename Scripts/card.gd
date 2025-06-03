class_name Card

extends Area2D

@export var card: Node2D
@export var card_name: String
@export var card_animated_sprite: AnimatedSprite2D

@onready var surbrillance_animated_sprite: AnimatedSprite2D = $SurbrillanceAnimatedSprite

var card_hidden = false
var card_clicked = false
var card_placed = false
var card_revealed = false

var hide_when_placed = false

var emplacement_hover = false # indique si la carte survol un emplacement
var emplacement_pos # position de l'emplacement survolé
var last_emplacement

var last_pos # position de la carte avant d'être cliqué
var dif_pos # différence de position entre la souris et le centre de la carte lors du click

# initialisation
func _ready() -> void:
	last_pos = card.global_position
	if !card_hidden:
		card_animated_sprite.play("flip")
	else:
		card_animated_sprite.play("hidden")

#gère le déplacement de la carte si elle n'est pas déjà placée
func _process(delta: float) -> void:
	var mouse_position = get_viewport().get_mouse_position()
	if card_clicked and !card_placed:
		card.global_position = mouse_position + dif_pos
	if card_placed and hide_when_placed and !card_revealed:
		print("card_revealed ", card_revealed)
		card_animated_sprite.play("hide")
		card_hidden = true
		hide_when_placed = false


func get_card_name():
	return card_name


func hide_card():
	card_hidden = true


func hide_card_when_placed():
	hide_when_placed = true


func show_card():
	card_revealed = true
	if card_hidden:
		card_animated_sprite.play("flip")


func _on_card_button_down() -> void:
	card_clicked = true
	last_pos = card.global_position
	surbrillance_animated_sprite.play("nothing")
	dif_pos = card.get_global_position() - get_viewport().get_mouse_position()
	card.z_index = 5 # place la carte devant tout lorsque cliquée


func _on_card_button_up() -> void:
	card_clicked = false
	card.z_index = 3
	
	if emplacement_hover:
		card.global_position = emplacement_pos
		last_emplacement.place_card(card_name)
		card_placed = true
	else:
		card.global_position = last_pos
		surbrillance_animated_sprite.play("surbrillance")


func _on_card_button_mouse_entered() -> void:
	if !card_clicked  and !card_placed:
		surbrillance_animated_sprite.play("surbrillance")


func _on_card_button_mouse_exited() -> void:
	surbrillance_animated_sprite.play("nothing")


func _on_emplacement_entered(emplacement: Emplacement) -> void:
	if emplacement.is_free():
		emplacement_hover = true
		emplacement_pos = emplacement.global_position
		last_emplacement = emplacement


func _on_emplacement_exited(emplacement: Emplacement) -> void:
	emplacement_hover = false
