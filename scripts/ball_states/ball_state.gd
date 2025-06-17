class_name BallState
extends Node

const GRAVITY := 10.0
signal state_transition_requested(new_state: Ball.State)

var animation_player : AnimationPlayer = null
var ball : Ball = null
var carrier : Player = null
var player_detection_area : Area2D = null
var sprite : Sprite2D = null

func setup(
	context_ball: Ball, context_player_detection_area: Area2D, 
	context_carrier: Player, context_animation_player: AnimationPlayer,
	context_sprite : Sprite2D
	) -> void:
	ball = context_ball
	player_detection_area = context_player_detection_area
	carrier = context_carrier
	animation_player = context_animation_player
	sprite = context_sprite

func set_ball_anim_from_velocity() -> void:
	if ball.velocity == Vector2.ZERO:
		animation_player.play("idle")
	elif ball.velocity.x > 0:
		animation_player.play("roll")
		animation_player.advance(0)
	else:
		animation_player.play_backwards("roll")
		animation_player.advance(0)

# bounciness弹跳因子，主要负责足球自由状态下的落地弹跳
func process_gravity(delta: float, bounciness: float) -> void:
	if ball.height > 0 or ball.height_velocity > 0:
		ball.height_velocity -= GRAVITY * delta
		ball.height += ball.height_velocity
		if ball.height < 0:
			ball.height = 0
			if bounciness > 0 and ball.height_velocity < 0:
				ball.height_velocity = -ball.height_velocity * delta
				ball.velocity *= bounciness
