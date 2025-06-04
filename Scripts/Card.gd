extends Area2D
class_name Card

var data: CardData

@onready var card: Card = $"."
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
	var surbrillance_frames = load(data.surbrillance_sprite_frames_path)
	if frames == null:
		print("Impossible de charger SpriteFrames depuis ", data.sprite_frames_path)
		return
	if surbrillance_frames == null:
		print("Impossible de charger SurbrillanceSpriteFrames depuis ", data.surbrillance_sprite_frames_path)
		return
	
	card_animated_sprite.frames = frames
	surbrillance_animated_sprite.frames = surbrillance_frames
	if !card_hidden:
		card_animated_sprite.play("flip")
	else:
		card_animated_sprite.play("hidden")
		
	surbrillance_animated_sprite.play("default")
	last_pos = card.global_position

func _process(_delta):
	var mouse_pos = get_viewport().get_mouse_position()
	if card_clicked and not card_placed:
		card.global_position = mouse_pos + dif_pos
	
	if card_placed and hide_when_placed and not card_revealed:
		card_animated_sprite.play("hide")
		card_hidden = true
		hide_when_placed = false

func _on_card_button_down():
	card_clicked = true
	last_pos = card.global_position
	surbrillance_animated_sprite.play("default")
	dif_pos = card.global_position - get_viewport().get_mouse_position()
	card.z_index = 5

func _on_card_button_up():
	card_clicked = false
	card.z_index = 3
	
	if emplacement_hover:
		card.global_position = emplacement_pos
		last_emplacement.place_card(data.name)
		card_placed = true
	else:
		# Animation fluide pour retour à la position initiale
		var tween = create_tween()
		tween.tween_property(card, "global_position", last_pos, 0.2)
		surbrillance_animated_sprite.play("surbrillance")

func _on_card_button_mouse_entered():
	if not card_clicked and not card_placed:
		surbrillance_animated_sprite.play("surbrillance")

func _on_card_button_mouse_exited():
	surbrillance_animated_sprite.play("default")

func _on_emplacement_entered(emplacement):
	if emplacement.is_free():
		emplacement_hover = true
		emplacement_pos = emplacement.global_position
		last_emplacement = emplacement

func _on_emplacement_exited(_emplacement):
	emplacement_hover = false

func hide_card_on_draw():
	card_hidden = true

func hide_card_when_placed():
	hide_when_placed = true

func show_card():
	card_revealed = true
	if card_hidden:
		card_animated_sprite.play("flip")

func set_card_data(card_data: CardData) -> void:
	data = card_data
