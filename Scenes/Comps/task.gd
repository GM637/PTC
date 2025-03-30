extends Node
class_name Task

@export var id := ""
@export var desc := "" :
	get():
		if req > 0 :
			return desc.replace("XXX",str(req))
		else :
			return "(Complete!)"
@export var req := 10

func _ready() -> void:
	add_to_group("Tasks")

func search(id = ""):
	
	for i : Task in get_tree().get_nodes_in_group("Tasks") :
		if i.id == id :
			return i
