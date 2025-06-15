class_name PlayerStatePreppingShot
extends PlayerState

const DURATION_MAX_BONUS := 1000.0
const EASE_REWARD_FACTOR := 2.0		# 踢球预备时长奖励因子

var shot_direction := Vector2.ZERO
var time_start_shot := Time.get_ticks_msec()

func _enter_tree() -> void:
	animation_player.play("pre_kick")
	player.velocity = Vector2.ZERO
	time_start_shot = Time.get_ticks_msec()

func _process(delta: float) -> void:
	shot_direction += KeyUtils.get_input_vector(player.control_scheme) * delta
	if KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.ACTION.SHOOT):
		var duration_press := clampf(Time.get_ticks_msec() - time_start_shot, 0.0, DURATION_MAX_BONUS)
		var ease_time := duration_press / DURATION_MAX_BONUS
		var bonus := ease(ease_time, EASE_REWARD_FACTOR)
		var shot_power := player.power * (1 + bonus)
		shot_direction = shot_direction.normalized()
		#var state_data := PlayerStateData.new()
		#state_data.shot_power = shot_power
		#state_data.shot_direction = shot_direction
		var data = PlayerStateData.build().set_shot_power(shot_power).set_shot_direction(shot_direction)
		transition_state(Player.State.SHOOTING, data)
