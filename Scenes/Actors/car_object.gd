extends Node3D

@export var id = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$Car/P2.got.connect(unpause)
	$Anim.animation_finished.connect(func(_animname):
		await get_tree().create_timer(randf_range(0.0,0.5)).timeout
		go()
		)
	
	await get_tree().create_timer(randf_range(2.0,3.0) * id).timeout
	go()
	
	if Player.node :
		Player.node.overtime.connect(func():
			$Anim.speed_scale *= 2.5)

func go() :
	
	$Anim.speed_scale += randf_range(0.01,0.03)
	
	for i : MeshInstance3D in $Car/Model.get_children() :
		i.hide()
	
	$Car/Model.get_children().pick_random().show()
	
	$Anim.play(Array($Anim.get_animation_list()).pick_random())

func pause() :
	
	$Anim.speed_scale *= 0.001
	$Car/P1.show()

func unpause() :
	
	$Anim.speed_scale *= 1000
