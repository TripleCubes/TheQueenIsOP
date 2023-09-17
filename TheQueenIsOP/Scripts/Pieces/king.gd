extends Piece

const scene_pawn: PackedScene = preload("res://Scenes/Pieces/pawn.tscn")

var num_move: int = 0

func _ready():
	scene_destroyed = preload("res://Scenes/Pieces/king_destroyed.tscn")
	_spawn_animation()

func move() -> void:
	num_move += 1
	if num_move % 3 == 0:
		_summon_pawns()
		return
	
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

func _distance_to_queen(in_board_pos: Vector2i) -> float:
	return Vector2(in_board_pos - GlobalVars.queen.board_pos).length()

func _get_valid_pos_list() -> Array:
	var result: = []

	result.append({
		pos = self.board_pos + Vector2i(-1, -1),
		check = [self.board_pos + Vector2i(-1, -1)],
	})
	result.append({
		pos = self.board_pos + Vector2i(0, -1),
		check = [self.board_pos + Vector2i(0, -1)],
	})
	result.append({
		pos = self.board_pos + Vector2i(1, -1),
		check = [self.board_pos + Vector2i(1, -1)],
	})

	result.append({
		pos = self.board_pos + Vector2i(-1, 0),
		check = [self.board_pos + Vector2i(-1, 0)],
	})
	result.append({
		pos = self.board_pos + Vector2i(1, 0),
		check = [self.board_pos + Vector2i(1, 0)],
	})

	result.append({
		pos = self.board_pos + Vector2i(-1, 1),
		check = [self.board_pos + Vector2i(-1, 1)],
	})
	result.append({
		pos = self.board_pos + Vector2i(0, 1),
		check = [self.board_pos + Vector2i(0, 1)],
	})
	result.append({
		pos = self.board_pos + Vector2i(1, 1),
		check = [self.board_pos + Vector2i(1, 1)],
	})

	return result

func _summon_pawns() -> void:
	var pos_list: = []
	pos_list.append(self.board_pos + Vector2i(-1, 0))
	pos_list.append(self.board_pos + Vector2i(0, 1))
	pos_list.append(self.board_pos + Vector2i(1, 0))

	for i in pos_list.size():
		var pos: Vector2i = pos_list[i]

		var piece: = GlobalFunctions.get_piece_at(pos)

		if piece != GlobalVars.queen and piece != null:
			continue

		if piece == GlobalVars.queen:
			GlobalVars.queen.destroyed_animation()

		var timer: = get_tree().create_timer(0.1 * i)
		timer.timeout.connect(func():
			var pawn: = scene_pawn.instantiate()
			pawn.position = GlobalFunctions.board_pos_to_scene_pos(pos)
			GlobalVars.pieces.add_child(pawn)
		)
