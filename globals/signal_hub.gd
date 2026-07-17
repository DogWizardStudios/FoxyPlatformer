extends Node

signal reset_player_position

func emit_reset_player_position() -> void:
	reset_player_position.emit()
