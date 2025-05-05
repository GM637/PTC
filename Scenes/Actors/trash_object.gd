extends Node3D

func _ready() -> void:
	
	go()
	$Delivery.got.connect(go)

func go() :
	$Pickup.global_position = Vector3(randf_range(-2.7,2.1),0.05,randf_range(2.85,-2.15))
	if global_position.distance_to( Vector3(0.2,0.05,-1.1) ) < 0.7 :
		go()
