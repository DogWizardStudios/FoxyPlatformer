extends Node

signal reset_player_position
signal spawn_scene(pos: Vector2, scene: PackedScene)
signal spawn_bullet(velocity: Vector2, start_pos: Vector2, scene: PackedScene)


func emit_reset_player_position() -> void:
	reset_player_position.emit()

func emit_spawn_scene(pos: Vector2, scene: PackedScene):
	spawn_scene.emit(pos, scene)

func emit_spawn_bullet(velocity: Vector2, start_pos: Vector2, scene: PackedScene):
	spawn_bullet.emit(velocity, start_pos, scene)
