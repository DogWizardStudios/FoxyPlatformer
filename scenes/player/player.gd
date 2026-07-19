class_name Player

extends CharacterBody2D

const GRAVITY: float = 690.0
const RUN_SPEED: float = 100.0
const JUMP_SPEED: float = -280.0
const STOMP_SPEED: float = -200.0
const HURT_VELOCITY: Vector2 = Vector2(0.0,-170.0)
const HURT_FLASH_COUNT: int = 6
const HURT_FLASH_DURATION: float = 0.2


@export var camera_limit_top: int = -10000
@export var camera_limit_bottom: int = 10000
@export var camera_limit_left: int = -10000
@export var camera_limit_right: int = 10000

@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var land_sound: AudioStreamPlayer = $LandSound
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player_camera: Camera2D = $PlayerCamera
@onready var hurt_timer: Timer = $HurtTimer
@onready var hurt_sound: AudioStreamPlayer = $HurtSound

var is_hurt: bool:
	get: return _is_hurt

var is_still: bool:
	get: return is_zero_approx(velocity.x)

var is_falling: bool:
	get: return velocity.y > 0

var is_on_ground: bool:
	get: return is_on_floor()

var _jumped: bool = false
var _was_on_floor: bool = false
var _start_position: Vector2
var _is_hurt: bool = false
var _is_invincible: bool = false
var _invincible_tween: Tween
var _damage_areas: Array[Area2D] 
# Keeps track of all overlapping damage areas so that if we are hit 
# We re-apply a hit if we are overlapping with any damage area
# Otherwise you could stay inside the area and not be damaged again

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
	if _is_hurt: return
	
	velocity.x = Input.get_axis("left", "right") * RUN_SPEED
	if is_on_floor() and _jumped:
		_jumped = false
		velocity.y = JUMP_SPEED
		jump_sound.play()

func reset_position() -> void:
	position = _start_position
	set_position.call_deferred(_start_position)

func _on_hurt_area_entered(area: Area2D) -> void:
	apply_hit.call_deferred()
	hurt_sound.play()
	if area not in _damage_areas:
		_damage_areas.append(area)

func _on_hurt_area_exited(area: Area2D) -> void:
	_damage_areas.erase(area)



func apply_hurt_jump() -> void:
	if _is_hurt: return
	_is_hurt = true
	hurt_timer.start()
	velocity = HURT_VELOCITY

func apply_hit() -> void:
	if _is_invincible: return
	apply_hurt_jump()
	become_invicible()

func apply_stomp() -> void:
	velocity.y = STOMP_SPEED

func become_invicible() -> void:
	if _is_invincible: return
	_is_invincible = true
	
	#prevent overlap of tweens
	if _invincible_tween and _invincible_tween.is_running():
		_invincible_tween.kill()
	
	_invincible_tween = create_tween()
	_invincible_tween.set_loops(HURT_FLASH_COUNT)
	_invincible_tween.tween_property(sprite_2d, "modulate", Color.TRANSPARENT, HURT_FLASH_DURATION)
	_invincible_tween.tween_property(sprite_2d, "modulate", Color.WHITE_SMOKE, HURT_FLASH_DURATION)
	_invincible_tween.finished.connect(invicible_finished)

func invicible_finished() -> void:
	_is_invincible = false
	if _damage_areas.size() > 0:
		apply_hit.call_deferred()

func _on_hurt_timer_timeout() -> void:
	_is_hurt = false


func _on_stomp_area_entered(area: Area2D) -> void:
	if velocity.y < 0.0 or _is_hurt: return
	if area is StompBox and not area.is_hit:
		apply_stomp.call_deferred()
		area.trigger()
