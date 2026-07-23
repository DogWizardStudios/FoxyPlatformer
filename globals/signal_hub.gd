extends Node

signal reset_player_position
signal spawn_scene(pos: Vector2, scene: PackedScene)


func emit_reset_player_position() -> void:
	reset_player_position.emit()

func emit_spawn_scene(pos: Vector2, scene: PackedScene):
	spawn_scene.emit(pos, scene)
