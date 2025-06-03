extends Area2D
class_name Card

@export var data: CardData

@onready var card_animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var surbrillance_animated_sprite: AnimatedSprite2D = $SurbrillanceAnimatedSprite

var card_clicked = false
var card_placed = false
var card_hidden = false
var card_revealed = false
var hide_when_placed = false

var emplacement_hover = false
var emplacement_pos
var last_emplacement

var last_pos
var dif_pos

func _ready():
	if data == null:
		print("Pas de CardData assignée")
		return
	
	var frames = load(data.sprite_frames_path)
	if frames == null:
		print("Impossible de charger SpriteFrames depuis ", data.sprite_frames_path)
		return
	
	card_animated_sprite.frames = frames
	card_animated_sprite.play("flip")
	last_pos = card_animated_sprite.global_position

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	if card_clicked and not card_placed:
		card_animated_sprite.global_position = mouse_pos + dif_pos
	
	if card_placed and hide_when_placed and not card_revealed:
		card_animated_sprite.play("hide")
		card_hidden = true
		hide_when_placed = false

func _on_card_button_down():
	card_clicked = true
	last_pos = card_animated_sprite.global_position
	surbrillance_animated_sprite.play("nothing")
	dif_pos = card_animated_sprite.global_position - get_viewport().get_mouse_position()
	card_animated_sprite.z_index = 5

func _on_card_button_up():
	card_clicked = false
	card_animated_sprite.z_index = 3
	
	if emplacement_hover:
		card_animated_sprite.global_position = emplacement_pos
		last_emplacement.place_card(data.name)
		card_placed = true
	else:
		card_animated_sprite.global_position = last_pos
		surbrillance_animated_sprite.play("surbrillance")

func _on_card_button_mouse_entered():
	if not card_clicked and not card_placed:
		surbrillance_animated_sprite.play("surbrillance")

func _on_card_button_mouse_exited():
	surbrillance_animated_sprite.play("nothing")

func _on_emplacement_entered(emplacement):
	if emplacement.is_free():
		emplacement_hover = true
		emplacement_pos = emplacement.global_position
		last_emplacement = emplacement

func _on_emplacement_exited(emplacement):
	emplacement_hover = false

func hide_card():
	card_hidden = true
	card_animated_sprite.play("hidden")

func hide_card_when_placed():
	hide_when_placed = true

func show_card():
	card_revealed = true
	if card_hidden:
		card_animated_sprite.play("flip")
