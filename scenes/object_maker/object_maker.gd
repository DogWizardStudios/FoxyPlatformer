extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalHub.spawn_scene.connect(on_spawn_scene)
	SignalHub.spawn_bullet.connect(on_spawn_bullet)

func on_spawn_scene(pos: Vector2, scene: PackedScene):
	if !scene: return
	var ns = scene.instantiate()
	
	if ns is Node2D:
		ns.global_position = pos
	
	add_child.call_deferred(ns)

func on_spawn_bullet(velocity: Vector2, start_pos: Vector2, scene: PackedScene):
	if !scene: return
	var new_bullet: Bullet = scene.instantiate()
	new_bullet.setup(velocity, start_pos)
	add_child.call_deferred(new_bullet)
