# アニメーションシーンのルートノードスクリプト
extends Node2D

# アニメーションプレイヤーへの参照
var anim_player :AnimationPlayer
var center: Vector2

func _ready():
	anim_player = $AnimationPlayer
	var sprite_size = $ColorRect.get_size()
	position.x = -1 * (sprite_size.x / 2)
	position.y = -1 * (sprite_size.y / 2)

func play_iris_out():
	visible = true
	anim_player.play("IrisOut")
	

# アニメーションが終了したら、シグナルを発行するかもしれない
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "IrisOut":
		emit_signal("iris_out_finished")


func play_iris_out_release():
	anim_player.play("IrisOutRelease")
