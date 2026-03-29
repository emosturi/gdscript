extends CharacterBody2D

## Enemigo que cruza la pantalla en dirección aleatoria (estilo tutorial Dodge the Creeps).

const MIN_SPEED := 150.0
const MAX_SPEED := 280.0

func _ready() -> void:
	add_to_group("mob")
	motion_mode = MOTION_MODE_FLOATING
	var angle := randf_range(0.0, TAU)
	var spd := randf_range(MIN_SPEED, MAX_SPEED)
	velocity = Vector2.from_angle(angle) * spd
	rotation = angle + PI / 2.0

func _physics_process(_delta: float) -> void:
	move_and_slide()
