extends CharacterBody2D


const JUMP_VELOCITY = -400.0
@export var run_speed = 100.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal touched_to_exit(body)

func _ready():
	_draw_trajectory()
	$AnimationSprite2D.play("run")

func _draw_trajectory():
	var points = []
	var points_m = []
	var time_step = 0.1  # seconds
	var total_time = 1.0  # seconds
	var initial_y_position = 0  # Since we are using local coordinates

	for i in range(0, int(total_time / time_step) + 1):
		var t = i * time_step
		var y_position = initial_y_position + JUMP_VELOCITY * t + 0.5 * gravity * t * t
		points.append(Vector2(t * run_speed, y_position))
		points_m.append(Vector2(-t * run_speed, y_position))

	var trajectory_line = $TrajectoryLine # 子ノードのLine2Dにパスを設定
	trajectory_line.points = points
	var trajectory_line_m = $TrajectoryLineMirror # 子ノードのLine2Dにパスを設定
	trajectory_line_m.points = points_m
	trajectory_line_m.visible = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("small_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY / 1.5

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)
	if $RayCast2D.is_colliding() or $RayCast2D.is_colliding():
		run_speed = -run_speed # 速度を反転させる
		$RayCast2D.target_position.x = -$RayCast2D.target_position.x
		$AnimationSprite2D.flip_h = !$AnimationSprite2D.flip_h

		$TrajectoryLine.visible = !$TrajectoryLine.visible
		$TrajectoryLineMirror.visible = !$TrajectoryLine.visible
	velocity.x = run_speed

	move_and_slide()


func _on_event_area_area_entered(area):
	if area.is_in_group("exit"):
		emit_signal("touched_to_exit", area)
