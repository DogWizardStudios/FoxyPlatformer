extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalHub.spawn_scene.connect(on_spawn_scene)


func on_spawn_scene(pos: Vector2, scene: PackedScene):
	if !scene: return
	var ns = scene.instantiate()
	
	if ns is Node2D:
		ns.global_position = pos
	
	add_child.call_deferred(ns)
