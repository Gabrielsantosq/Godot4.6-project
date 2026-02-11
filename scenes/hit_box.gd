extends Area2D

signal dead

@export var damage = 2


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.take_damage(damage)
