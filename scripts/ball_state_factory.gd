class_name BallStateFactory

var states : Dictionary

func _init() -> void:
	states = {
		Ball.State.CARRIED: BallStateCarried,
		Ball.State.FREEFORM: BallStateFreeform,
		Ball.State.SHOT: BallStateShot
	}

func get_fresh_state(state: Ball.State) -> BallState:
	assert(states.has(state), "状态不存在！")
	return states.get(state).new()
