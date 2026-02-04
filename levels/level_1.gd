extends Node2D

@onready var camera_2d_2: Camera2D = $Camera2D2
@onready var player: CharacterBody2D = $player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera_2d_2.position = player.position
