extends Node2D


@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var muzzle: Marker2D = $Muzzle


func _on_timer_timeout() -> void:
	animation_player.play("shoot")

func _on_screen_entered() -> void:
	timer.start()

func _on_screen_exited() -> void:
	timer.stop()

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shoot":
		animation_player.play("idle")
