extends TextureProgressBar
class_name Skill

@export_enum("Primary","Secondary","Tertiary") var input := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$Panel.mouse_entered.connect(func():$Tooltip.show())
	$Panel.mouse_exited.connect(func():$Tooltip.hide())
	
	$Tooltip.text = tooltip_text
	
	$Tooltip.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
