extends Node

func decide() -> void:
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

func _move() -> void:
	pass

func _spawn() -> void:
	pass
