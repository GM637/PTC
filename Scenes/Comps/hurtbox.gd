extends Area3D
class_name HurtBox

@export var damage = 1

func _ready() -> void:
	
	body_entered.connect(func(node:Node3D) :
		if node is Player :
			node.velocity = global_position.direction_to(node.global_position) * 15.0
			node.velocity.y = 3.0
			Player.hp -= damage
			)
