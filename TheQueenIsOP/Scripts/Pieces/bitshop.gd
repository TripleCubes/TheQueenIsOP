extends Piece

func _ready():
	scene_destroyed = preload("res://Scenes/Pieces/pawn_destroyed.tscn")
	points = PointList.point_list.bitshop
	_spawn_animation()

func move() -> void:
	var valid_pos_list: = _get_valid_pos_list()
	var found: = false
	var choosen_pos: = Vector2i(0, 0)
	var min_distance: float = 999999

	for pos in valid_pos_list:
		var cant_move: = false
		for check in pos.check:
			var piece: = GlobalFunctions.get_piece_at(check)
			if piece != GlobalVars.queen and piece != null:
				cant_move = true
				break

			if not GlobalFunctions.is_in_board(check):
				cant_move = true
				break
		
		if cant_move:
			continue

		var distance = _distance_to_queen(pos.pos)
		if distance < min_distance:
			min_distance = distance
			choosen_pos = pos.pos
			found = true
		
	if found:
		_destroy_pieces(choosen_pos, Vector2(0, 0), false)
		_move_animation(choosen_pos)

func moveable() -> Moveable:
	var check_pos_list: = []
	check_pos_list.append({
		pos = self.board_pos + Vector2i(-1, -1),
		check_for_queen = self.board_pos + Vector2i(-2, -2),
	})
	check_pos_list.append({
		pos = self.board_pos + Vector2i(-1, 1),
		check_for_queen = self.board_pos + Vector2i(-2, 2),
	})
	check_pos_list.append({
		pos = self.board_pos + Vector2i(1, -1),
		check_for_queen = self.board_pos + Vector2i(2, -2),
	})
	check_pos_list.append({
		pos = self.board_pos + Vector2i(1, 1),
		check_for_queen = self.board_pos + Vector2i(2, 2),
	})

	for pos in check_pos_list:
		var piece: = GlobalFunctions.get_piece_at(pos.pos)
		if piece == GlobalVars.queen:
			return Moveable.CAN_TAKE_QUEEN
		
	for pos in check_pos_list:
		var piece: = GlobalFunctions.get_piece_at(pos.pos)
		if piece == null:
			var piece_0: = GlobalFunctions.get_piece_at(pos.check_for_queen)
			if piece_0 == GlobalVars.queen:
				return Moveable.CAN_TAKE_QUEEN

	for pos in check_pos_list:
		var piece: = GlobalFunctions.get_piece_at(pos.pos)
		if piece == null:
			return Moveable.MOVEABLE

	return Moveable.NOT_MOVEABLE

func _distance_to_queen(in_board_pos: Vector2i) -> float:
	return Vector2(in_board_pos - GlobalVars.queen.board_pos).length()

func _get_valid_pos_list() -> Array:
	var result: = []

	result.append({
		pos = self.board_pos + Vector2i(-1, -1),
		check = [self.board_pos + Vector2i(-1, -1)],
	})
	result.append({
		pos = self.board_pos + Vector2i(-2, -2),
		check = [self.board_pos + Vector2i(-2, -2), self.board_pos + Vector2i(-1, -1)],
	})

	result.append({
		pos = self.board_pos + Vector2i(1, 1),
		check = [self.board_pos + Vector2i(1, 1)],
	})
	result.append({
		pos = self.board_pos + Vector2i(2, 2),
		check = [self.board_pos + Vector2i(2, 2), self.board_pos + Vector2i(1, 1)],
	})

	result.append({
		pos = self.board_pos + Vector2i(-1, 1),
		check = [self.board_pos + Vector2i(-1, 1)],
	})
	result.append({
		pos = self.board_pos + Vector2i(-2, 2),
		check = [self.board_pos + Vector2i(-2, 2), self.board_pos + Vector2i(-1, 1)],
	})

	result.append({
		pos = self.board_pos + Vector2i(1, -1),
		check = [self.board_pos + Vector2i(1, -1)],
	})
	result.append({
		pos = self.board_pos + Vector2i(2, -2),
		check = [self.board_pos + Vector2i(2, -2), self.board_pos + Vector2i(1, -1)],
	})

	return result
