extends Node

@export var lifetime: float = 10.0

@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(lifetime)



func _on_timer_timeout() -> void:
	get_parent().queue_free()
