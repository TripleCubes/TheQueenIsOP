extends Piece

func _ready():
	scene_destroyed = preload("res://Scenes/Pieces/pawn_destroyed.tscn")
	_spawn_animation()

func move() -> void:
	var valid_pos_list: = _get_valid_pos_list()
	var found: = false
	var choosen_pos: = Vector2i(0, 0)
	var min_distance_min: int = 999999
	var min_distance_combined: int = 999999

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

		var distance_to_queen_horizontal: = _distance_to_queen_horizontal(pos.pos)
		var distance_to_queen_vertical: = _distance_to_queen_vertical(pos.pos)
		var distance_min: int = min(distance_to_queen_horizontal, distance_to_queen_vertical)
		if distance_min < min_distance_min:
			min_distance_min = distance_min
			min_distance_combined = 999999
			choosen_pos = pos.pos
			found = true
			continue

		if distance_min == min_distance_min:
			var distance_combined = distance_to_queen_horizontal + distance_to_queen_vertical
			if distance_combined < min_distance_combined:
				min_distance_combined = distance_combined
				choosen_pos = pos.pos
		
	if found:
		_destroy_pieces(choosen_pos, Vector2(0, 0))
		_move_animation(choosen_pos)

func _distance_to_queen_horizontal(in_board_pos: Vector2i) -> int:
	return abs(in_board_pos.x - GlobalVars.queen.board_pos.x)

func _distance_to_queen_vertical(in_board_pos: Vector2i) -> int:
	return abs(in_board_pos.y - GlobalVars.queen.board_pos.y)

func _get_valid_pos_list() -> Array:
	var result: = []

	result.append({
		pos = self.board_pos + Vector2i(0, -1),
		check = [self.board_pos + Vector2i(0, -1)],
	})
	result.append({
		pos = self.board_pos + Vector2i(0, -2),
		check = [self.board_pos + Vector2i(0, -2), self.board_pos + Vector2i(0, -1)],
	})

	result.append({
		pos = self.board_pos + Vector2i(0, 1),
		check = [self.board_pos + Vector2i(0, 1)],
	})
	result.append({
		pos = self.board_pos + Vector2i(0, 2),
		check = [self.board_pos + Vector2i(0, 2), self.board_pos + Vector2i(0, 1)],
	})

	result.append({
		pos = self.board_pos + Vector2i(-1, 0),
		check = [self.board_pos + Vector2i(-1, 0)],
	})
	result.append({
		pos = self.board_pos + Vector2i(-2, 0),
		check = [self.board_pos + Vector2i(-2, 0), self.board_pos + Vector2i(-1, 0)],
	})

	result.append({
		pos = self.board_pos + Vector2i(1, 0),
		check = [self.board_pos + Vector2i(1, 0)],
	})
	result.append({
		pos = self.board_pos + Vector2i(2, 0),
		check = [self.board_pos + Vector2i(2, 0), self.board_pos + Vector2i(1, 0)],
	})

	return result
