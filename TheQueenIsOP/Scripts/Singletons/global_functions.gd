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
