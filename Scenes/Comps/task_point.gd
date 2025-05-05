extends Sprite3D
class_name TaskPoint

@export var finish_task := false
@export var task_id := ""
@export var pts := 0

@export var hides : Array[TaskPoint]
@export var shows : Array[TaskPoint]

signal got

var t = 0.0
var s = 0.0

func _ready() -> void:
	t += randf_range(0,9999)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta
	
	scale = Vector3.ONE * (1.0 + (sin(t * 15.0) * 0.2))
	
	if visible :
		if Player.node :
			var p : Player = Player.node
			
			if p.global_position.distance_to(global_position) < 0.4 :
				
				hide()
				if finish_task :
					for i:Task in get_tree().get_nodes_in_group("Tasks") :
						if i.id == task_id :
							i.req -= 1
					$Finish.play()
					$Finish2.play()
				else :
					$Collect.play()
				Player.pts += pts
				got.emit()
				
				if hides.size() > 0 :
					for i in hides :
						i.hide()
				if shows.size() > 0 :
					for i in shows :
						i.show()
