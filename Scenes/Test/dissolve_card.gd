extends Node2D

var dissolve = false
var dissolve_state: float = 0.0
var speed: float = 100.0 / 2.0  # 100 unités en 5 secondes

var shadow : AnimatedSprite2D
var surbrillance : AnimatedSprite2D

func _ready() -> void:
	shadow = get_parent().get_child(2)
	surbrillance = get_parent().get_child(1)
	dissolve = false

func _process(delta: float) -> void:
	if dissolve_state < 100.0 and dissolve:
		dissolve_state += speed * delta
		dissolve_state = min(dissolve_state, 100.0)
		set_dissolve_state(dissolve_state)
	elif dissolve_state >= 100:
		get_parent().queue_free()

func set_dissolve_state(value: float):
	material.set_shader_parameter("dissolve_state", value)
	shadow.material.set_shader_parameter("dissolve_state", value)

func play_dissolve():
	dissolve_state = 0.0
	set_dissolve_state(dissolve_state)
	surbrillance.queue_free()
	await get_tree().create_timer(0.5).timeout
	dissolve = true
	
