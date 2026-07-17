class_name Player

extends CharacterBody2D

const GRAVITY: float = 690.0
const RUN_SPEED: float = 100.0
const JUMP_SPEED: float = -280.0

@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var land_sound: AudioStreamPlayer = $LandSound
@onready var sprite_2d: Sprite2D = $Sprite2D


var _jumped: bool = false
var _was_on_floor: bool = false
var _start_position: Vector2

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_on_floor():
		_jumped = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_position = position
	SignalHub.reset_player_position.connect(reset_position)


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
