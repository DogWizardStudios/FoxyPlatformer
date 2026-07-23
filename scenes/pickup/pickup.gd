extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var anim: AnimatedSprite2D = $Anim
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	anim.animation = (anim.sprite_frames.get_animation_names() as Array[String]).pick_random()
	anim.play()



func _on_area_2d_body_entered(_body: Node2D) -> void:
	anim.hide()
	audio_stream_player.play()
	area_2d.set_deferred("monitoring", false)
	await audio_stream_player.finished
	queue_free()

func _on_delay_timer_timeout() -> void:
	area_2d.set_deferred("monitoring", true)
