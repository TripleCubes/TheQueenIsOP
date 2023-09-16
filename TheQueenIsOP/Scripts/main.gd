extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("KEY_1"):
		print(GlobalFunctions.get_mouse_board_pos())
