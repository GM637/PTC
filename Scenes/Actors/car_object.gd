extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	await get_tree().create_timer(randf_range(0.0,4.0)).timeout
	go()
	
	$Anim.animation_finished.connect(func(_animname):
		await get_tree().create_timer(randf_range(0.0,4.0)).timeout
		go()
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func go() :
	
	$Anim.speed_scale = randf_range(0.5,1.5)
	
	for i : MeshInstance3D in $Car.get_children() :
		i.hide()
	
	$Car.get_children().pick_random().show()
	
	$Anim.play(Array($Anim.get_animation_list()).pick_random())
