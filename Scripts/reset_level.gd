extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _on_button_down() -> void:
	animated_sprite_2d.play("pushed")


func _on_button_up() -> void:
	WinManager.cleanup()
	get_tree().reload_current_scene()
