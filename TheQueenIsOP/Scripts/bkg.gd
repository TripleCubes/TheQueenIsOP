@tool
extends Node2D

const BOARD_WH: int = Consts.BOARD_WH;
const TILE_WH: float = Consts.TILE_WH;
const WINDOW_WH: float = Consts.WINDOW_WH;

const texture_valid_pos: = preload("res://Assets/UI/valid_pos.png")

func _ready():
	if Engine.is_editor_hint():
		return
		
	GlobalVars.queen.signal_moved.connect(queue_redraw)

func _draw():
	draw_rect(Rect2(-100, -100, WINDOW_WH + 200, WINDOW_WH + 200), Colors.BROWN)
	
	var margin: float = (WINDOW_WH - TILE_WH * BOARD_WH) / 2
	for x in BOARD_WH:
		var x_odd = x % 2 == 0
		for y in BOARD_WH:
			var y_odd = y % 2 == 0

			var color: Color
			if x_odd == y_odd:
				color = Colors.YELLOW
			else:
				color = Colors.LIGHT_BROWN

			draw_rect(Rect2(margin + TILE_WH * x, margin + TILE_WH * y, TILE_WH, TILE_WH), color)

			if not Engine.is_editor_hint() and GlobalVars.queens_turn \
			and GlobalVars.queen.get_pos_type(Vector2i(x, y)) != GlobalVars.queen.PosType.INVALID:
				draw_texture_rect(texture_valid_pos, Rect2(margin + TILE_WH * x, margin + TILE_WH * y, TILE_WH, TILE_WH), false)
