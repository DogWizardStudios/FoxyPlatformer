extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		SignalHub.emit_reset_player_position()
	if body is EnemyBase:
		body.queue_free()
