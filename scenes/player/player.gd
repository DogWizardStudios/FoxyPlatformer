class_name Player

extends CharacterBody2D

const GRAVITY: float = 690.0
const RUN_SPEED: float = 100.0
const JUMP_SPEED: float = -280.0

@export var camera_limit_top: int = -10000
@export var camera_limit_bottom: int = 10000
@export var camera_limit_left: int = -10000
@export var camera_limit_right: int = 10000

@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var land_sound: AudioStreamPlayer = $LandSound
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player_camera: Camera2D = $PlayerCamera

var is_still: bool:
	get: return is_zero_approx(velocity.x)

var is_falling: bool:
	get: return velocity.y > 0

var is_on_ground: bool:
	get: return is_on_floor()

var _jumped: bool = false
var _was_on_floor: bool = false
var _start_position: Vector2

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_on_floor():
		_jumped = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_position = position
	set_camera_limits()
	SignalHub.reset_player_position.connect(reset_position)

func set_camera_limits() -> void:
	player_camera.limit_top = camera_limit_top
	player_camera.limit_bottom = camera_limit_bottom
	player_camera.limit_left = camera_limit_left
	player_camera.limit_right = camera_limit_right

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	velocity.y += GRAVITY * delta
	handle_movement()
	flip_sprite()
	move_and_slide()
	check_landed()

func flip_sprite() -> void:
	if !is_zero_approx(velocity.x):
		sprite_2d.flip_h = velocity.x < 0.0

func check_landed() -> void:
	if not _was_on_floor and is_on_floor():
		land_sound.play()
	_was_on_floor = is_on_floor()

func handle_movement() -> void:
	velocity.x = Input.get_axis("left", "right") * RUN_SPEED
	if is_on_floor() and _jumped:
		_jumped = false
		velocity.y = JUMP_SPEED
		jump_sound.play()


func reset_position() -> void:
	position = _start_position
	set_position.call_deferred(_start_position)
