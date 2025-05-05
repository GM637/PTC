extends Node2D

var next = ""

func _ready() -> void:
	
	if Player.time != 0.0 :
		%Clock2.seek(Player.time)
	
	if !Player.pts > 0 :
		%Anim.play("Fade")
	else :
		%Cam.global_position.y = 720 * 2
		$%Anim.play("Progress")
	
	%LevelSelect.button_down.connect(func():
		get_tree().create_tween().tween_property($Control,"position",Vector2(0,720),1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		%SFXButton.play()
		%Level1.grab_focus())
	
	%Settings.button_down.connect(func():
		get_tree().create_tween().tween_property($Control,"position",Vector2(1280 * 2,720),1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		%SFXButton.play()
		%Level1.grab_focus())
	
	%Menu.button_down.connect(func():
		get_tree().create_tween().tween_property($Control,"position",Vector2(1280,720),1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		%SFXButton.play()
		%LevelSelect.grab_focus())
	
	%BackMenu.button_down.connect(func():
		get_tree().create_tween().tween_property($Control,"position",Vector2(1280,720),1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		%SFXButton.play()
		%LevelSelect.grab_focus())
	
	%Back.button_down.connect(func():
		%Cam.global_position.y = 720
		%SFXButton.play()
		%Level1.grab_focus())
		
	
	%Level1.button_down.connect(func():
		next = "res://Scenes/Levels/level1.tscn"
		%SFXStart.play()
		%SFXButton.play()
		to_loadout()
		%Start.grab_focus())
	%Level2.button_down.connect(func():
		next = "res://Scenes/Levels/level2.tscn"
		%SFXStart.play()
		%SFXButton.play()
		to_loadout()
		%Start.grab_focus())
	
	%Start.button_down.connect(func():
		if ResourceLoader.exists(next,"PackedScene") :
			%Start.disabled
			%Anim.play_backwards("Fade")
			%SFXStart.play()
			%SFXButton.play()
			await %Anim.animation_finished
			get_tree().change_scene_to_file(next)
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	%ListMoney.text = "Money   :   $" + str(Player.money)
	%Money.text = "$" + str(Player.money).pad_zeros(4)
	%Days.text = str(8-Player.day)
	
	if Input.is_action_just_pressed("Start") :
		if %Cam.global_position == Vector2.ZERO :
			%Cam.global_position.y = 720
			%SFXStart.play()
			%SFXButton.play()
			%LevelSelect.grab_focus()
	
	if Input.is_action_just_pressed("Esca") :
		if %Cam.global_position.y == 720 :
			%Cam.global_position.y = 0
			%SFXButton.play()

func to_loadout() :
	%Cam.global_position.y = 720 * 2

func after_job() :
	
	get_tree().create_tween().tween_property($Control,"position",Vector2(0,720),1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	%Cam.global_position.y = 720
	%Level1.grab_focus()
