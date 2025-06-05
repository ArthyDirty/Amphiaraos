extends Area2D
class_name Card

# === Données et références ===
var data: CardData

@onready var card: Card = $"."  # Référence à soi-même (peu utile ici)
@onready var card_animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var surbrillance_animated_sprite: AnimatedSprite2D = $SurbrillanceAnimatedSprite
@onready var shadow: AnimatedSprite2D = $Shadow

# === États internes ===
var card_clicked = false
var card_placed = false
var card_hidden = false
var card_revealed = false
var hide_when_placed = false
var can_move = true

# === Données de placement ===
var emplacement_hover = false
var emplacement_pos
var last_emplacement
var last_pos
var dif_pos

# === Signaux ===
signal card_flipped(card)


# ============================================================
# ============= 1. Initialisation et chargement ==============
# ============================================================

func _ready():
	if data == null:
		print("Pas de CardData assignée")
		return

	_load_sprite_frames()

	if !card_hidden:
		card_animated_sprite.play("flip")
		await card_animated_sprite.animation_finished
		card_flipped.emit(card)
	else:
		card_animated_sprite.play("hidden")

	surbrillance_animated_sprite.play("default")
	last_pos = card.global_position


func _load_sprite_frames():
	var frames = load(data.sprite_frames_path)
	var surbrillance_frames = load(data.surbrillance_sprite_frames_path)

	if frames == null:
		print("Impossible de charger SpriteFrames depuis ", data.sprite_frames_path)
		return
	if surbrillance_frames == null:
		print("Impossible de charger Surbrillance depuis ", data.surbrillance_sprite_frames_path)
		return

	card_animated_sprite.frames = frames
	surbrillance_animated_sprite.frames = surbrillance_frames


# ============================================================
# ============= 2. Déplacement de la carte ===================
# ============================================================

func _process(_delta):
	if card_clicked and not card_placed and can_move:
		_drag_card()
	elif card_placed and hide_when_placed and not card_revealed:
		card_animated_sprite.play("hide")
		card_hidden = true
		hide_when_placed = false

func _drag_card():
	var mouse_pos = get_viewport().get_mouse_position()
	card.global_position = mouse_pos + dif_pos
	card_animated_sprite.position = -(card.global_position + Vector2(0, 500)) * 0.2


# ============================================================
# ============= 3. Événements souris =========================
# ============================================================

func _on_card_button_down():
	if not can_move or card_placed:
		return
	card_clicked = true
	last_pos = card.global_position
	dif_pos = card.global_position - get_viewport().get_mouse_position()
	card.z_index = 5
	shadow.visible = true
	surbrillance_animated_sprite.play("default")


func _on_card_button_up():
	card_clicked = false
	card.z_index = 3

	if emplacement_hover:
		_place_card_with_animation()
	else:
		_return_to_last_position()


func _on_card_button_mouse_entered():
	if not card_clicked and not card_placed and can_move:
		surbrillance_animated_sprite.play("surbrillance")


func _on_card_button_mouse_exited():
	surbrillance_animated_sprite.play("default")


# ============================================================
# ============= 4. Placement / Retour ========================
# ============================================================

func _place_card_with_animation():
	var distance = card.global_position.distance_to(emplacement_pos)
	var duration = distance / 3000.0
	var overshoot = (card.global_position - emplacement_pos) * 0.02
	var overshoot_pos = emplacement_pos - overshoot

	var tween = create_tween()
	tween.tween_property(card, "global_position", overshoot_pos, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "global_position", emplacement_pos, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	last_emplacement.place_card(data.name)
	card_placed = true
	shadow.visible = false
	card_animated_sprite.position = Vector2.ZERO


func _return_to_last_position():
	var distance = card.global_position.distance_to(last_pos)
	var duration = distance / 3000.0
	var overshoot = (card.global_position - last_pos) * 0.02
	var overshoot_pos = last_pos - overshoot

	var tween = create_tween()
	tween.tween_property(card, "global_position", overshoot_pos, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "global_position", last_pos, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	shadow.visible = false
	card_animated_sprite.position = Vector2.ZERO

	if can_move:
		surbrillance_animated_sprite.play("surbrillance")
	else:
		surbrillance_animated_sprite.play("default")


# ============================================================
# ============= 5. Interaction avec l’emplacement ============
# ============================================================

func _on_emplacement_entered(emplacement):
	if emplacement.is_free():
		emplacement_hover = true
		emplacement_pos = emplacement.global_position
		last_emplacement = emplacement

func _on_emplacement_exited(_emplacement):
	emplacement_hover = false


# ============================================================
# ============= 6. Fonctions publiques =======================
# ============================================================

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
	burn_sprite.frames = preload("res://Sprites/Sprite frames/sun_sprite_frames.tres")
	burn_sprite.z_index = 6
	add_child(burn_sprite)
	burn_sprite.play("burn")


# ============================================================
# ============= 7. Setter pour les données ===================
# ============================================================

func set_card_data(card_data: CardData) -> void:
	data = card_data
	if card_animated_sprite:
		_load_sprite_frames()
