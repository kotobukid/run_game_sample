extends Area2D

func _ready():
	$AnimatedSprite2D.play("default")
	$AnimationPlayer.stop(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Player":
		call_deferred("disable_collision")
		body.emit_coin()

func disable_collision():
	$CollisionShape2D.disabled = true
	$AnimationPlayer.play("disappear")
	$Timer.start(1.5)


func _on_timer_timeout():
	print("tick")
	queue_free()
