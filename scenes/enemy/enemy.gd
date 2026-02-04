extends CharacterBody2D

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var playerBody: CharacterBody2D
var speed: float = 30
var gravity: float = 980

enum States {INACTIVE,IDLE,WALK }
var state: States = States.INACTIVE


func _process(delta: float) -> void:
	gravity_force(delta)
	move_to_player()
	_state()
	move_and_slide()
	change_anim()
	flip()
func move_to_player():
	if playerBody:
		var direction = (playerBody.global_position - global_position).normalized()
		velocity.x = direction.x * speed
	else:
		velocity.x = 0


func gravity_force(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.y < 0:
			velocity.y = 0

func _state():
	match state:
		States.INACTIVE:
			velocity.x = 0
			
		States.IDLE:
			velocity.x =0
			
		States.WALK:
			move_to_player()
func change_anim():
	var anim = ""
	
	match state:
		States.INACTIVE:
			anim = "inactive"
		States.IDLE:
			anim = "idle"
		States.WALK:
			anim = "walk"
			
	if animation_player.current_animation != anim:
		animation_player.play(anim)
		
		
func _on_range_body_entered(body: Node2D):
	if body.is_in_group("player"):
		playerBody = body
		state = States.IDLE
		timer.start()
		
		
func _on_range_body_exited(body: Node2D):
	if body.is_in_group("player"):
		playerBody = null
		state = States.INACTIVE

func flip():
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		$Sprite2D.flip_h = true


func _on_timer_timeout() -> void:
	if playerBody:
		state = States.WALK
