extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var speed: float = 200
var direction: Vector2 = Vector2.RIGHT
var velocity: Vector2 = Vector2.ZERO

var damage_crossbow: int =  2



func _process(delta: float) -> void:
	position += velocity * delta

func set_direction(dir: Vector2, player_velocity: Vector2):
	direction = dir
	
	velocity = direction * speed + player_velocity
	if direction == Vector2.RIGHT:
		sprite_2d.flip_h = false
	if direction == Vector2.LEFT:
		sprite_2d.flip_h = true
		



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage_enemy(damage_crossbow)
		queue_free()
