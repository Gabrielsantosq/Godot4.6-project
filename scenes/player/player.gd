extends CharacterBody2D

signal reload_scene


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var speed: float = 100
@export var jump_force: float = -200
@onready var marker_2d: Marker2D = $Marker2D
@onready var shoot_coldown: Timer = $shoot_coldown
@onready var reload_cooldown: Timer = $reload_cooldown

var max_arrows: int = 5
@export var arrows: int = 5

var gravity: float = 980
var is_attacking: bool = false
var is_tacking_damage: bool = false
var is_dead: bool = false
var is_realoding: bool = false
var state: States = States.IDLE
var health: int = 3
var max_health: int = 3

enum States {IDLE, WALKING, JUMPING, FALLING, HIT, ATTACKING, RELOADING}


func _ready() -> void:
	health = max_health
	arrows = max_arrows

func _physics_process(delta: float) -> void:
	gravity_force(delta)
	movement()
	jumping()
	attack()
	change_state()
	move_and_slide()
	change_animation()
	flip_player()
	
	
func gravity_force(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.y < 0:
			velocity.y = 0
			
func movement():
	if is_attacking or is_realoding:
		velocity.x = 0
		return
	var direction = Input.get_axis("ui_left","ui_right")
	velocity.x = direction * speed
	
func jumping():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force

func attack():
	if is_realoding:
		return
		
	if Input.is_action_just_pressed("attack") and not is_attacking and is_on_floor():
		if shoot_coldown.is_stopped():
			if arrows > 0:
				is_attacking = true
				arrow_instanciate()
			else:
				start_reloading()
				

func change_state():
	if is_realoding:
		state = States.RELOADING
		return
	
	if is_tacking_damage:
		state = States.HIT
		return
	if is_attacking:
		state = States.ATTACKING
		return

	if is_on_floor():
		if abs(velocity.x) > 0:
			state = States.WALKING
		else:
			state = States.IDLE
	else:
		if velocity.y < 0:
			state = States.JUMPING
		else:
			state = States.FALLING

func start_reloading():
	is_realoding = true
	reload_cooldown.start()



func change_animation():
	var anim = ""
	
	match state:
		States.IDLE:
			anim = "idle"
		States.WALKING:
			anim = "run"
		States.JUMPING:
			anim = "jump"
		States.FALLING:
			anim = "fall"
		States.ATTACKING:
			anim = "attack"
		States.HIT:
			anim = "hit"
		States.RELOADING:
			anim = "reload"
			
	if animation_player.current_animation != anim:
		animation_player.play(anim)


func take_damage(damage: int):
	health -= damage
	is_tacking_damage = true
	print(health)
	if health < 0: 
		emit_signal("reload_scene")


func flip_player():
	if velocity.x < 0:
		$Sprite2D.flip_h = true
		marker_2d.position = Vector2(-16,9)
	elif velocity.x > 0:
		$Sprite2D.flip_h = false
		marker_2d.position = Vector2(16,9)


func arrow_instanciate():
	var dir = Vector2.RIGHT
	if $Sprite2D.flip_h:
		dir = Vector2.LEFT
		
	var arrow = preload("uid://dqkjg72iyi2gf").instantiate()
	arrow.global_position = marker_2d.global_position
	add_sibling(arrow)
	arrow.set_direction(dir,velocity)
	shoot_coldown.start()
	
	arrows -= 1
	if arrows <= 0:
		start_reloading()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		is_attacking = false
	if anim_name == "hit":
		is_tacking_damage = false


func _on_reload_cooldown_timeout() -> void:
	arrows = max_arrows
	is_realoding = false
