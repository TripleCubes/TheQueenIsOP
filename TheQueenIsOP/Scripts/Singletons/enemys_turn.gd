extends Node

const scene_pawn: PackedScene = preload("res://Scenes/Pieces/pawn.tscn")
const scene_rook: PackedScene = preload("res://Scenes/Pieces/rook.tscn")
const scene_bitshop: PackedScene = preload("res://Scenes/Pieces/bitshop.tscn")
const scene_knight: PackedScene = preload("res://Scenes/Pieces/knight.tscn")
const scene_king: PackedScene = preload("res://Scenes/Pieces/king.tscn")

var spawn_order: = [3, 1, 5, 2, 4, 0, 6,]

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
	var spawn_order_index: int = 0
	for i in amount:
		var pos = Vector2i(spawn_order[spawn_order_index], 0)
		var piece = GlobalFunctions.get_piece_at(pos)
		while piece != null:
			spawn_order_index += 1
			if spawn_order_index == 7:
				return
			pos = Vector2i(spawn_order[spawn_order_index], 0)
			piece = GlobalFunctions.get_piece_at(pos)

		var timer: = get_tree().create_timer(i * 0.1)
		timer.timeout.connect(func():
			var pawn: Piece = scene_pawn.instantiate()
			pawn.position = GlobalFunctions.board_pos_to_scene_pos(pos)
			GlobalVars.pieces.add_child(pawn)
		)
		spawn_order_index += 1
		if spawn_order_index == 7:
			return

func _get_all_enemy_pieces() -> Array:
	var result: = []

	for piece in GlobalVars.pieces.get_children():
		if not piece is Piece:
			continue

		if piece == GlobalVars.queen:
			continue

		result.append(piece)

	return result
