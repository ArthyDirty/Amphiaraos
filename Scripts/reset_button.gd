extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_button_mouse_entered() -> void:
	animated_sprite_2d.play("hover")


func _on_button_mouse_exited() -> void:
	animated_sprite_2d.play("default")


func _on_button_button_up() -> void:
	get_tree().reload_current_scene()
