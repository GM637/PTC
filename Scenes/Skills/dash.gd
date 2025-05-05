extends Skill

func run() :
	
	var p : Player = Player.node
	
	$Dash.play(0.1)
	p.SPEED *= 3
	p.input_lock = true
	
	await get_tree().create_timer(0.2).timeout
	
	p.SPEED /= 3
	p.input_lock = false
