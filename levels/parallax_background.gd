extends ParallaxBackground

@onready var parallax_layer_2: ParallaxLayer = $ParallaxLayer2
@onready var parallax_layer_3: ParallaxLayer = $ParallaxLayer3
@onready var parallax_layer_4: ParallaxLayer = $ParallaxLayer4
@onready var parallax_layer_5: ParallaxLayer = $ParallaxLayer5


func _process(delta: float) -> void:
	#scroll_base_offset -= Vector2(100.0, 0) * delta
	
	parallax_layer_2.motion_scale = Vector2(0.2,0.0)
	parallax_layer_3.motion_scale = Vector2(0.4, 0.0)
	parallax_layer_4.motion_scale = Vector2(0.6, 0.0)
	parallax_layer_5.motion_scale = Vector2(0.8, 0.0)
