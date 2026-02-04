extends CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var speed: float = 100
@export var jump_force: float = -200
@onready var marker_2d: Marker2D = $Marker2D
@onready var shoot_coldown: Timer = $shoot_coldown

#instancias

#falata mexer com as flechas esta tudo bugado ainda


var gravity: float = 980
var is_attacking: bool = false
enum States {IDLE, WALKING, JUMPING, FALLING, HIT, ATTACKING}
var state: States = States.IDLE

func _ready() -> void:
	shoot_coldown.stop()

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
	if is_attacking:
		velocity.x = 0
		return
	var direction = Input.get_axis("ui_left","ui_right")
	velocity.x = direction * speed
	
func jumping():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force

func attack():
	if Input.is_action_just_pressed("attack") and not is_attacking and is_on_floor():
		is_attacking = true
		if shoot_coldown.is_stopped():
			arrow_instanciate()


func change_state():
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
			
	if animation_player.current_animation != anim:
		animation_player.play(anim)

func flip_player():
	if velocity.x < 0:
		$Sprite2D.flip_h = true
		marker_2d.position = Vector2(-16,9)
	elif velocity.x > 0:
		$Sprite2D.flip_h = false
		marker_2d.position = Vector2(16,9)
		

func arrow_instanciate():
	var arrow = preload("uid://dqkjg72iyi2gf").instantiate()
	arrow.global_position = marker_2d.global_position
	add_sibling(arrow)
	
	var dir = Vector2.RIGHT
	if $Sprite2D.flip_h:
		dir = Vector2.LEFT
	arrow.set_direction(dir,velocity)
	shoot_coldown.start()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		is_attacking = false
