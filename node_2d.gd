extends Node2D
@onready var sky: Parallax2D = $sky
@onready var cloud: Parallax2D = $cloud
@onready var hills: Parallax2D = $hills
@onready var clouds: Parallax2D = $clouds
@onready var fore: Parallax2D = $fore


func _process(delta: float) -> void:
	cloud.scroll_offset -= Vector2(5.0, 0.0) * delta
	clouds.scroll_offset -= Vector2(10.0, 0.0) * delta
