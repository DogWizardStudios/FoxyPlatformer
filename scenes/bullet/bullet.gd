class_name Bullet extends Area2D

var _velocity: Vector2 = Vector2.ZERO

func setup(velocity: Vector2, start_pos: Vector2) -> void:
	global_position = start_pos
	_velocity = velocity

func _physics_process(delta: float) -> void:
	position += _velocity * delta


func _on_area_entered(_area: Area2D) -> void:
	queue_free()
