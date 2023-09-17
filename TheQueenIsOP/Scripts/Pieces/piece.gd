class_name Piece
extends Node2D

const MOVE_HEIGHT: float = 10

const scene_destroyed_shard: PackedScene = preload("res://Scenes/Pieces/destroyed_shard.tscn")
var scene_destroyed: PackedScene

var board_pos: Vector2i:
	get:
		return GlobalFunctions.scene_pos_to_board_pos(self.position)

func move() -> void:
	pass

func destroyed_animation() -> void:
	for i in 5:
		var destroyed_shard = scene_destroyed_shard.instantiate()
		destroyed_shard.h = randf_range(10, 20)
		destroyed_shard.dir = GlobalFunctions.get_random_dir()
		destroyed_shard.velocity = randf_range(60, 80)
		destroyed_shard.position = self.position
		GlobalVars.pieces.add_child(destroyed_shard)

	queue_free()

func destroyed_animation_dir(dir: Vector2, leave_destroyed_piece: bool) -> void:
	if leave_destroyed_piece:
		var destroyed_piece: DestroyedPiece = scene_destroyed.instantiate()
		destroyed_piece.position = self.position
		GlobalVars.pieces.add_child(destroyed_piece)

	for i in 5:
		var destroyed_shard = scene_destroyed_shard.instantiate()
		destroyed_shard.h = randf_range(10, 20)
		destroyed_shard.dir = dir.rotated(deg_to_rad(randf_range(-30, 30)))
		destroyed_shard.velocity = randf_range(100, 200)
		destroyed_shard.position = self.position
		GlobalVars.pieces.add_child(destroyed_shard)

	queue_free()

func _spawn_animation():
	var original_pos = self.position
	self.position += Vector2(0, -20)
	var tween: = get_tree().create_tween()
	tween.tween_property(self, "position", original_pos, 0.2)

func _destroy_pieces(next_board_pos: Vector2i, dir: Vector2, dash: bool) -> void:
	var differences: = next_board_pos - self.board_pos

	var cursor: = self.board_pos
	var step_dir: = differences
	var step_count: int = 0
	if step_dir.x != 0:
		step_dir.x = step_dir.x / abs(step_dir.x)
		step_count = abs(next_board_pos.x - self.board_pos.x)
	if step_dir.y != 0:
		step_dir.y = step_dir.y / abs(step_dir.y)
		step_count = abs(next_board_pos.y - self.board_pos.y)

	if not dash:
		var piece: = GlobalFunctions.get_piece_at(next_board_pos)
		if piece != null:
			var timer: = get_tree().create_timer(Consts.MOVE_TIME + Consts.MOVE_HOLD_TIME + Consts.MOVE_PLACE_DOWN_TIME - 0.1)
			timer.timeout.connect(func():
				piece.destroyed_animation()
			)
		return

	cursor += step_dir
	for i in step_count:
		var piece: = GlobalFunctions.get_piece_at(cursor)
		
		if piece == null:
			cursor += step_dir
			continue

		if piece.board_pos == next_board_pos:
			var timer: = get_tree().create_timer(Consts.DASH_TIME / step_count * i)
			timer.timeout.connect(func():
				piece.destroyed_animation_dir(dir, false)
			)
		else:
			var timer: = get_tree().create_timer(Consts.DASH_TIME / step_count * i)
			timer.timeout.connect(func():
				piece.destroyed_animation_dir(dir, true)
			)

		cursor += step_dir

func _move_animation(next_board_pos: Vector2i) -> void:
	var tween_0_pos: = GlobalFunctions.board_pos_to_scene_pos(next_board_pos)
	var tween_0: = get_tree().create_tween()
	tween_0.tween_property(self, "position", tween_0_pos - Vector2(0, MOVE_HEIGHT), Consts.MOVE_TIME).set_trans(Tween.TRANS_SINE)
	tween_0.tween_property(self, "position", tween_0_pos - Vector2(0, MOVE_HEIGHT), Consts.MOVE_HOLD_TIME).set_trans(Tween.TRANS_SINE)
	tween_0.tween_property(self, "position", tween_0_pos, Consts.MOVE_PLACE_DOWN_TIME).set_trans(Tween.TRANS_SINE)

func _move_animation_dash(next_board_pos: Vector2i) -> void:
	var current_board_pos: = self.board_pos

	var timer: = get_tree().create_timer(Consts.DASH_TIME)
	timer.timeout.connect(func():
		GlobalFunctions.camera_shake(Vector2((current_board_pos - next_board_pos)).normalized())
	)

	var tween_0_pos: = GlobalFunctions.board_pos_to_scene_pos(next_board_pos)
	var tween_0: = get_tree().create_tween()
	tween_0.tween_property(self, "position", tween_0_pos, Consts.DASH_TIME)
