class_name Player
extends CharacterBody2D

const BALL_CONTROL_MAX_HEIGHT := 10.0
const CONTROL_SCHEME_MAP : Dictionary = {
	ControlScheme.CPU: preload("res://assets/art/props/cpu.png"),
	ControlScheme.P1: preload("res://assets/art/props/1p.png"),
	ControlScheme.P2: preload("res://assets/art/props/2p.png")
}
const COUNTRIES := ["DEFAULT", "FRANCE", "ARGENTINA", 
					"BRAZIL", "", "GERMANY", "ITALY", 
					"SPAIN", "USA"]
const GRAVITY := 8.0
const WALK_ANIM_THRESHOLD := 0.6

enum ControlScheme {CPU, P1, P2}
# 守门员、后卫、中锋、前锋
enum Role {GOALIE, DEFENCE, MINDFIELD, OFFENSE}
# 肤色：浅色、一般、深色
enum SkinColor {LIGHT, MEDIUM, DARK}
enum State {
	MOVING, TACKLING, RECOVERING, PREPPING_SHOT, 
	SHOOTING, PASSING, HEADER, VOLLEY_KICK, 
	BICYCLE_KICK, CHEST_CONTROL
}

@export var ball : Ball
@export var control_scheme : ControlScheme
@export var speed : float
@export var power : float
@export var own_goal : Goal
@export var target_goal : Goal

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var control_sprite: Sprite2D = %ControlSprite
@onready var player_sprite: Sprite2D = %Sprite2D
@onready var teammate_dect_area: Area2D = %TeammateDectArea
@onready var ball_detection_area: Area2D = %BallDetectionArea

var country := ""
var current_state: PlayerState = null
var state_factory := PlayerStateFactory.new()
var heading := Vector2.RIGHT
var height := 0.0
var height_velocity := 0.0

var fullname := ""
var role := Player.Role.MINDFIELD
var skin_color := Player.SkinColor.MEDIUM

var ai_behavior : AIBehavior = AIBehavior.new()
var spawn_position := Vector2.ZERO
var weight_on_duty_steering := 0.0

func _ready() -> void:
	set_control_texture()
	switch_state(State.MOVING)
	set_shader_properties()
	setup_ai_behavior()
	spawn_position = position

func _process(delta: float) -> void:
	flip_sprites()
	set_sprite_visibility()
	process_gravity(delta)
	move_and_slide()

func set_shader_properties() -> void:
	player_sprite.material.set_shader_parameter("skin_color", skin_color)
	var country_color := COUNTRIES.find(country)
	country_color = clampi(country_color, 0, COUNTRIES.size() - 1)
	player_sprite.material.set_shader_parameter("team_color", country_color)

func initialize(context_position: Vector2, context_ball: Ball, 
context_own_goal: Goal, context_target_goal:Goal, 
context_player_data: PlayerResource, context_country: String
) -> void:
	position = context_position
	ball = context_ball
	own_goal = context_own_goal
	target_goal = context_target_goal
	speed = context_player_data.speed
	power = context_player_data.power
	fullname = context_player_data.full_name
	role = context_player_data.role
	skin_color = context_player_data.skin_color
	country = context_country
	
	heading = Vector2.LEFT if target_goal.position.x < position.x else Vector2.RIGHT

func setup_ai_behavior() -> void:
	ai_behavior.setup(self, ball)
	ai_behavior.name = "AI行为"
	add_child(ai_behavior)

func switch_state(state: State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(
		self, state_data, animation_player, ball, 
		teammate_dect_area, ball_detection_area,
		own_goal, target_goal, ai_behavior)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "玩家状态机：" + str(state)
	call_deferred("add_child", current_state)

func set_move_anim() -> void:
	var vel_length := velocity.length()
	if vel_length < 1:
		animation_player.play("idle")
	elif vel_length < speed * WALK_ANIM_THRESHOLD:
		animation_player.play("walk")
	else:
		animation_player.play("run")

func process_gravity(delta: float) -> void:
	if height > 0:
		height_velocity -= GRAVITY * delta
		height += height_velocity
		if height <= 0:
			height = 0
	player_sprite.position = Vector2.UP * height

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

# 精灵头顶标识可见性控制
func set_sprite_visibility() -> void:
	control_sprite.visible = has_ball() or not control_scheme == ControlScheme.CPU

# 是否持球
func has_ball() -> bool:
	return ball.carrier == self

# 玩家头顶文本（1P，2P，CPU）
func set_control_texture() -> void:
	control_sprite.texture = CONTROL_SCHEME_MAP[control_scheme]

# 回调，pre_kick结束时跳转到kick
func on_animation_complete() -> void:
	if current_state != null:
		current_state.on_animation_complete()

# 胸部控球
func control_ball() -> void:
	if ball.height > BALL_CONTROL_MAX_HEIGHT:
		switch_state(Player.State.CHEST_CONTROL)
