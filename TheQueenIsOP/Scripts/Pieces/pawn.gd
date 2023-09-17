extends Piece

const scene_rook: PackedScene = preload("res://Scenes/Pieces/rook.tscn")

func _ready():
	scene_destroyed = preload("res://Scenes/Pieces/pawn_destroyed.tscn")
	_spawn_animation()

func move() -> void:
	var check_pos_list: = []
	check_pos_list.append(self.board_pos + Vector2i(0, 1))
	check_pos_list.append(self.board_pos + Vector2i(-1, 1))
	check_pos_list.append(self.board_pos + Vector2i(1, 1))

	for check_pos in check_pos_list:
		if not GlobalFunctions.is_in_board(check_pos):
			continue

		var piece: = GlobalFunctions.get_piece_at(check_pos)
		if piece == GlobalVars.queen:
			_destroy_pieces(check_pos, Vector2(0, 0), false)
			_move_animation(check_pos)
			return

	var next_pos: = self.board_pos + Vector2i(0, 1)
	var piece: = GlobalFunctions.get_piece_at(next_pos)
	if piece != null:
		return

	_destroy_pieces(next_pos, Vector2(0, 0), false)
	_move_animation(next_pos)

	var timer: = get_tree().create_timer(Consts.MOVE_TIME 
											+ Consts.MOVE_HOLD_TIME 
											+ Consts.MOVE_PLACE_DOWN_TIME
											+ 0.3)
	timer.timeout.connect(func():
		if board_pos.y == 6:
			var rook: = scene_rook.instantiate()
			rook.position = GlobalFunctions.board_pos_to_scene_pos(self.board_pos)
			GlobalVars.pieces.add_child(rook)

			var timer_0: = get_tree().create_timer(0.18)
			timer_0.timeout.connect(func():
				destroyed_animation()
			)
	)

func moveable() -> Moveable:
	var check_pos_list: = []
	check_pos_list.append(self.board_pos + Vector2i(0, 1))
	check_pos_list.append(self.board_pos + Vector2i(-1, 1))
	check_pos_list.append(self.board_pos + Vector2i(1, 1))

	for check_pos in check_pos_list:
		if not GlobalFunctions.is_in_board(check_pos):
			continue

		var piece: = GlobalFunctions.get_piece_at(check_pos)
		if piece == GlobalVars.queen:
			return Moveable.CAN_TAKE_QUEEN

	var next_pos: = self.board_pos + Vector2i(0, 1)
	var piece: = GlobalFunctions.get_piece_at(next_pos)
	if piece == null:
		return Moveable.MOVEABLE

	return Moveable.NOT_MOVEABLE
