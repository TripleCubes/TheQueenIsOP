extends Node

@onready var queen: Piece = get_node("/root/Main/Pieces/Queen")
@onready var pieces: Node2D = get_node("/root/Main/Pieces")
@onready var bkg: Node2D = get_node("/root/Main/Bkg")
@onready var camera: Camera2D = get_node("/root/Main/Camera2D")
@onready var points: RichTextLabel = get_node("/root/Main/UI/Points")
@onready var op_mode_bar: UI_ProgressBarHorizontal = get_node("/root/Main/UI/OPModeBar")
@onready var ui: Node2D = get_node("/root/Main/UI")
@onready var pause_menu: Node2D = get_node("/root/Main/UI/PauseMenu")
@onready var lose_message: Node2D = get_node("/root/Main/UI/LoseMessage")

var queens_turn: = true
var num_moved: int = 0
var game_paused: bool = false:
	get:
		return game_paused
	set(val):
		game_paused = val
		if game_paused:
			pause_menu.z_index = 0
			var tween: = get_tree().create_tween()
			tween.tween_property(GlobalVars.camera, "position", Vector2(250, 0), 0.4)
		else:
			var timer: = get_tree().create_timer(0.4)
			timer.timeout.connect(func():
				pause_menu.z_index = -1
			)
			var tween: = get_tree().create_tween()
			tween.tween_property(GlobalVars.camera, "position", Vector2(0, 0), 0.4)

var lose_message_show: bool = false:
	get:
		return lose_message_show
	set(val):
		lose_message_show = val
		if lose_message_show:
			var tween: = get_tree().create_tween()
			tween.tween_property(lose_message, "position", Vector2(0, 0), 0.4)
		else:
			var tween: = get_tree().create_tween()
			tween.tween_property(lose_message, "position", Vector2(0, -40), 0.4)
