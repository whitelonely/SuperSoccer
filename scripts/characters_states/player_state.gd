class_name PlayerState
extends Node

signal state_transition_requested(new_state: Player.State)

var animation_player : AnimationPlayer = null
var player: Player = null

func setup(context_player: Player, content_anim_player: AnimationPlayer) -> void:
	player = context_player
	animation_player = content_anim_player
