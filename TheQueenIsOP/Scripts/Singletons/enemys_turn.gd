extends Node

const scene_pawn: PackedScene = preload("res://Scenes/Pieces/pawn.tscn")

func decide() -> void:
	_move(0)
	_spawn(3)

func _move(amount: int) -> void:
	for piece in GlobalVars.pieces.get_children():
		if not piece is Piece:
			continue
			
		if piece == GlobalVars.queen:
			continue
			
		piece.move()

	var timer_0: = get_tree().create_timer(Consts.MOVE_TIME + Consts.MOVE_PLACE_DOWN_TIME 
											+ Consts.MOVE_HOLD_TIME + Consts.AFTER_MOVE_DELAY)
	timer_0.timeout.connect(func():
		GlobalVars.queens_turn = true
		GlobalVars.bkg.queue_redraw()
	)

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
