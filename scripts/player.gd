class_name Player
extends CharacterBody2D

enum ControlScheme {
	CPU, P1, P2
}
@export var control_scheme : ControlScheme
@export var speed : float
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var player_sprite: Sprite2D = %Sprite2D

var heading := Vector2.RIGHT

func _process(_delta: float) -> void:
	if control_scheme == ControlScheme.CPU:
		# AI movement
		pass
	else:
		# Player movement (P1 P2)
		handle_human_move()
	
	set_move_anim()
	set_heading()
	flip_sprites()
	move_and_slide()

func handle_human_move() -> void:
	var direction := KeyUtils.get_input_vector(control_scheme)
	#Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
	velocity = direction * speed

func set_move_anim() -> void:
	if velocity.length() > 0:
		animation_player.play("run")
	else:
		animation_player.play("idle")

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
