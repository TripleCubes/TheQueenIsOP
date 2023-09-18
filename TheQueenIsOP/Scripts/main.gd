extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("KEY_1"):
		print(GlobalFunctions.get_mouse_board_pos())

func _on_pause_button_pressed():
	GlobalVars.game_paused = true

func _on_restart_button_pressed():
	GlobalFunctions.restart_game()
