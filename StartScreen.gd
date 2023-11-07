extends Node2D

signal start_stage(stage_number)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("start_stage", 1)
		queue_free()


func _on_marquee_timer_timeout():
	$Label2.visible = !$Label2.visible
