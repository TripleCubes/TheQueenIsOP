extends Piece

func _ready():
	scene_destroyed = preload("res://Scenes/Pieces/pawn_destroyed.tscn")

func move() -> void:
	_destroy_pieces(self.board_pos + Vector2i(0, 1), Vector2(0, 0))
	_move_animation(self.board_pos + Vector2i(0, 1))
