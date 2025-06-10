class_name PlayerStateRecovering
extends PlayerState

const  DURATION_RECOVER := 300
var time_start_recover := Time.get_ticks_msec()

func _enter_tree() -> void:
	time_start_recover = Time.get_ticks_msec()
	player.velocity = Vector2.ZERO
	animation_player.play("recover")

func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_start_recover > DURATION_RECOVER:
		state_transition_requested.emit(Player.State.MOVING)
