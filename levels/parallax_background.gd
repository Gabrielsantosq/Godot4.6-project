extends ParallaxBackground



func _process(delta: float) -> void:
	scroll_base_offset -= Vector2(50.0, 0) * delta
