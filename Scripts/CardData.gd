class_name CardData
extends Resource

const PowerTypes = preload("res://Scripts/PowerTypes.gd")

@export var name: String = "blank"
@export var power_type: PowerTypes.PowerType = PowerTypes.PowerType.NONE
@export var sprite_frames_path: String = "res://Sprites/Sprite frames/blank_card_sprite_frames.tres"
@export var surbrillance_sprite_frames_path: String = "res://Sprites/Sprite frames/surbrillance_sprite_frames.tres"
