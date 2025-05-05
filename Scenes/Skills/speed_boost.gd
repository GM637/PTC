extends Skill

func run() :
	
	var p : Player = Player.node
	
	$Dash.play(0.1)
	p.SPEED *= 2
	p.JUMP_VELOCITY *= 1.1
	
	await get_tree().create_timer(5.0).timeout
	
	p.SPEED /= 2
	p.JUMP_VELOCITY /= 1.1
