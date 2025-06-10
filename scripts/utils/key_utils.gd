extends Node

enum ACTION {
	LEFT, RIGHT, UP, DOWN, SHOOT, PASS
}

const ACTION_MAP : Dictionary = {
	Player.ControlScheme.P1:{
		ACTION.LEFT: "p1_left",
		ACTION.RIGHT: "p1_right",
		ACTION.UP: "p1_up",
		ACTION.DOWN: "p1_down",
		ACTION.PASS: "p1_pass",
		ACTION.SHOOT: "p1_shoot",
	},
	Player.ControlScheme.P2:{
		ACTION.LEFT: "p2_left",
		ACTION.RIGHT: "p2_right",
		ACTION.UP: "p2_up",
		ACTION.DOWN: "p2_down",
		ACTION.PASS: "p2_pass",
		ACTION.SHOOT: "p2_shoot",
	}
}

func get_input_vector(scheme: Player.ControlScheme) -> Vector2:
	var map : Dictionary = ACTION_MAP[scheme]
	return Input.get_vector(map[ACTION.LEFT], map[ACTION.RIGHT], map[ACTION.UP], map[ACTION.DOWN])

func is_action_pressed(scheme: Player.ControlScheme, action: ACTION) -> bool:
	return Input.is_action_pressed(ACTION_MAP[scheme][action])

func is_action_just_pressed(scheme: Player.ControlScheme, action: ACTION) -> bool:
	return Input.is_action_just_pressed(ACTION_MAP[scheme][action])
