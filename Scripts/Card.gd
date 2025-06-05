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
var can_move = true

var emplacement_hover = false
var emplacement_pos
var last_emplacement

var last_pos
var dif_pos

signal card_flipped(card)


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
		await card_animated_sprite.animation_finished
		card_flipped.emit(card)
	else:
		card_animated_sprite.play("hidden")
		
	surbrillance_animated_sprite.play("default")
	last_pos = card.global_position

func _process(_delta):
	var mouse_pos = get_viewport().get_mouse_position()
	if card_clicked and not card_placed and can_move:
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
		# Animation fluide pour retour à la position initiale
		var distance = card.global_position.distance_to(emplacement_pos)
		var speed = 3000  # pixels par seconde, ajuste à ta convenance
		var duration = distance / speed
		
		var tween = create_tween()
		# Étape 1 : va un peu plus loin que la position cible
		var overshoot = (card.global_position - emplacement_pos) * 0.02
		var overshoot_pos = emplacement_pos - overshoot
		tween.tween_property(card, "global_position", overshoot_pos, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		# Étape 2 : revient à la vraie position
		tween.tween_property(card, "global_position", emplacement_pos, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		last_emplacement.place_card(data.name)
		card_placed = true
	else:
		# Animation fluide pour retour à la position initiale
		var distance = card.global_position.distance_to(last_pos)
		var speed = 3000  # pixels par seconde, ajuste à ta convenance
		var duration = distance / speed
		
		var tween = create_tween()
		# Étape 1 : va un peu plus loin que la position cible
		var overshoot = (card.global_position - last_pos) * 0.02
		var overshoot_pos = last_pos - overshoot
		tween.tween_property(card, "global_position", overshoot_pos, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		# Étape 2 : revient à la vraie position
		tween.tween_property(card, "global_position", last_pos, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
		surbrillance_animated_sprite.play("surbrillance") if can_move else surbrillance_animated_sprite.play("default")

func _on_card_button_mouse_entered():
	if not card_clicked and not card_placed and can_move:
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

func burn_card():
	var burn_sprite = AnimatedSprite2D.new()
	add_child(burn_sprite)
	burn_sprite.z_index = 6
	burn_sprite.frames = preload("res://Sprites/Sprite frames/sun_sprite_frames.tres")
	burn_sprite.play("burn")

func set_card_data(card_data: CardData) -> void:
	data = card_data
	if card_animated_sprite:
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
	
