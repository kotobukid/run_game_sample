extends Node
var timer: Timer
var iris_out: Node
var coin_count: int

# Called when the node enters the scene tree for the first time.
func _ready():
	coin_count = 0
	var player = $Player # Playerノードへのパスが正しいことを確認
	player.connect("touched_to_exit", Callable(self, "_on_player_touched_to_exit"))

	iris_out = preload("res://iris_out.tscn").instantiate()
	iris_out.process_mode = Node.PROCESS_MODE_ALWAYS
	iris_out.visible = false
	add_child(iris_out)
	
	start_stage()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_stage():
	var start_position = $Stage1/StartPosition.position
	$Player.position = start_position
	$Player.velocity.y = -100


func _on_player_touched_to_exit(area):
	print("stage clear!")
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
	timer = Timer.new()
	timer.wait_time = 2.0
	timer.process_mode = Node.PROCESS_MODE_ALWAYS
	timer.one_shot = true
	add_child(timer)

	timer.connect("timeout",Callable(self, "_on_timer_timeout"))

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
	print("stage resumed")
	timer.queue_free()

	start_stage()
	iris_out.position = $Player.position
	iris_out.play_iris_out_release()


func _on_coin_coin_got():
	coin_count += 1
	$ColorRect/CoinCount.text = str(coin_count)
