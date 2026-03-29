extends Node2D

## Escena principal: aparición de mobs, puntuación por tiempo y fin al chocar.

const MobScene := preload("res://mob.tscn")

@onready var mob_timer: Timer = $MobTimer
@onready var score_timer: Timer = $ScoreTimer
@onready var score_label: Label = $CanvasLayerUI/ScoreLabel
@onready var player: CharacterBody2D = $Player

var score := 0

func _ready() -> void:
	player.hit.connect(_on_player_hit)
	mob_timer.timeout.connect(_on_mob_timer_timeout)
	score_timer.timeout.connect(_on_score_timer_timeout)
	print("Esquiva los cuadrados rojos. WASD o flechas.")

func _on_mob_timer_timeout() -> void:
	var mob: Node2D = MobScene.instantiate()
	mob.global_position = _random_spawn_global()
	add_child(mob)

func _random_spawn_global() -> Vector2:
	var half := get_viewport().get_visible_rect().size * 0.5
	var margin := 80.0
	var c := player.global_position
	var edge := randi() % 4
	match edge:
		0:
			return Vector2(c.x + randf_range(-half.x, half.x), c.y - half.y - margin)
		1:
			return Vector2(c.x + half.x + margin, c.y + randf_range(-half.y, half.y))
		2:
			return Vector2(c.x + randf_range(-half.x, half.x), c.y + half.y + margin)
		_:
			return Vector2(c.x - half.x - margin, c.y + randf_range(-half.y, half.y))

func _on_score_timer_timeout() -> void:
	score += 1
	score_label.text = "Puntos: %d" % score

func _on_player_hit() -> void:
	mob_timer.stop()
	score_timer.stop()
	score_label.text = "Fin — %d pts (F5 o ▶ para reintentar)" % score
	get_tree().call_group("mob", "queue_free")
