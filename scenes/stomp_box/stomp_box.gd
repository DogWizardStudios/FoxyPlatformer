class_name StompBox

extends Area2D

signal stomped

@export var explosion_scene: PackedScene

var _hit: bool = false

var is_hit: bool:
	get: return _hit

func trigger() -> void:
	if _hit: return
	_hit = true
	stomped.emit()
	if explosion_scene:
		SignalHub.emit_spawn_scene(global_position, explosion_scene)
