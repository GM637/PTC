extends CharacterBody3D
class_name Player

@onready var sprite: AnimatedSprite3D = $Sprite
@onready var pivot: SpringArm3D = $Pivot

static var pts = 0
static var money = 0
static var hp = 10
static var item

@onready var points_label: Label = $GUI/Control/Tasks/Points
@onready var health_label: Label = $GUI/Control/Health
@onready var item_label: Label = $GUI/Control/Health/Item
@onready var tasks_label: Label = $GUI/Control/Tasks

var SPEED = 1.5
var JUMP_VELOCITY = 3.0

var input_dir: Vector2
var direction: Vector3
var input_lock: bool = false
var last_input: Vector2 = Vector2.UP

var d: float = 0.06

func _ready() -> void:
	
	pivot.top_level = true

func _physics_process(delta: float) -> void:
	
	d = delta
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") if !input_lock else input_dir
	if input_dir : last_input = input_dir
	direction = (basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 20.0)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 20.0)
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * 20.0)
		velocity.z = lerp(velocity.z, 0.0, delta * 20.0)
	
	move_and_slide()
	
	cam()
	anim()
	gui()

func anim() :
	
	if input_dir.x :
		sprite.flip_h = input_dir.x < 0
	
	if is_on_floor() :
		sprite.play("Idle" if !input_dir else "RunNorm")
	else :
		if sprite.animation != "Jump" : sprite.play("Jump")

func cam() :
	
	pivot.global_position = lerp(pivot.global_position,global_position + Vector3(0.0,0.2,0.0) ,d * 10.0)

func gui() :
	
	hp_string()
	task_string()

func hp_string() :
	var t = "     "
	
	for i in hp :
		var x = wrapi(i,0,5)
		
		match t[x] :
			" " : t[x] = "W"
			"W" : t[x] = "A"
			"A" : t[x] = "3"
			"3" : t[x] = "0"
	
	health_label.text = t

func task_string() :
	
	tasks_label.text = ""
	
	if get_tree().get_node_count_in_group("Tasks") > 0 :
		
		for i : Task in get_tree().get_nodes_in_group("Tasks") :
			tasks_label.text += i.desc + "   -\n"
