extends Node

const scene_pawn: PackedScene = preload("res://Scenes/Pieces/pawn.tscn")

func decide() -> void:
	var move_result: = _move(3)

	var timer: = get_tree().create_timer(move_result.moved_time + 0.2)
	timer.timeout.connect(func():
		_spawn(3 - move_result.piece_count)
	)

	var timer_0: = get_tree().create_timer(move_result.moved_time + 0.1 * (3 - move_result.piece_count) + 0.8 + 0.2)
	timer_0.timeout.connect(func():
		GlobalVars.queens_turn = true
	)

func _move(amount: int) -> Dictionary:
	var piece_list: = _get_all_enemy_pieces()
	var can_take_queen_list: = []
	var moveable_list: = []
	var combined_list: = []

	for piece in piece_list:
		if piece.moveable() == Piece.Moveable.CAN_TAKE_QUEEN:
			can_take_queen_list.append(piece)

	for piece in piece_list:
		if piece.moveable() == Piece.Moveable.MOVEABLE:
			moveable_list.append(piece)

	can_take_queen_list.shuffle()
	moveable_list.shuffle()
	combined_list = can_take_queen_list + moveable_list

	amount = min(amount, combined_list.size())
	
	var move_time: = (Consts.MOVE_TIME 
						+ Consts.MOVE_PLACE_DOWN_TIME 
						+ Consts.MOVE_HOLD_TIME 
						+ 0.02)
	for i in amount:
		var piece: Piece = combined_list[i]
			
		var timer: = get_tree().create_timer(i * move_time)
		timer.timeout.connect(func():
			piece.move()
		)

	return {
		piece_count = piece_list.size(),
		moved_time = move_time * amount,
	}

func _spawn(amount: int) -> void:
	for i in amount:
		var pos = Vector2i(3 - floor(amount / float(2)) + i, 0)
		var piece = GlobalFunctions.get_piece_at(pos)
		if piece != null:
			continue

		var timer: = get_tree().create_timer(i * 0.1)
		timer.timeout.connect(func():
			var pawn: Piece = scene_pawn.instantiate()
			pawn.position = GlobalFunctions.board_pos_to_scene_pos(pos)
			GlobalVars.pieces.add_child(pawn)
		)

func _get_all_enemy_pieces() -> Array:
	var result: = []

	for piece in GlobalVars.pieces.get_children():
		if not piece is Piece:
			continue

		if piece == GlobalVars.queen:
			continue

		result.append(piece)

	return result
