extends Node2D
@onready var heart_bar: HBoxContainer = $CanvasLayer/heart_bar
@onready var player: CharacterBody2D = $player


func _ready() -> void:
	heart_bar.setMaxHearts(player.health)
	


func _on_player_health_changed() -> void:
	print(player.health)
	heart_bar.setMaxHearts()
