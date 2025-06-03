extends Node2D

signal new_moon_drawn

func _ready() -> void:
	new_moon_drawn.emit()
