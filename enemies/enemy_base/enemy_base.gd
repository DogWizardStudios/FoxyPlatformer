class_name EnemyBase

extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var wall_ray: RayCast2D = $WallRay
@onready var floor_ray: RayCast2D = $FloorRay
@onready var hit_area: Area2D = $HitArea
@onready var timer: Timer = $Timer

@export var gravity: float = 690.0
@export var speed: float = 120.0

var _direction: int = -1 #left
var _hit: bool = false

func _update_behaviour(_delta: float) -> void:
	pass

func _apply_gravity(_delta: float) -> void:
	velocity.y += gravity * _delta

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_update_behaviour(delta)
	move_and_slide()

func do_walk() -> void:
	if wall_ray.is_colliding() or not floor_ray.is_colliding():
		_direction = -_direction
		_flip_raycasts()
		flip_sprite()
	velocity.x = _direction * speed


func flip_sprite() -> void:
	animated_sprite_2d.flip_h = _direction == 1
	# -1 is left, so if direction is right, the above evaluates to true

func _flip_raycasts() -> void:
	wall_ray.target_position *= -1
	floor_ray.position.x *= -1


func _on_stomp_box_stomped() -> void:
	if _hit: return
	_hit = true
	animated_sprite_2d.play("hit")
	set_physics_process.call_deferred(false)
	hit_area.set_monitorable.call_deferred(false)


func _on_animation_finished() -> void:
	if animated_sprite_2d.animation == "hit":
		queue_free()

func _on_timer_timeout() -> void:
	pass # Replace with function body.
