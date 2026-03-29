extends CharacterBody2D

signal hit

## Vista cenital: te mueves en el plano XY sin gravedad.
const SPEED := 280.0

var _dead := false

func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING

func _physics_process(_delta: float) -> void:
	if _dead:
		return
	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if dir.length_squared() < 0.01:
		dir = Vector2(
			float(Input.is_physical_key_pressed(KEY_D)) - float(Input.is_physical_key_pressed(KEY_A)),
			float(Input.is_physical_key_pressed(KEY_S)) - float(Input.is_physical_key_pressed(KEY_W))
		)
	if dir.length_squared() > 0.01:
		dir = dir.normalized()
		velocity = dir * SPEED
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	for i in get_slide_collision_count():
		var collider := get_slide_collision(i).get_collider()
		if collider and collider.is_in_group("mob"):
			_dead = true
			velocity = Vector2.ZERO
			hit.emit()
			set_physics_process(false)
			return
