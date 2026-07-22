extends EnemyBase

enum PigState {WALK, ANGRY}

@onready var sight_ray: RayCast2D = $SightRay

@export var angry_speed: float = 60.0
@export var angry_duration: float = 2.0

var _state: PigState = PigState.WALK
var _player_ref: Player

func _ready() -> void:
	_player_ref = get_tree().get_first_node_in_group(Player.GROUP_NAME)
	if !_player_ref:
		push_error("No Player found by pig")
		queue_free()
		return
	change_state(PigState.WALK)

func _update_behaviour(_delta: float) -> void:
	match _state:
		PigState.WALK:
			do_walk()
			detect_player()
		PigState.ANGRY:
			do_angry()

func _flip_raycasts() -> void:
	super()
	sight_ray.target_position *= -1

func align_rays() -> void:
	if sign(wall_ray.target_position.x) != _direction:
		_flip_raycasts()

func detect_player() -> void:
	if sight_ray.is_colliding():
		change_state(PigState.ANGRY)

func do_angry() -> void:
	_direction = sign(_player_ref.global_position.x - global_position.x)
	velocity.x = _direction * angry_speed
	flip_sprite()

func change_state(new_state: PigState) -> void:
	if _hit: return
	_state = new_state
	match _state:
		PigState.WALK:
			align_rays()
			animated_sprite_2d.play("walk")
			do_walk()
		PigState.ANGRY:
			align_rays()
			animated_sprite_2d.play("angry")
			timer.start(angry_duration * randf_range(0.7, 1.5))

func _on_timer_timeout() -> void:
	if _state == PigState.ANGRY:
		change_state(PigState.WALK)
