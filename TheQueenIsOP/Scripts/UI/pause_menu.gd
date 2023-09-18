extends Node2D

func _on_resume_button_pressed():
	GlobalVars.game_paused = false

func _on_restart_button_pressed():
	GlobalFunctions.restart_game()
	GlobalVars.game_paused = false
