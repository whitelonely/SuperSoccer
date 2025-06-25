class_name PlayerState
extends Node

signal state_transition_requested(new_state: Player.State, state_data: PlayerStateData)

var animation_player : AnimationPlayer = null
var player : Player = null
var state_data : PlayerStateData = PlayerStateData.new()
var ball : Ball = null
var teammate_dect_area : Area2D = null
var ball_detection_area : Area2D = null

func setup(
	context_player: Player, 
	context_data: PlayerStateData, 
	content_anim_player: AnimationPlayer, 
	context_ball: Ball, 
	context_teammate_dect_area: Area2D, 
	context_ball_detection_area: Area2D
	) -> void:
	player = context_player
	state_data = context_data
	animation_player = content_anim_player
	ball = context_ball
	teammate_dect_area = context_teammate_dect_area
	ball_detection_area = context_ball_detection_area

func transition_state(new_state: Player.State, data: PlayerStateData = PlayerStateData.new()) -> void:
	state_transition_requested.emit(new_state, data)

# 回调，动画结束切换状态用
func on_animation_complete() -> void:
	pass #override重载这个
