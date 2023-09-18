extends Node

const scene_pawn: PackedScene = preload("res://Scenes/Pieces/pawn.tscn")
const scene_rook: PackedScene = preload("res://Scenes/Pieces/rook.tscn")
const scene_bitshop: PackedScene = preload("res://Scenes/Pieces/bitshop.tscn")
const scene_knight: PackedScene = preload("res://Scenes/Pieces/knight.tscn")
const scene_king: PackedScene = preload("res://Scenes/Pieces/king.tscn")

@onready var piece_scene_list: = [
	{
		scene = scene_pawn,
		points = PointsList.points_list.pawn,	
	},
	{
		scene = scene_rook,
		points = PointsList.points_list.rook,	
	},
	{
		scene = scene_bitshop,
		points = PointsList.points_list.bitshop,		
	},
	{
		scene = scene_knight,
		points = PointsList.points_list.knight,		
	},
	{
		scene = scene_king,
		points = PointsList.points_list.king,
	},
]

func decide() -> void:
	var num_spawn: = _get_num_spawn()
	var move_result: = _move(num_spawn)

	var timer: = get_tree().create_timer(move_result.moved_time + 0.2)
	timer.timeout.connect(func():
		_spawn(num_spawn - move_result.piece_count)
	)

	var timer_0: = get_tree().create_timer(move_result.moved_time + 0.1 * (num_spawn - move_result.piece_count) + 0.8 + 0.2)
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
	var total_point_spawn: = _get_total_points_spawn()

	var spawn_order_index: int = 0
	for i in amount:
		var availabe_spawn_pos_list: = _get_available_spawn_pos_list()
		if availabe_spawn_pos_list.size() == 0:
			return
		var pos_index: = randi_range(0, availabe_spawn_pos_list.size() - 1)
		var pos = availabe_spawn_pos_list[pos_index]

		var timer: = get_tree().create_timer(i * 0.1)
		timer.timeout.connect(func():
			var piece_scene_index: = randi_range(0, 4)
			while piece_scene_list[piece_scene_index].points > total_point_spawn:
				piece_scene_index = randi_range(0, 4)
			var piece_spawn: Piece = piece_scene_list[piece_scene_index].scene.instantiate()
			piece_spawn.position = GlobalFunctions.board_pos_to_scene_pos(pos)
			GlobalVars.pieces.add_child(piece_spawn)
		)
		spawn_order_index += 1
		if spawn_order_index == 7:
			return

func _get_available_spawn_pos_list() -> Array:
	var result: = []
	for x in 7:
		for y in 2:
			var piece: = GlobalFunctions.get_piece_at(Vector2i(x, y))
			if piece != null:
				continue
			
			result.append(Vector2i(x, y))
	
	return result

func _get_all_enemy_pieces() -> Array:
	var result: = []

	for piece in GlobalVars.pieces.get_children():
		if not piece is Piece:
			continue

		if piece == GlobalVars.queen:
			continue

		result.append(piece)

	return result

func _get_num_spawn() -> int:
	var num_spawn: float = float(GlobalVars.num_moved) / 6
	return max(1, min(7, floor(num_spawn)))

func _get_total_points_spawn() -> int:
	return floor(float(GlobalVars.num_moved) / 3 + 1)
