extends EnemyBase

enum PigState {WALK, ANGRY}

@onready var sight_ray: RayCast2D = $SightRay

var _state: PigState = PigState.WALK

func _update_behaviour(_delta: float) -> void:
	match _state:
		PigState.WALK:
			do_walk()
			detect_player()
		PigState.ANGRY:
			pass


func _flip_raycasts() -> void:
	super()
	sight_ray.target_position *= -1

func detect_player() -> void:
	if sight_ray.is_colliding():
		change_state(PigState.ANGRY)

func change_state(new_state: PigState) -> void:
	_state = new_state
	match _state:
		PigState.WALK:
			animated_sprite_2d.play("walk")
			do_walk()
		PigState.ANGRY:
			animated_sprite_2d.play("angry")
