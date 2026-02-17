extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$AnimatedSprite2D.play("collect")
		$collect.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
