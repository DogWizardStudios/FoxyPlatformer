class_name Trampoline

extends Area2D

@onready var boing_sound: AudioStreamPlayer = $BoingSound
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var bounce_velocity: Vector2 = Vector2(0.0, -400.0)

var bouncing: bool:
	get: return animated_sprite_2d.is_playing()

func bounce() -> void:
	animated_sprite_2d.play("bounce")
	boing_sound.play()
