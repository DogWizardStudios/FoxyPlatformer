extends Node

@export var explosion: PackedScene
@onready var enemies: Node = $Enemies

func _unhandled_input(event: InputEvent) -> void:
	var new_explosion = explosion.instantiate()
	new_explosion.position = Vector2(randf_range(0.0, 250.0),randf_range(350.0, 550.0))
	
	if event.is_action_pressed("test"):
		enemies.add_child(new_explosion)
