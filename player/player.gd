extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
enum State {Idle, Run}
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var currentState
func _ready():
	currentState=State.Idle
func _physics_process(delta):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	player_animation()
func player_falling(delta):
	if !is_on_floor():
		velocity.y += gravity*delta
func player_idle(delta):
	if is_on_floor():
		currentState= State.Idle
func player_run(delta):
	var direction = Input.get_axis("move_left","move_right")
	if direction:
		velocity.x=direction*300
	else:
		velocity.x=move_toward(velocity.x,0,300)
	if direction !=0:
		currentState = State.Run
		animated_sprite_2d.flip_h = false if direction > 0 else true
func player_animation():
	if currentState == State.Idle:
		animated_sprite_2d.play("idle")
	elif currentState == State.Run:
		animated_sprite_2d.play("run")
