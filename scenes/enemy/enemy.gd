extends CharacterBody2D

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var playerBody: CharacterBody2D

var speed: float = 30
var gravity: float = 980

var is_dead: bool = false
var inactive: bool = false
var active: bool = false
var walking: bool = false
var is_attacking: bool = false
var is_take_damage: bool = false

var max_health: int = 4
var health: int 


var state: States = States.INACTIVE


enum States {INACTIVE,IDLE,WALK,TAKEDAMAGE, DEAD}

func _ready() -> void:
	health = max_health


func _process(delta: float) -> void:
	
	gravity_force(delta)
	move_to_player()
	change_state()
	move_and_slide()
	change_anim()
	flip()
	

func move_to_player():
	if playerBody:
		var direction = (playerBody.global_position - global_position).normalized()
		velocity.x = direction.x * speed
		
	else:
		velocity.x = 0
		inactive = true 

func gravity_force(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.y < 0:
			velocity.y = 0

func change_state():
	if is_dead:
		state = States.DEAD
		return
		
	if is_take_damage:
		state =  States.TAKEDAMAGE
		return
		
	if inactive:
		state = States.INACTIVE
		return
		
	if active:
		state = States.IDLE
		return
		
	if walking:
		state = States.WALK
		return


func change_anim():
	var anim = ""
	
	match state:
		States.INACTIVE:
			anim = "inactive"
		States.IDLE:
			anim = "idle"
		States.WALK:
			anim = "walk"
		States.DEAD:
			anim = "dead"
		States.TAKEDAMAGE:
			anim = "hurt"
			
	if animation_player.current_animation != anim:
		animation_player.play(anim)

func take_damage_enemy(damage: int):
	is_take_damage = true
	health -= damage
	if health <= 0:
		is_dead = true
		is_take_damage = false
		

func dead():
	$CollisionShape2D.disabled = true
	await 2
	queue_free()


func _on_range_body_entered(body: Node2D):
	if body.is_in_group("player"):
		playerBody = body
		active = true
		timer.start()


func _on_range_body_exited(body: Node2D):
	if body.is_in_group("player"):
		playerBody = null
		inactive = true
		active = false
		walking = false


func flip():
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		$Sprite2D.flip_h = true


func _on_timer_timeout() -> void:
	if playerBody:
		walking = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		is_take_damage = false
	if anim_name == "dead":
		dead()
