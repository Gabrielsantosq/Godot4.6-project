extends CharacterBody2D

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var playerBody: CharacterBody2D

var speed: float = 30
var gravity: float = 980

var is_dead: bool = false
var is_attacking: bool = false
var is_take_damage: bool = false

var lock_animation: bool = false

var max_health: int = 6
var health: int 

var state: States = States.INACTIVE

enum States {INACTIVE,ACTIVATED,WALK,TAKEDAMAGE, DEAD}

func _ready() -> void:
	health = max_health
	$Sprite2D2.visible = false

func _physics_process(delta: float) -> void:
	gravity_force(delta)
	move_to_player()
	change_state()
	move_and_slide()
	change_anim()
	flip()

func move_to_player():
	if is_dead:
		velocity = Vector2(0,0)
		return
		
	if playerBody and state == States.WALK:
		var direction = (playerBody.global_position - global_position).normalized()
		velocity.x = direction.x * speed
	else:
		velocity.x = 0

func gravity_force(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.y > 0:
			velocity.y = 0

func change_state():
	if is_dead:
		state = States.DEAD
		return

	if is_take_damage:
		state = States.TAKEDAMAGE
		return

	if playerBody == null:
		state = States.INACTIVE
		return
		
	if state == States.ACTIVATED:
		return
		
	state = States.WALK

func change_anim():
	if lock_animation:
		return

	var anim = ""
	
	match state:
		States.INACTIVE:
			anim = "inactive"
		States.ACTIVATED:
			anim = "activated"
		States.WALK:
			anim = "walk"
		States.DEAD:
			anim = "dead"
		States.TAKEDAMAGE:
			anim = "hurt"
			
	if animation_player.current_animation != anim:
		animation_player.play(anim)
	if anim in ["hurt", "dead"]:
		lock_animation = true
			
func take_damage_enemy(damage: int):
	if is_dead or is_take_damage:
		return
	
	is_take_damage = true
	health -= damage
	if health <= 0:
		is_dead = true
		is_take_damage = false
		

func dead():
	$CollisionShape2D.disabled = true
	$hit_box/CollisionShape2D.disabled = true
	queue_free()

func _on_range_body_entered(body: Node2D):
	if body.is_in_group("player"):
		playerBody = body
		state = States.ACTIVATED
		timer.start()
		$Sprite2D2.visible = true

func _on_range_body_exited(body: Node2D):
	if body.is_in_group("player"):
		playerBody = null
		if !is_dead and !is_take_damage:
			state = States.INACTIVE
		$Sprite2D2.visible = false

func flip():
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		$Sprite2D.flip_h = true

func _on_timer_timeout() -> void:
	if playerBody:
		state = States.WALK
		$Sprite2D2.visible = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "dead":
		dead()
	
	if anim_name == "hurt":
		is_take_damage = false
		lock_animation = false
		if playerBody:
			state = States.WALK
		else:
			state = States.INACTIVE
