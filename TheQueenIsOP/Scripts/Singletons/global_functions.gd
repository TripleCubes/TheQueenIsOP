extends Node2D

func board_pos_to_scene_pos(board_pos: Vector2i) -> Vector2:
	var margin: float = (Consts.WINDOW_WH - Consts.TILE_WH * Consts.BOARD_WH) / 2
	var result: = Vector2(0, 0)
	result.x = board_pos.x * Consts.TILE_WH + margin + Consts.TILE_WH/2
	result.y = board_pos.y * Consts.TILE_WH + margin + Consts.TILE_WH/2
	return result

func scene_pos_to_board_pos(scene_pos: Vector2) -> Vector2i:
	var margin: float = (Consts.WINDOW_WH - Consts.TILE_WH * Consts.BOARD_WH) / 2
	var result: = Vector2i(0, 0)
	result.x = floor((scene_pos.x - margin) / Consts.TILE_WH)
	result.y = floor((scene_pos.y - margin) / Consts.TILE_WH)
	return result

func get_mouse_board_pos() -> Vector2:
	return scene_pos_to_board_pos(get_global_mouse_position())

func get_piece_at(in_board_pos: Vector2i) -> Piece:
	for piece in GlobalVars.pieces.get_children():
		if not piece is Piece:
			continue
			
		if piece.board_pos == in_board_pos:
			return piece

	return null

func is_in_board(in_board_pos: Vector2i) -> bool:
	return in_board_pos.x >= 0 and in_board_pos.y >= 0 \
	and in_board_pos.x < Consts.BOARD_WH and in_board_pos.y < Consts.BOARD_WH

func get_random_dir() -> Vector2:
	var result: = Vector2(0, 0)
	while result == Vector2(0, 0):
		result = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	return result.normalized()

const SHAKE_DIST: float = 5
const SHAKE_FORWARD_TIME: float = 0.02
const SHAKE_BACKWARD_TIME: float = 0.5

func camera_shake(dir: Vector2) -> void:
	var tween: = get_tree().create_tween()
	tween.tween_property(GlobalVars.camera, "position", GlobalVars.camera.position + dir * SHAKE_DIST, SHAKE_FORWARD_TIME)
	tween.tween_property(GlobalVars.camera, "position", Vector2(0, 0), SHAKE_BACKWARD_TIME).set_trans(Tween.TRANS_SINE)

const scene_queen: PackedScene = preload("res://Scenes/Pieces/queen.tscn")
func restart_game() -> void:
	GlobalVars.queens_turn = false
	GlobalVars.num_moved = 0
	GlobalVars.points.points = 0
	GlobalVars.op_mode_bar.progress = 0
	
	for piece in GlobalVars.pieces.get_children():
		if not piece is Piece:
			continue
		
		piece.destroyed_animation()

	var queen: = scene_queen.instantiate()
	queen.position = Vector2(125, 215)
	GlobalVars.queen = queen

	var timer: = get_tree().create_timer(1)
	timer.timeout.connect(func():
		GlobalVars.pieces.add_child(queen)
	)

	var timer_0: = get_tree().create_timer(2)
	timer_0.timeout.connect(func():
		GlobalVars.queens_turn = true
	)

	GlobalVars.lose_message_show = false
