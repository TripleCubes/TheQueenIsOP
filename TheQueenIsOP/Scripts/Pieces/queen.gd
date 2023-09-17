extends Piece

const DASH_DISTANCE: int = 2

enum Dir {
	TOP,
	BOTTOM,
	LEFT,
	RIGHT,
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
}

enum PosType {
	INVALID,
	MOVE,
	DASH,
}

func queen_move(in_board_pos: Vector2i) -> void:
	_destroy_pieces(in_board_pos, Vector2(0, 0), false)
	_queen_move_shared(Consts.MOVE_TIME + Consts.MOVE_PLACE_DOWN_TIME 
						+ Consts.MOVE_HOLD_TIME + 0.4)
	_move_animation(in_board_pos)

func queen_dash(in_board_pos: Vector2i) -> void:
	_destroy_pieces(in_board_pos, Vector2((in_board_pos - self.board_pos)).normalized(), true)
	_queen_move_shared(Consts.DASH_TIME + 1)
	_move_animation_dash(in_board_pos)

func _queen_move_shared(time_until_enemys_turn: float) -> void:
	GlobalVars.queens_turn = false

	var timer_0: = get_tree().create_timer(time_until_enemys_turn)
	timer_0.timeout.connect(func():
		EnemysTurn.decide()
	)

func get_pos_type(in_board_pos: Vector2i) -> PosType:
	if not GlobalFunctions.is_in_board(in_board_pos):
		return PosType.INVALID

	if in_board_pos == self.board_pos:
		return PosType.INVALID

	if (in_board_pos.x == self.board_pos.x + 1 \
		or in_board_pos.x == self.board_pos.x - 1 \
		or in_board_pos.x == self.board_pos.x) \
	and (in_board_pos.y == self.board_pos.y + 1 \
		or in_board_pos.y == self.board_pos.y - 1 \
		or in_board_pos.y == self.board_pos.y):
		return PosType.MOVE

	if (in_board_pos.x == self.board_pos.x + DASH_DISTANCE \
		or in_board_pos.x == self.board_pos.x - DASH_DISTANCE \
		or in_board_pos.x == self.board_pos.x) \
	and (in_board_pos.y == self.board_pos.y + DASH_DISTANCE \
		or in_board_pos.y == self.board_pos.y - DASH_DISTANCE \
		or in_board_pos.y == self.board_pos.y):
		return PosType.DASH

	return PosType.INVALID

func _ready():
	_spawn_animation()

func _process(_delta):
	_mouse_press_process()
	
func _mouse_press_process():
	if not Input.is_action_just_pressed("MOUSE_LEFT"):
		return

	if not GlobalVars.queens_turn:
		return

	var mouse_board_pos: = GlobalFunctions.get_mouse_board_pos()
	var pos_type: = get_pos_type(mouse_board_pos)
	if pos_type == PosType.INVALID:
		return
	
	if pos_type == PosType.MOVE:
		queen_move(mouse_board_pos)
	
	if pos_type == PosType.DASH:
		queen_dash(mouse_board_pos)
