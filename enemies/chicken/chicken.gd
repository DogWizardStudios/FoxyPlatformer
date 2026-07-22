extends EnemyBase

enum ChickenState {WALK, JUMP}

@export var jump_force: float = -290.0
@export var walk_duration: float = 1.5

var _state: ChickenState = ChickenState.WALK

func _ready() -> void:
	change_state(ChickenState.WALK)

func _update_behaviour(_delta: float) -> void:
	match _state:
		ChickenState.WALK:
			do_walk()
		ChickenState.JUMP:
			if is_on_floor() and velocity.y >= 0: 
				#second check is because the moment we switch states we are on the floor
				#so we would change back immediately
				change_state(ChickenState.WALK)


func change_state(new_state: ChickenState) -> void:
	_state = new_state
	match _state:
		ChickenState.WALK:
			animated_sprite_2d.play("walk")
			timer.start(walk_duration)
		ChickenState.JUMP:
			velocity.y = jump_force
			animated_sprite_2d.play("jump")

func _on_timer_timeout() -> void:
	change_state(ChickenState.JUMP)
