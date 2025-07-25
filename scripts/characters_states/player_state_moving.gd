class_name PlayerStateMoving
extends PlayerState

func _process(_delta: float) -> void:
	if player.control_scheme == Player.ControlScheme.CPU:
		# AI movement
		ai_behavior.process_ai()
	else:
		# Player movement (P1 P2)
		handle_human_move()
	
	player.set_move_anim()
	player.set_heading()

func handle_human_move() -> void:
	var direction := KeyUtils.get_input_vector(player.control_scheme)
	#Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
	player.velocity = direction * player.speed
	if player.velocity != Vector2.ZERO:
		teammate_dect_area.rotation = player.velocity.angle()
	
	if player.has_ball():
		if KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.ACTION.PASS):
			transition_state(Player.State.PASSING)
		elif KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.ACTION.SHOOT):
			transition_state(Player.State.PREPPING_SHOT)
	elif ball.can_air_interact() and KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.ACTION.SHOOT):
		if player.velocity == Vector2.ZERO:
			if is_facing_target_goal():
				transition_state(Player.State.VOLLEY_KICK)
			else:
				transition_state(Player.State.BICYCLE_KICK)
		else:
			transition_state(Player.State.HEADER)
	
	#if player.velocity != Vector2.ZERO and KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.ACTION.SHOOT):
		#state_transition_requested.emit(Player.State.TACKLING)
func is_facing_target_goal() -> bool:
	var direction_to_target_goal := player.position.direction_to(target_goal.position)
	return player.heading.dot(direction_to_target_goal) > 0
