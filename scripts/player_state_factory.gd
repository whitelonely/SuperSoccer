class_name PlayerStateFactory

var states : Dictionary

func _init() -> void:
	states = {
		Player.State.MOVING: PlayerStateMoving,
		Player.State.RECOVERING: PlayerStateRecovering,
		Player.State.TACKLING: PlayerStateTackling,
		Player.State.PREPPING_SHOT: PlayerStatePreppingShot,
		Player.State.SHOOTING: PlayerStateShooting,
		Player.State.PASSING: PlayerStatePassing,
		Player.State.CHEST_CONTROL: PlayerStateChestControl,
		Player.State.BICYCLE_KICK: PlayerStateBicycleKick,
		Player.State.VOLLEY_KICK: PlayerStateVolleyKick,
		Player.State.HEADER: PlayerStateHeader
	}

func get_fresh_state(state: Player.State) -> PlayerState:
	assert(states.has(state), "状态不存在！")
	return states.get(state).new()
