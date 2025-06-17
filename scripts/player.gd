class_name Player
extends CharacterBody2D

enum ControlScheme {CPU, P1, P2}
enum State {MOVING, TACKLING, RECOVERING, PREPPING_SHOT, SHOOTING, PASSING}

@export var ball : Ball
@export var control_scheme : ControlScheme
@export var speed : float
@export var power : float

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var player_sprite: Sprite2D = %Sprite2D
@onready var teammate_dect_area: Area2D = %TeammateDectArea

var current_state: PlayerState = null
var state_factory := PlayerStateFactory.new()
var heading := Vector2.RIGHT

func _ready() -> void:
	switch_state(State.MOVING)

func _process(_delta: float) -> void:
	flip_sprites()
	move_and_slide()

func switch_state(state: State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, state_data, animation_player, ball, teammate_dect_area)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "玩家状态机：" + str(state)
	call_deferred("add_child", current_state)

func set_move_anim() -> void:
	if velocity.length() > 0:
		animation_player.play("run")
	else:
		animation_player.play("idle")

# 玩家朝向
func set_heading() -> void:
	if velocity.x > 0:
		heading = Vector2.RIGHT
	elif velocity.x < 0:
		heading = Vector2.LEFT

# 精灵翻转
func flip_sprites() -> void:
	if heading == Vector2.RIGHT:
		player_sprite.flip_h = false
	elif heading == Vector2.LEFT:
		player_sprite.flip_h = true
	# 简写方案
	#player_sprite.flip_h = true if heading == Vector2.RIGHT else false

# 是否持球
func has_ball() -> bool:
	return ball.carrier == self

# 回调，pre_kick结束时跳转到kick
func on_animation_complete() -> void:
	if current_state != null:
		current_state.on_animation_complete()
