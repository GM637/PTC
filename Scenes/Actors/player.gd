extends CharacterBody3D
class_name Player

@onready var sprite: AnimatedSprite3D = $Sprite

var SPEED = 3.0
var JUMP_VELOCITY = 3.5

var input_dir : Vector2
var direction : Vector3

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = (basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 20.0)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 20.0)
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * 20.0)
		velocity.z = lerp(velocity.z, 0.0, delta * 20.0)
	
	move_and_slide()
	
	anim()

func anim() :
	
	if input_dir.x :
		sprite.flip_h = input_dir.x < 0
	
	if is_on_floor() :
		sprite.play("Idle" if !input_dir else "RunNorm")
	else :
		if sprite.animation != "Jump" : sprite.play("Jump")
