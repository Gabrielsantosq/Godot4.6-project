extends Node2D
@onready var heart_bar: HBoxContainer = $CanvasLayer/heart_bar
@onready var player: CharacterBody2D = $player
@onready var health_kit: Area2D = $health_kit



func _ready() -> void:
	heart_bar.setMaxHearts(player.max_health)
	heart_bar.updateHearts(player.health)
	player.health_changed.connect(heart_bar.updateHearts)


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()


func _on_player_reload_scene() -> void:
	get_tree().reload_current_scene()


func _on_health_kit_recovery_heart() -> void:
	if player.health < player.max_health:
		player.health += 1
		heart_bar.updateHearts(player.health)
