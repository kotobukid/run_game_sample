extends Node
var timer: Timer
var iris_out: Node
var coin_count: int

var stage1 = preload("res://stages/stage_1.tscn")
var stage2 = preload("res://stages/stage_2.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	coin_count = 0
	var player = $Player
	player.connect("touched_to_exit", Callable(self, "_on_player_touched_to_exit"))

	iris_out = preload("res://iris_out.tscn").instantiate()
	iris_out.process_mode = Node.PROCESS_MODE_ALWAYS
	iris_out.visible = false
	add_child(iris_out)


func start_stage(stage_number):
	for child in $Stages.get_children():
		child.queue_free()

	if stage_number == 1:
		$Stages.add_child(stage1.instantiate())
		var start_position = $Stages/Stage1/StartPosition.position
		$Player.position = start_position
		$Player.velocity.y = -100
	elif stage_number == 2:
		$Stages.add_child(stage2.instantiate())
		var start_position = $Stages/Stage2/StartPosition.position
		$Player.position = start_position
		$Player.velocity.y = -100
		

func _on_player_touched_to_exit(area, stage_number):
	print("stage clear!")
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
	# timer = Timer.new()
	timer = $Timer
	timer.wait_time = 2.0
	timer.process_mode = Node.PROCESS_MODE_ALWAYS
	timer.one_shot = true
	# add_child(timer)
	timer.next_stage = stage_number
	# timer.connect("timeout",Callable(self, "_on_timer_timeout"))

	var sprite_size = Vector2(0, 0)
	var sprite = area.get_node("Sprite2D")
	if sprite and sprite.region_enabled and sprite.texture:
		sprite_size = sprite.region_rect.size
	elif sprite and sprite.texture:
		sprite_size = sprite.texture.get_size()
	sprite_size.y *= -0.5
	sprite_size.x *= 0.5
	var _position = area.position - sprite_size
	iris_out.position = _position
	iris_out.visible = true
	iris_out.play_iris_out()

	timer.start()
	get_tree().paused = true


func _on_timer_timeout():
	get_tree().paused = false
	
	# timer.queue_free()
	start_stage(timer.next_stage)
	iris_out.position = $Player.position
	iris_out.play_iris_out_release()


func _on_coin_coin_got():
	coin_count += 1
	$ColorRect/CoinCount.text = str(coin_count)


func _on_start_screen_start_stage(stage_number):
	start_stage(stage_number)
	
