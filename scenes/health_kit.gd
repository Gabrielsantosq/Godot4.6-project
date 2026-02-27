extends Area2D


signal recovery_heart



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.health < body.max_health:
			emit_signal("recovery_heart")
			queue_free()
