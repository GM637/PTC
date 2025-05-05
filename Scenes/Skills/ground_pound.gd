extends Skill

func run() :
	
	var p : Player = Player.node
	
	$Dash.play(0.1)
	p.input_lock = true
	p.velocity.y = -50.0
	p.input_dir = Vector2.ZERO
	
	await get_tree().create_timer(0.5).timeout
	
	p.input_lock = false
