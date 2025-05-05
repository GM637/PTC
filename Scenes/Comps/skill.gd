extends TextureProgressBar
class_name Skill

@export_enum("Consumable","Passive") var type = 0

@export var rate := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$Tooltip.text = tooltip_text
	
	$Tooltip.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	value += _delta * rate * 100
	
	$Tooltip.visible = get_global_mouse_position().distance_to(global_position + (size*0.5)) < 32

func trigger() :
	
	if value > 99 :
		value = 0.0
		
		run()

func run() :
	pass
