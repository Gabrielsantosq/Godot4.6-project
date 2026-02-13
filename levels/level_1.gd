extends Node2D
@onready var heart_bar: HBoxContainer = $CanvasLayer/heart_bar
@onready var player: CharacterBody2D = $player


func _ready() -> void:
	heart_bar.setMaxHearts(player.max_health)
	heart_bar.updateHearts(player.health)
	player.health_changed.connect(heart_bar.updateHearts)


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()
