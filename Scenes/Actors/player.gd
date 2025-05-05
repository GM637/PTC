extends CharacterBody3D
class_name Player

@export var Payrate := 1
@export var music : AudioStreamPlayer

@onready var sprite: AnimatedSprite3D = $Sprite
@onready var pivot: SpringArm3D = $Pivot


signal overtime

static var node : Player
static var pts = 0
static var last_pts = 0
static var money = 0
static var hp = 10 :
	set(num) :
		hp = clamp(num,0,20)
static var day = 1
static var item
static var time = 0.0
static var cam_shake = 0.0

var hp_check = 0
var pts_check = 0

@onready var points_label: Label = $GUI/Control/Tasks/Points
@onready var health_label: Label = $GUI/Control/Health
@onready var item_label: Label = $GUI/Control/Health/Item
@onready var tasks_label: Label = $GUI/Control/Tasks
@onready var hp_label: Label = $GUI/Control/Health/Hp
@onready var days_label: Label = $GUI/Control/Day

@onready var pts_fx_panel: Panel = $GUI/Control/Tasks/Points/Panel

var SPEED = 1.5
var JUMP_VELOCITY = 3.0

var input_dir: Vector2
var direction: Vector3
var input_lock: bool = false
var last_input: Vector2 = Vector2.UP

var d: float = 0.06

var finish = false

func _ready() -> void:
	
	node = self
	pivot.top_level = true
	hp = 10
	hp_check = 10
	
	if time != 0.0 :
		%Clock.seek(time)
	
	$OvertimeHeal.timeout.connect(func():
		hp += 1)

func _physics_process(delta: float) -> void:
	
	d = delta
	%HurtBar.modulate.a = lerp(%HurtBar.modulate.a,0.0,delta)
	pts_fx_panel.modulate = lerp(pts_fx_panel.modulate,Color.BLACK,delta)
	pts_fx_panel.scale = lerp(pts_fx_panel.scale,Vector2.ONE,delta)
	cam_shake *= 0.9
	time = %Clock.current_animation_position
	$GUI/AAA.color.h += delta
	
	if hp_check != hp :
		if hp < hp_check :
			$SFX/Grunt.play()
			%HurtBar.modulate.a = 1.0
			$GUI/AAA.color = Color.RED
			cam_shake += 0.5
		else :
			$GUI/AAA.color = Color.GREEN
			%HurtBar.modulate.a = 1.0
		hp_check = hp
	if pts_check != pts :
		pts_fx_panel.modulate = Color.WHITE
		pts_fx_panel.scale *= 1.5
		pts_check = pts
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$SFX/Jump.play()
	
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
	
	if Input.is_action_just_pressed("primary") and $GUI/Control/Health/Skills.get_child(0) :
		var c =  $GUI/Control/Health/Skills.get_child(0)
		if c is Skill :
			c.trigger()
	if Input.is_action_just_pressed("secondary") and $GUI/Control/Health/Skills.get_child(1) :
		var c =  $GUI/Control/Health/Skills.get_child(1)
		if c is Skill :
			c.trigger()
	if Input.is_action_just_pressed("tertiary") and $GUI/Control/Health/Skills.get_child(2) :
		var c =  $GUI/Control/Health/Skills.get_child(2)
		if c is Skill :
			c.trigger()
	
	if !finish :
		var done = true
		for i : Task in get_tree().get_nodes_in_group("Tasks") :
			if i.req > 0 :
				done = false
		if done :
			finish = true
			if music :
				music.pitch_scale *= 1.2
			%GUI.play_backwards("Overtime")
			$GUI/AAA.show()
			overtime.emit()
			await %GUI.animation_finished
			money += pts * Payrate
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	else :
		cam_shake += 0.01

func anim() :
	
	if input_dir.x :
		sprite.flip_h = input_dir.x < 0
	
	if is_on_floor() :
		sprite.play("Idle" if !input_dir else "RunNorm")
	else :
		if sprite.animation != "Jump" : sprite.play("Jump")

func cam() :
	
	pivot.global_position = lerp(pivot.global_position,global_position + Vector3(0.0,0.2,0.0) + Vector3(randf_range(-cam_shake,cam_shake),randf_range(-cam_shake,cam_shake),randf_range(-cam_shake,cam_shake)) ,d * 10.0)

func gui() :
	
	hp_string()
	task_string()
	points_label.text = str(pts) + " pts"
	hp_label.text = str(int(hp)).pad_zeros(2)
	days_label.text = str(day).pad_zeros(2)

func hp_string() :
	var t = "     "
	
	for i in hp :
		var x = wrapi(i,0,5)
		
		match t[x] :
			" " : t[x] = "V"
			"V" : t[x] = "A"
			"A" : t[x] = "3"
			"3" : t[x] = "0"
	
	health_label.text = t

func task_string() :
	
	tasks_label.text = ""
	
	if get_tree().get_node_count_in_group("Tasks") > 0 :
		
		for i : Task in get_tree().get_nodes_in_group("Tasks") :
			tasks_label.text += i.desc + "   -\n"
